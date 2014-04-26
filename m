Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbaDZLiH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 07:38:07 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:40427 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbaDZLiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 07:38:05 -0400
Message-ID: <535B9A98.3060206@gmail.com>
Date: Sat, 26 Apr 2014 13:38:00 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, kgene.kim@samsung.com,
        t.figa@samsung.com
CC: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, ben-linux@fluff.org,
        arnd@arndb.de, olof@lixom.net, marc.zyngier@arm.com,
        thomas.abraham@linaro.org, kyungmin.park@samsung.com,
        inki.dae@samsung.com, sw0312.kim@samsung.com, hyunhee.kim@samsung.com,
        yj44.cho@samsung.com, chanho61.park@samsung.com,
        sajjan.linux@gmail.com, tushar.behera@linaro.org,
        sachin.kamat@linaro.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCHv4 7/7] ARM: dts: Add device tree sources for Exynos3250
References: <1398388572-30239-1-git-send-email-cw00.choi@samsung.com> <1398388572-30239-8-git-send-email-cw00.choi@samsung.com> <535B0324.50705@gmail.com>
In-Reply-To: <535B0324.50705@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.04.2014 02:51, Tomasz Figa wrote:
> Hi Chanwoo,
>
> On 25.04.2014 03:16, Chanwoo Choi wrote:
>> From: Tomasz Figa <t.figa@samsung.com>
>>
>> This patch add new exynos3250.dtsi to support Exynos3250 SoC based on
>> Cortex-A7
>> dual core and includes following dt nodes:
>>
>> - GIC interrupt controller
>> - Pinctrl to control GPIOs
>> - Clock controller
>> - CPU information (Cortex-A7 dual core)
>> - UART to support serial port
>> - MCT (Multi Core Timer)
>> - ADC (Analog Digital Converter)
>> - I2C/SPI bus
>> - Power domain
>> - PMU (Performance Monitoring Unit)
>> - MSHC (Mobile Storage Host Controller)
>> - PWM (Pluse Width Modulation)
>> - AMBA bus
>>
>> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Signed-off-by: Inki Dae <inki.dae@samsung.com>
>> Signed-off-by: Hyunhee Kim <hyunhee.kim@samsung.com>
>> Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
>> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
>> Cc: Ben Dooks <ben-linux@fluff.org>
>> Cc: Kukjin Kim <kgene.kim@samsung.com>
>> Cc: Rob Herring <robh+dt@kernel.org>
>> Cc: Pawel Moll <pawel.moll@arm.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
>> Cc: Kumar Gala <galak@codeaurora.org>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Cc: devicetree@vger.kernel.org
>> ---
>>   arch/arm/boot/dts/exynos3250-pinctrl.dtsi | 477 +++++++++++++++
>>   arch/arm/boot/dts/exynos3250.dtsi         | 405 +++++++++++++
>>   arch/arm/boot/dts/exynos4212-tizenw.dts   | 926
>> ++++++++++++++++++++++++++++++
>>   3 files changed, 1808 insertions(+)
>>   create mode 100644 arch/arm/boot/dts/exynos3250-pinctrl.dtsi
>>   create mode 100644 arch/arm/boot/dts/exynos3250.dtsi
>>   create mode 100644 arch/arm/boot/dts/exynos4212-tizenw.dts
>>
>> diff --git a/arch/arm/boot/dts/exynos3250-pinctrl.dtsi
>> b/arch/arm/boot/dts/exynos3250-pinctrl.dtsi
>> new file mode 100644
>> index 0000000..976490b
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/exynos3250-pinctrl.dtsi
>> @@ -0,0 +1,477 @@
>> +/*
>> + * Samsung's Exynos3250 SoCs pin-mux and pin-config device tree source
>> + *
>> + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
>> + *        http://www.samsung.com
>> + *
>> + * Samsung's Exynos3250 SoCs pin-mux and pin-config optiosn are
>> listed as device
>> + * tree nodes are listed in this file.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> +*/
>> +
>> +/ {
>> +    pinctrl@11400000 {
>
> Could you use references instead of re-specifying the whole tree
> hierarchy in every file a node is used?
>
> Instead of
>
> / {
>      pinctrl@11400000 {
>
>      };
> };
>
> one may simply use
>
> &pinctrl_0 {
>
> };
>
> You might just need to change the location of #include
> "exynos3250-pinctrl.dtsi" from top of exynos3250.dtsi to bottom of it.

Oh, well, you also should move all nodes of on-SoC devices under a 
simple-bus node called soc. You can see the patch adding dts file for 
Exynos5260 for an example [1].

[1] http://thread.gmane.org/gmane.linux.kernel.samsung-soc/29360/focus=29361

Best regards,
Tomasz
