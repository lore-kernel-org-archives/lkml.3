Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab3IWO5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 10:57:11 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:55060 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab3IWO5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 10:57:09 -0400
Message-ID: <524056B8.4020208@linaro.org>
Date: Mon, 23 Sep 2013 10:56:56 -0400
From: Matt Porter <matt.porter@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: Pawel Moll <pawel.moll@arm.com>, Rob Herring <rob.herring@calxeda.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: Re: [PATCH] ARM: dts: add initial VF610 Cosmic/Cosmic+ board support
References: <1379594444-11268-1-git-send-email-matt.porter@linaro.org> <20130922070138.GC31787@S2101-09.ap.freescale.net>
In-Reply-To: <20130922070138.GC31787@S2101-09.ap.freescale.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2013 03:01 AM, Shawn Guo wrote:
> On Thu, Sep 19, 2013 at 08:40:44AM -0400, Matt Porter wrote:
>> Add initial PHYTEC VF610 Cosmic/Cosmic+ board support with
>> UART and FEC enabled.
>>
>> Signed-off-by: Matt Porter <matt.porter@linaro.org>
>> ---
>>   arch/arm/boot/dts/Makefile         |  1 +
>>   arch/arm/boot/dts/vf610-cosmic.dts | 46 ++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 47 insertions(+)
>>   create mode 100644 arch/arm/boot/dts/vf610-cosmic.dts
>>
>> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
>> index cc0f1fb..b0d6156 100644
>> --- a/arch/arm/boot/dts/Makefile
>> +++ b/arch/arm/boot/dts/Makefile
>> @@ -142,6 +142,7 @@ dtb-$(CONFIG_ARCH_MXC) += \
>>   	imx6q-sbc6x.dtb \
>>   	imx6q-wandboard.dtb \
>>   	imx6sl-evk.dtb \
>> +	vf610-cosmic.dtb \
>>   	vf610-twr.dtb
>>   dtb-$(CONFIG_ARCH_MXS) += imx23-evk.dtb \
>>   	imx23-olinuxino.dtb \
>> diff --git a/arch/arm/boot/dts/vf610-cosmic.dts b/arch/arm/boot/dts/vf610-cosmic.dts
>> new file mode 100644
>> index 0000000..c3bd4d4f
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/vf610-cosmic.dts
>> @@ -0,0 +1,46 @@
>> +/*
>> + * Copyright 2013 Freescale Semiconductor, Inc.
>> + * Copyright 2013 Linaro Limited
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + */
>> +
>> +/dts-v1/;
>> +#include "vf610.dtsi"
>> +
>> +/ {
>> +	model = "PHYTEC Cosmic/Cosmic+ Board";
>> +	compatible = "phytec,vf610-cosmic", "fsl,vf610";
>> +
>> +	chosen {
>> +		bootargs = "console=ttyLP1,115200";
>> +	};
>> +
>> +	memory {
>> +		reg = <0x80000000 0x10000000>;
>> +	};
>> +
>> +	clocks {
>> +		enet_ext {
>> +			compatible = "fixed-clock";
>> +			clock-frequency = <50000000>;
>> +		};
>
> This is probably copied from vf610-twr.dts.  But per
> Documentation/devicetree/bindings/clock/fixed-clock.txt, #clock-cells is
> a required property.

Indeed, will update it.

>
>> +	};
>> +
>> +};
>> +
>> +&uart1 {
>> +	pinctrl-names = "default";
>> +	pinctrl-0 = <&pinctrl_uart1_1>;
>> +	status = "okay";
>> +};
>> +
>> +&fec1 {
>
> Please sort the nodes alphabetically in label name.

Will do.

Thanks,
Matt

