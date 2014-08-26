Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933817AbaHZCYJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 22:24:09 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:6234 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbaHZCYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 22:24:08 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 25 Aug 2014 19:14:08 -0700
Message-ID: <53FBEFEA.8050706@nvidia.com>
Date: Tue, 26 Aug 2014 10:24:42 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Eduardo Valentin <edubezval@gmail.com>
CC: <khali@linux-fr.org>, <linux@roeck-us.net>, <swarren@wwwdotorg.org>,
        <lm-sensors@lm-sensors.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 4/4] ARM: tegra: dalmore: add thermal zones for nct1008
References: <1408948188-4181-1-git-send-email-wni@nvidia.com> <1408948188-4181-5-git-send-email-wni@nvidia.com> <20140825111041.GC12349@developer>
In-Reply-To: <20140825111041.GC12349@developer>
X-Originating-IP: [10.19.224.131]
X-ClientProxiedBy: HKMAIL101.nvidia.com (10.18.16.10) To
 HKMAIL101.nvidia.com (10.18.16.10)
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2014 07:10 PM, Eduardo Valentin wrote:
> On Mon, Aug 25, 2014 at 02:29:48PM +0800, Wei Ni wrote:
>> From: lightning314 <wni@nvidia.com>
>>
>> Add dt node to describe the thermal zone for the nct1008.
>>
>> Signed-off-by: Wei Ni <wni@nvidia.com>
>> ---
>>  arch/arm/boot/dts/tegra114-dalmore.dts | 20 +++++++++++++++++++-
>>  1 file changed, 19 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts
>> index 5c21d21..94a1b5d 100644
>> --- a/arch/arm/boot/dts/tegra114-dalmore.dts
>> +++ b/arch/arm/boot/dts/tegra114-dalmore.dts
>> @@ -779,12 +779,14 @@
>>  				<&gpio TEGRA_GPIO(V, 3) GPIO_ACTIVE_HIGH>;
>>  		};
>>  
>> -		temperature-sensor@4c {
>> +		nct1008: temperature-sensor@4c {
>>  			compatible = "onnn,nct1008";
>>  			reg = <0x4c>;
>>  			vcc-supply = <&palmas_ldo6_reg>;
>>  			interrupt-parent = <&gpio>;
>>  			interrupts = <TEGRA_GPIO(O, 4) IRQ_TYPE_LEVEL_LOW>;
>> +
>> +			#thermal-sensor-cells = <1>;
>>  		};
>>  	};
>>  
>> @@ -1283,4 +1285,20 @@
>>  			 <&tegra_car TEGRA114_CLK_EXTERN1>;
>>  		clock-names = "pll_a", "pll_a_out0", "mclk";
>>  	};
>> +
>> +	thermal-zones {
>> +		nct1008-local {
> 
> at this level, can the thermal zone name be a meaningful string? What
> part of the hardware does the local and remote monitors the the dalmore
> platform?

Oh, yes, you are right.
I think it's better to use "board_thermal_sensor: nct1008-local" and
"diode_thermal_sensor: nct1008-remote".

Thanks.
Wei.

> 
>> +			polling-delay-passive = <2000>; /* milliseconds */
>> +			polling-delay = <0>; /* milliseconds */
>> +
>> +			thermal-sensors = <&nct1008 0>;
>> +		};
>> +
>> +		nct1008-remote {
>> +			polling-delay-passive = <1000>; /* milliseconds */
>> +			polling-delay = <0>; /* milliseconds */
>> +
>> +			thermal-sensors = <&nct1008 1>;
>> +		};
>> +	};
>>  };
>> -- 
>> 1.8.1.5
>>

