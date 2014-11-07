Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbaKGFtp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 00:49:45 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:34590 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665AbaKGFtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 00:49:33 -0500
Message-ID: <545C5D20.5010006@ti.com>
Date: Fri, 7 Nov 2014 11:18:16 +0530
From: Vignesh R <vigneshr@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Hartmut Knaack <knaack.h@gmx.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Lars-Peter Clausen <lars@metafoo.de>, Peter Meerwald <pmeerw@pmeerw.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jan Kardell <jan.kardell@telliq.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Brad Griffis <bgriffis@ti.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-iio@vger.kernel.org>,
        <linux-input@vger.kernel.org>
Subject: Re: [PATCH 3/4] arm: boot: dts: am335x-evm: Make charge delay a DT
 parameter for tsc
References: <1414408111-2631-1-git-send-email-vigneshr@ti.com> <1414408111-2631-4-git-send-email-vigneshr@ti.com> <5453FA8E.3080204@gmx.de>
In-Reply-To: <5453FA8E.3080204@gmx.de>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Saturday 01 November 2014 02:39 AM, Hartmut Knaack wrote:
> Vignesh R schrieb am 27.10.2014 12:08:
>> The charge delay value is by default 0xB000. But it can be set to lower
>> values on some boards as long as false pen-ups are avoided. Lowering the
>> value increases the sampling rate (though current sampling rate is
>> sufficient for tsc operation). Hence charge delay has been made a DT
>> parameter.
>>
> I would recommend to use a few colons to separate some thoughts. Also, limit to 80 chars per line would be beneficial. See inline.

I will address this in v2

>> Signed-off-by: Vignesh R <vigneshr@ti.com>
>> ---
>>  .../devicetree/bindings/input/touchscreen/ti-tsc-adc.txt    | 13 +++++++++++++
>>  arch/arm/boot/dts/am335x-evm.dts                            |  1 +
>>  2 files changed, 14 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/input/touchscreen/ti-tsc-adc.txt b/Documentation/devicetree/bindings/input/touchscreen/ti-tsc-adc.txt
>> index 878549ba814d..ac62769e70e4 100644
>> --- a/Documentation/devicetree/bindings/input/touchscreen/ti-tsc-adc.txt
>> +++ b/Documentation/devicetree/bindings/input/touchscreen/ti-tsc-adc.txt
>> @@ -28,6 +28,18 @@ Required properties:
>>  	ti,adc-channels: List of analog inputs available for ADC.
>>  			 AIN0 = 0, AIN1 = 1 and so on till AIN7 = 7.
>>  
>> +Optional properties:
>> +- child "tsc"
>> +	ti,charge-delay: Length of touch screen charge delay step in terms of
>> +			 ADC clock cycles. Charge delay value should be large in order
>> +			 to avoid false pen-up events. This value affects the overall
>> +			 sampling speed hence need to be kept as low as possible while
> <...> speed, hence needs to be <...>
>> +			 avoiding false pen-up event. Start from a lower value say 0x400
> <...> pen-up events. Start from a lower value, like 0x400, and increase <...>
>> +			 and increase value until false pen-up events are avoided. The
>> +			 pen-up detection happens immediately after the charge step
> <...> charge step, so this <...>
>> +			 so this does in fact function as a hardware knob for adjusting
>> +			 the amount of "settling time".
>> +
>>  Example:
>>  	tscadc: tscadc@44e0d000 {
>>  		compatible = "ti,am3359-tscadc";
>> @@ -36,6 +48,7 @@ Example:
>>  			ti,x-plate-resistance = <200>;
>>  			ti,coordiante-readouts = <5>;
>>  			ti,wire-config = <0x00 0x11 0x22 0x33>;
>> +			ti,charge-delay = <0xB000>;
>>  		};
>>  
>>  		adc {
>> diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
>> index e2156a583de7..80be0462298b 100644
>> --- a/arch/arm/boot/dts/am335x-evm.dts
>> +++ b/arch/arm/boot/dts/am335x-evm.dts
>> @@ -641,6 +641,7 @@
>>  		ti,x-plate-resistance = <200>;
>>  		ti,coordinate-readouts = <5>;
>>  		ti,wire-config = <0x00 0x11 0x22 0x33>;
>> +		ti,charge-delay = <0xB000>;
>>  	};
>>  
>>  	adc {
>>
> 
