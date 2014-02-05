Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbaBEK3P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 05:29:15 -0500
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:56322 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751368AbaBEK3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 05:29:13 -0500
Message-ID: <52F2122A.9080603@st.com>
Date: Wed, 5 Feb 2014 11:27:54 +0100
From: Patrice Chotard <patrice.chotard@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: srinivas kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <kernel@stlinux.com>,
        <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>
Cc: <maxime.coquelin@st.com>, <alexandre.torgue@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: Re: [PATCH 3/4] ARM: dts: Add support of STid127 Soc.
References: <1391093744-19905-1-git-send-email-patrice.chotard@st.com> <1391093744-19905-4-git-send-email-patrice.chotard@st.com> <52EB9C03.70009@st.com>
In-Reply-To: <52EB9C03.70009@st.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Srinivas

Thanks for reviewing, a V2 serie will be pushed with all required fixes.

Patrice

On 01/31/2014 01:50 PM, srinivas kandagatla wrote:
> Hi Patrice,
>
> On 30/01/14 14:55, Patrice CHOTARD wrote:
>> From: Alexandre TORGUE <alexandre.torgue@st.com>
>>
>> The STid127 integrates all harware components to function as a cable modem
> s/harware/hardware/
>
> s/STid127/STiD127
>
> Please fix other instances too.
>
>> or, in combination with a back end device, as a Gateway set top boxe.
> s/boxe/box/
>> Supported devices:
>> 	-UART0
>> 	-UART2
>>
>> Signed-off-by: alexandre torgue <alexandre.torgue@st.com>
>> ---
>>   arch/arm/boot/dts/stid127-clock.dtsi   |   31 ++++
>>   arch/arm/boot/dts/stid127-pinctrl.dtsi |  245 ++++++++++++++++++++++++++++++++
>>   arch/arm/boot/dts/stid127.dtsi         |  130 +++++++++++++++++
>>   3 files changed, 406 insertions(+)
>>   create mode 100644 arch/arm/boot/dts/stid127-clock.dtsi
>>   create mode 100644 arch/arm/boot/dts/stid127-pinctrl.dtsi
>>   create mode 100644 arch/arm/boot/dts/stid127.dtsi
>>
>> diff --git a/arch/arm/boot/dts/stid127-clock.dtsi b/arch/arm/boot/dts/stid127-clock.dtsi
>> new file mode 100644
>> index 0000000..c6cafa9
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/stid127-clock.dtsi
>> @@ -0,0 +1,31 @@
>> +/*
>> + * Copyright (C) 2013 STMicroelectronics (R&D) Limited
> 2014
>
>> + * Author(s): Giuseppe Cavallaro <peppe.cavallaro@st.com>
>> + *	      Alexandre Torgue <alexandre.torgue@st.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +/ {Acked-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>> +	clocks {
>> +		/*
>> +		 * ARM Peripheral clock for timers
>> +		 */
>> +		arm_periph_clk: arm_periph_clk {
>> +			#clock-cells = <0>;
>> +			compatible = "fixed-clock";
>> +			clock-frequency = <100000000>;
>> +		};
>> +		/*
>> +		 * Bootloader initialized system infrastructure clock for
>> +		 * serial devices.
>> +		 */
>> +		CLK_IC_LP_HD: clockgenA0@29 {
>> +			#clock-cells = <0>;
>> +			compatible = "fixed-clock";
>> +			clock-frequency = <100000000>;
>> +			clock-output-names = "CLK_IC_LP_HD";
>> +		};
>> +	};
>> +};
>> diff --git a/arch/arm/boot/dts/stid127-pinctrl.dtsi b/arch/arm/boot/dts/stid127-pinctrl.dtsi
>> new file mode 100644
>> index 0000000..3fa66f3
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/stid127-pinctrl.dtsi
>> @@ -0,0 +1,245 @@
>> +/*
>> + * Copyright (C) 2012 STMicroelectronics Limited.
> 2014
>
>> + * Author(s): Giuseppe Cavallaro <peppe.cavallaro@st.com>
>> + *	      Alexandre Torgue <alexandre.torgue@st.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * publishhed by the Free Software Foundation.
> s/publishhed/published/
>
>> + */
>> +#include "st-pincfg.h"
>> +/ {
>> +	aliases {
>> +		gpio0	= &PIO0;
>> +		gpio1	= &PIO1;
>> +		gpio2	= &PIO2;
>> +		gpio3	= &PIO3;
>> +		gpio4	= &PIO4;
>> +		gpio5	= &PIO5;
>> +		gpio6	= &PIO6;
>> +		gpio7	= &PIO7;
>> +		gpio8	= &PIO8;
>> +		gpio9	= &PIO9;
>> +		gpio10	= &PIO10;
>> +		gpio11	= &PIO11;
>> +		gpio12	= &PIO12;
>> +		gpio13	= &PIO13;
>> +		gpio14	= &PIO14;
>> +		gpio15	= &PIO15;
>> +		gpio16	= &PIO16;
>> +		gpio17	= &PIO17;
>> +		gpio18	= &PIO18;
>> +		gpio19	= &PIO19;
>> +		gpio20	= &PIO20;
>> +		gpio21	= &PIO21;
>> +		gpio22	= &PIO22;
>> +
>> +	};
>> +
>> +	soc {
>> +		pin-controller-pwest {
>> +			#address-cells	= <1>;
>> +			#size-cells	= <1>;
>> +			compatible	= "st,stid127-pwest-pinctrl";
>> +			st,syscfg	= <&syscfg_pwest>;
>> +			ranges		= <0 0xfebe0000 0x8000>;
> Can you add interrupt controller support to the pin controller.
>
> Patches are in : https://lkml.org/lkml/2014/1/16/342
> All these patches are due to be in v3.15.
>
>> +
>> +			PIO0: gpio@febe0000 {
>> +				gpio-controller;
>> +				#gpio-cells = <1>;
>> +				reg = <0 0x100>;
>> +				interrupts =  <0 149 0>;
>> +				st,bank-name  = "PIO0";
>> +			};
>> +						rx	= <&PIO3 0 ALT2	IN>;
>> +					};
>> +				};
>> +			};
>> +
>> +		};
> unnecessary empty line  here.
>
>> diff --git a/arch/arm/boot/dts/stid127.dtsi b/arch/arm/boot/dts/stid127.dtsi
>> new file mode 100644
>> index 0000000..a6f0b8fe
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/stid127.dtsi
>> @@ -0,0 +1,130 @@
>> +/*
>> + * Copyright (C) 2013 STMicroelectronics Limited.
> 2014
>> + * Author(s): Giuseppe Cavallaro <peppe.cavallaro@st.com>
>> + *	      Alexandre Torgue <alexandre.torgue@st.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * publishhed by the Free Software Foundation.
> s/publishhed/published/
>
>> + */
>> +#include "stid127-pinctrl.dtsi"
>> +#include "stid127-clock.dtsi"
>> +/ {
>> +	#address-cells = <1>;
>> +	#size-cells = <1>;
>> +
>> +	cpus {
>> +		#address-cells = <1>;
>> +		#size-cells = <0>;
>> +
>> +		cpu@0 {
>> +			device_type = "cpu";
>> +			compatible = "arm,cortex-a9";
>> +			reg = <0>;
>> +		};
>> +		cpu@1 {
>> +			device_type = "cpu";
>> +			compatible = "arm,cortex-a9";
>> +			reg = <1>;
>> +		};
>> +	};
>> +
>> +	intc: interrupt-controller@fffe1000 {
>> +		compatible = "arm,cortex-a9-gic";
>> +		#interrupt-cells = <3>;
>> +		interrupt-controller;
>> +		reg = <0xfffe1000 0x1000>,
>> +		      <0xfffe0100 0x100>;
>> +	};
>> +
>> +	scu@fffe0000 {
>> +		compatible = "arm,cortex-a9-scu";
>> +		reg = <0xfffe0000 0x1000>;
>> +	};
>> +
>> +	timer@fffe0200 {
>> +			interrupt-parent = <&intc>;
>> +			compatible = "arm,cortex-a9-global-timer";
>> +			reg = <0xfffe0200 0x100>;
>> +			interrupts = <1 11 0x04>;
>> +			clocks = <&arm_periph_clk>;
> Fix the tab spacing here.
>
> Thanks,
> srini

