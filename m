Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbaETNJs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 09:09:48 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:33962 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751295AbaETNJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 09:09:45 -0400
Message-ID: <537B53D9.9080206@st.com>
Date: Tue, 20 May 2014 15:08:41 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
Cc: Olof Johansson <olof@lixom.net>, Rob Landley <rob@landley.net>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <kernel@stlinux.com>
Subject: Re: [PATCH v6 3/4] ARM: dts: Add STiH407 SoC support
References: <1400579192-17620-1-git-send-email-maxime.coquelin@st.com> <1400579192-17620-4-git-send-email-maxime.coquelin@st.com> <20140520121717.GL24991@lee--X1>
In-Reply-To: <20140520121717.GL24991@lee--X1>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-20_02:2014-05-20,2014-05-20,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/20/2014 02:17 PM, Lee Jones wrote:
>> The STiH407 is advanced multi-HD AVC processor with 3D graphics acceleration
>> and 1.5-GHz ARM Cortex-A9 SMP CPU.
>>
>> Acked-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
>> Acked-by: Lee Jones <lee.jones@linaro.org>
>> Acked-by: Patrice Chotard <patrice.chotard@st.com>
>> Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
>> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
>> ---
>>   arch/arm/boot/dts/stih407-clock.dtsi   |  40 +++
>>   arch/arm/boot/dts/stih407-pinctrl.dtsi | 615 +++++++++++++++++++++++++++++++++
>>   arch/arm/boot/dts/stih407.dtsi         | 263 ++++++++++++++
>>   3 files changed, 918 insertions(+)
>>   create mode 100644 arch/arm/boot/dts/stih407-clock.dtsi
>>   create mode 100644 arch/arm/boot/dts/stih407-pinctrl.dtsi
>>   create mode 100644 arch/arm/boot/dts/stih407.dtsi
>>
>> diff --git a/arch/arm/boot/dts/stih407-clock.dtsi b/arch/arm/boot/dts/stih407-clock.dtsi
>> new file mode 100644
>> index 0000000..ae8068c
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/stih407-clock.dtsi
>> @@ -0,0 +1,40 @@
>> +/*
>> + * Copyright (C) 2014 STMicroelectronics R&D Limited
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +/ {
>> +	clocks {
>> +		/*
>> +		 * Fixed 30MHz oscillator inputs to SoC
>> +		 */
>> +		CLK_SYSIN: CLK_SYSIN {
>
> I thought we weren't using upper case clk names anymore?
>
>> +			#clock-cells = <0>;
>> +			compatible = "fixed-clock";
>> +			clock-frequency = <30000000>;
>> +			clock-output-names = "CLK_SYSIN";
>> +		};
>> +
>> +		/*
>> +		 * ARM Peripheral clock for timers
>> +		 */
>> +		arm_periph_clk: arm_periph_clk {
>> +			#clock-cells = <0>;
>> +			compatible = "fixed-clock";
>> +			clock-frequency = <600000000>;
>> +		};
>> +
>> +		/*
>> +		 * Bootloader initialized system infrastructure clock for
>> +		 * serial devices.
>> +		 */
>> +		CLK_EXT2F_A9: clockgenC0@13 {
>
> Or camel?

Good catch, v7 is in the pipe.

Thanks,
Maxime

>
> [...]
>
