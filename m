Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201AbbA0Pto (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 10:49:44 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:46519 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148AbbA0Ptm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 10:49:42 -0500
Message-ID: <54C7B391.4000103@linaro.org>
Date: Tue, 27 Jan 2015 15:49:37 +0000
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Eduardo Valentin <edubezval@gmail.com>
CC: linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH] thermal: Fix examples in DT documentation
References: <1422355847-23549-1-git-send-email-srinivas.kandagatla@linaro.org> <20150127150737.GC29600@developer.hsd1.ca.comcast.net>
In-Reply-To: <20150127150737.GC29600@developer.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 27/01/15 15:07, Eduardo Valentin wrote:
> Hello Srinivas,
>
> Just a minor request in the end:
>
Sure, I will fix the other issues you spotted too in next version.
>> ---
>>   .../devicetree/bindings/thermal/thermal.txt        | 44 +++++++++++-----------
>>   1 file changed, 22 insertions(+), 22 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/thermal/thermal.txt b/Documentation/devicetree/bindings/thermal/thermal.txt
>> index f5db6b7..97ed14e 100644
>> --- a/Documentation/devicetree/bindings/thermal/thermal.txt
>> +++ b/Documentation/devicetree/bindings/thermal/thermal.txt
>> @@ -251,24 +251,24 @@ ocp {
>>   };
>>
>>   thermal-zones {
>> -	cpu-thermal: cpu-thermal {
>> +	cpu_thermal: cpu-thermal {
>>   		polling-delay-passive = <250>; /* milliseconds */
>>   		polling-delay = <1000>; /* milliseconds */
>>
>>   		thermal-sensors = <&bandgap0>;
>>
>>   		trips {
>> -			cpu-alert0: cpu-alert {
>> +			cpu_alert0: cpu-alert0 {
>>   				temperature = <90000>; /* millicelsius */
>>   				hysteresis = <2000>; /* millicelsius */
>>   				type = "active";
>>   			};
>> -			cpu-alert1: cpu-alert {
>> +			cpu_alert1: cpu-alert1 {
>>   				temperature = <100000>; /* millicelsius */
>>   				hysteresis = <2000>; /* millicelsius */
>>   				type = "passive";
>>   			};
>> -			cpu-crit: cpu-crit {
>> +			cpu_crit: cpu-crit {
>>   				temperature = <125000>; /* millicelsius */
>>   				hysteresis = <2000>; /* millicelsius */
>>   				type = "critical";
>> @@ -277,17 +277,17 @@ thermal-zones {
>>
>>   		cooling-maps {
>>   			map0 {
>> -				trip = <&cpu-alert0>;
>> -				cooling-device = <&fan0 THERMAL_NO_LIMITS 4>;
>> +				trip = <&cpu_alert0>;
>> +				cooling-device = <&fan0 THERMAL_NO_LIMIT 4>;
>>   			};
>>   			map1 {
>> -				trip = <&cpu-alert1>;
>> -				cooling-device = <&fan0 5 THERMAL_NO_LIMITS>;
>> +				trip = <&cpu_alert1>;
>> +				cooling-device = <&fan0 5 THERMAL_NO_LIMIT>;
>>   			};
>>   			map2 {
>> -				trip = <&cpu-alert1>;
>> +				trip = <&cpu_alert1>;
>>   				cooling-device =
>> -				    <&cpu0 THERMAL_NO_LIMITS THERMAL_NO_LIMITS>;
>> +				    <&cpu0 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
>>   			};
>>   		};
>>   	};
>> @@ -298,13 +298,13 @@ used to monitor the zone 'cpu-thermal' using its sole sensor. A fan
>>   device (fan0) is controlled via I2C bus 1, at address 0x48, and has ten
>>   different cooling states 0-9. It is used to remove the heat out of
>>   the thermal zone 'cpu-thermal' using its cooling states
>> -from its minimum to 4, when it reaches trip point 'cpu-alert0'
>> +from its minimum to 4, when it reaches trip point 'cpu_alert0'
>>   at 90C, as an example of active cooling. The same cooling device is used at
>> -'cpu-alert1', but from 5 to its maximum state. The cpu@0 device is also
>> +'cpu_alert1', but from 5 to its maximum state. The cpu@0 device is also
>>   linked to the same thermal zone, 'cpu-thermal', as a passive cooling device,
>> -using all its cooling states at trip point 'cpu-alert1',
>> +using all its cooling states at trip point 'cpu_alert1',
>>   which is a trip point at 100C. On the thermal zone 'cpu-thermal', at the
>> -temperature of 125C, represented by the trip point 'cpu-crit', the silicon
>> +temperature of 125C, represented by the trip point 'cpu_crit', the silicon
>>   is not reliable anymore.
>>
>>   (b) - IC with several internal sensors
>> @@ -329,7 +329,7 @@ ocp {
>>   };
>>
>>   thermal-zones {
>> -	cpu-thermal: cpu-thermal {
>> +	cpu_thermal: cpu-thermal {
>>   		polling-delay-passive = <250>; /* milliseconds */
>>   		polling-delay = <1000>; /* milliseconds */
>>
>> @@ -338,12 +338,12 @@ thermal-zones {
>>
>>   		trips {
>>   			/* each zone within the SoC may have its own trips */
>> -			cpu-alert: cpu-alert {
>> +			cpu_alert: cpu-alert {
>>   				temperature = <100000>; /* millicelsius */
>>   				hysteresis = <2000>; /* millicelsius */
>>   				type = "passive";
>>   			};
>> -			cpu-crit: cpu-crit {
>> +			cpu_crit: cpu-crit {
>>   				temperature = <125000>; /* millicelsius */
>>   				hysteresis = <2000>; /* millicelsius */
>>   				type = "critical";
>> @@ -365,12 +365,12 @@ thermal-zones {
>>
>>   		trips {
>>   			/* each zone within the SoC may have its own trips */
>> -			gpu-alert: gpu-alert {
>> +			gpu_alert: gpu-alert {
>>   				temperature = <90000>; /* millicelsius */
>>   				hysteresis = <2000>; /* millicelsius */
>>   				type = "passive";
>>   			};
>> -			gpu-crit: gpu-crit {
>> +			gpu_crit: gpu-crit {
>>   				temperature = <105000>; /* millicelsius */
>>   				hysteresis = <2000>; /* millicelsius */
>>   				type = "critical";
>> @@ -392,12 +392,12 @@ thermal-zones {
>>
>>   		trips {
>>   			/* each zone within the SoC may have its own trips */
>> -			dsp-alert: gpu-alert {
>> +			dsp_alert: gpu-alert {
>
> I suppose the original text has a typo, it should be:
>
> +			dsp_alert: dsp-alert {
>
>>   				temperature = <90000>; /* millicelsius */
>>   				hysteresis = <2000>; /* millicelsius */
>>   				type = "passive";
>>   			};
>> -			dsp-crit: gpu-crit {
>> +			dsp_crit: gpu-crit {
>>   				temperature = <135000>; /* millicelsius */
>>   				hysteresis = <2000>; /* millicelsius */
>>   				type = "critical";
>> @@ -457,7 +457,7 @@ ocp {
>>   };
>>
>>   thermal-zones {
>> -	cpu-thermal: cpu-thermal {
>> +	cpu_thermal: cpu-thermal {
>>   		polling-delay-passive = <250>; /* milliseconds */
>>   		polling-delay = <1000>; /* milliseconds */
>>
>
> While here, can you please include in your patch fixes for remaining
> examples? From quick look, 'board-thermal', 'adc-dummy', and
> 'dsp-thermal' are occurrences of the same problem you fixing in other
> parts of the file.
>
>> --
>> 1.9.1
>>
