"""
DOLPHYN: Decision Optimization for Low-carbon Power and Hydrogen Networks
Copyright (C) 2022,  Massachusetts Institute of Technology
This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
A complete copy of the GNU General Public License v2 (GPLv2) is available
in LICENSE.txt.  Users uncompressing this from an archive may not have
received this license file.  If not, see <http://www.gnu.org/licenses/>.
"""

@doc raw"""
    load_h2_generators_variability(setup::Dict, path::AbstractString, sep::AbstractString, inputs_genvar::Dict)

Function for reading input parameters related to hourly maximum capacity factors for all hydrogen generators (plus storage).
"""
function load_h2_generators_variability(setup::Dict, path::AbstractString, sep::AbstractString, inputs_genvar::Dict)

    # Hourly capacity factors
    #data_directory = data_directory = joinpath(path, setup["TimeDomainReductionFolder"])
    data_directory = joinpath(path, setup["TimeDomainReductionFolder"])
    if setup["TimeDomainReduction"] == 1  && isfile(joinpath(data_directory,"HSC_generators_variability.csv")) # Use Time Domain Reduced data for GenX
        gen_var = DataFrame(CSV.File(string(joinpath(data_directory,"HSC_generators_variability.csv")), header=true), copycols=true)
    else # Run without Time Domain Reduction OR Getting original input data for Time Domain Reduction
        gen_var = DataFrame(CSV.File(joinpath(path, "HSC_generators_variability.csv"), header=true), copycols=true)
    end

    # Reorder DataFrame to R_ID order (order provided in Generators_data.csv)
    select!(gen_var, [:Time_Index; Symbol.(inputs_genvar["H2_RESOURCES_NAME"]) ])

    # Maximum power output and variability of each energy resource
    inputs_genvar["pH2_Max"] = transpose(Matrix{Float64}(gen_var[1:inputs_genvar["T"],2:(inputs_genvar["H2_RES_ALL"]+1)]))

    print_and_log(" -- HSC_generators_variability.csv Successfully Read!")

    return inputs_genvar
end
