Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbaKDLRj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 06:17:39 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:34559 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373AbaKDLQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 06:16:28 -0500
Message-ID: <5458B563.7080302@ti.com>
Date: Tue, 4 Nov 2014 16:45:47 +0530
From: Vignesh R <vigneshr@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 3/3] arm: boot: dts: am4372: add tscadc DT entries for
 am437x-evm and am43x-epos-evm
References: <1414741603-18233-1-git-send-email-vigneshr@ti.com> <1414741603-18233-4-git-send-email-vigneshr@ti.com> <20141031134656.GC24708@kahuna>
In-Reply-To: <20141031134656.GC24708@kahuna>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Friday 31 October 2014 07:16 PM, Nishanth Menon wrote:
> On 13:16-20141031, Vignesh R wrote:
>> This patch adds tscadc DT entries for am437x-gp-evm and am43x-epos-evm.
>>
>> Signed-off-by: Vignesh R <vigneshr@ti.com>
>> ---
>>  arch/arm/boot/dts/am4372.dtsi        | 20 ++++++++++++++++++++
>>  arch/arm/boot/dts/am437x-gp-evm.dts  |  8 ++++++++
>>  arch/arm/boot/dts/am43x-epos-evm.dts |  8 ++++++++
> 
> I personally prefer the soc dt split off from board dt, but others
> prefer this as done here.. no objections either way.
> 
>>  3 files changed, 36 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.dtsi
>> index 46660ffd2b65..fd2de8f256e6 100644
>> --- a/arch/arm/boot/dts/am4372.dtsi
>> +++ b/arch/arm/boot/dts/am4372.dtsi
>> @@ -667,6 +667,26 @@
>>  			};
>>  		};
>>  
>> +		tscadc: tscadc@44e0d000 {
>> +			compatible = "ti,am4372-tscadc","ti,am3359-tscadc";
> ^^ bindings ?
> $ git grep ti,am4372-tscadc Documentation/devicetree/bindings/
> 	returns nothing as of 3.18-rc2
> 

I will drop unused ti,am4372-tscadc.

>> +			reg = <0x44e0d000 0x1000>;
>> +			ti,hwmods = "adc_tsc";
>> +			interrupts = <GIC_SPI 16 IRQ_TYPE_LEVEL_HIGH>;
>> +			clocks = <&adc_tsc_fck>;
>> +			clock-names = "fck";
>> +			status = "disabled";
>> +
>> +			tsc {
>> +				compatible = "ti,am4372-tsc", "ti,am3359-tsc";
>> +			};
>> +
>> +			adc {
>> +				#io-channel-cells = <1>;
>> +				compatible = "ti,am4372-adc", "ti,am3359-adc";
>> +			};
>> +
>> +		};
>> +
>>  		sham: sham@53100000 {
>>  			compatible = "ti,omap5-sham";
>>  			ti,hwmods = "sham";
>> diff --git a/arch/arm/boot/dts/am437x-gp-evm.dts b/arch/arm/boot/dts/am437x-gp-evm.dts
>> index e7ac47fa6615..2ffd6d6dcc87 100644
>> --- a/arch/arm/boot/dts/am437x-gp-evm.dts
>> +++ b/arch/arm/boot/dts/am437x-gp-evm.dts
>> @@ -343,6 +343,14 @@
>>  	status = "okay";
>>  };
>>  
>> +&tscadc {
>> +	status = "okay";
>> +
>> +	adc {
>> +		ti,adc-channels = <0 1 2 3 4 5 6 7>;
>> +	};
>> +};
>> +
>>  &ecap0 {
>>  	status = "okay";
>>  	pinctrl-names = "default";
>> diff --git a/arch/arm/boot/dts/am43x-epos-evm.dts b/arch/arm/boot/dts/am43x-epos-evm.dts
>> index ac3e4859935f..f9bc607f3b3a 100644
>> --- a/arch/arm/boot/dts/am43x-epos-evm.dts
>> +++ b/arch/arm/boot/dts/am43x-epos-evm.dts
>> @@ -519,6 +519,14 @@
>>  	status = "okay";
>>  };
>>  
>> +&tscadc {
>> +	status = "okay";
>> +
>> +	adc {
>> +		ti,adc-channels = <0 1 2 3 4 5 6 7>;
>> +	};
>> +};
>> +
>>  &ecap0 {
>>  		status = "okay";
>>  		pinctrl-names = "default";
>> -- 
>> 1.9.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
