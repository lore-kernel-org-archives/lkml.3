Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbaE1CUM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 22:20:12 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:55964 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbaE1CUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 22:20:08 -0400
MIME-Version: 1.0
In-Reply-To: <20140528004116.7816.69646@quantum>
References: <1401074613-29227-1-git-send-email-t.dakhran@samsung.com>
	<1401074613-29227-3-git-send-email-t.dakhran@samsung.com>
	<20140528004116.7816.69646@quantum>
Date: Wed, 28 May 2014 06:20:06 +0400
Message-ID: <CANhyOUdow9niHXMg0fGdXf_6PVKzAGas6h_JtNZFG+2rEGQk4g@mail.gmail.com>
Subject: Re: [PATCH v11 2/3] clk: exynos5410: register clocks using common
 clock framework
From: Tarek Dakhran <t.dakhran@gmail.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Tarek Dakhran <t.dakhran@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Romain Naour <romain.naour@openwide.fr>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Wed, May 28, 2014 at 4:41 AM, Mike Turquette <mturquette@linaro.org> wrote:
> Quoting Tarek Dakhran (2014-05-25 20:23:32)
>> The EXYNOS5410 clocks are statically listed and registered
>> using the Samsung specific common clock helper functions.
>>
>> Signed-off-by: Tarek Dakhran <t.dakhran@samsung.com>
>> Signed-off-by: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
>> ---
>>  .../devicetree/bindings/clock/exynos5410-clock.txt |   45 +++++
>>  drivers/clk/samsung/Makefile                       |    1 +
>>  drivers/clk/samsung/clk-exynos5410.c               |  209 ++++++++++++++++++++
>>  include/dt-bindings/clock/exynos5410.h             |   33 ++++
>>  4 files changed, 288 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/clock/exynos5410-clock.txt
>>  create mode 100644 drivers/clk/samsung/clk-exynos5410.c
>>  create mode 100644 include/dt-bindings/clock/exynos5410.h
>>
>> diff --git a/Documentation/devicetree/bindings/clock/exynos5410-clock.txt b/Documentation/devicetree/bindings/clock/exynos5410-clock.txt
>> new file mode 100644
>> index 0000000..aeab635
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/clock/exynos5410-clock.txt
>> @@ -0,0 +1,45 @@
>> +* Samsung Exynos5410 Clock Controller
>> +
>> +The Exynos5410 clock controller generates and supplies clock to various
>> +controllers within the Exynos5410 SoC.
>> +
>> +Required Properties:
>> +
>> +- compatible: should be "samsung,exynos5410-clock"
>> +
>> +- reg: physical base address of the controller and length of memory mapped
>> +  region.
>> +
>> +- #clock-cells: should be 1.
>> +
>> +All available clocks are defined as preprocessor macros in
>> +dt-bindings/clock/exynos5410.h header and can be used in device
>> +tree sources.
>> +
>> +External clock:
>> +
>> +There is clock that is generated outside the SoC. It
>> +is expected that it is defined using standard clock bindings
>> +with following clock-output-name:
>> +
>> + - "fin_pll" - PLL input clock from XXTI
>
> Does fin_pll feed into the exynos5410-clock controller? If so, should
> the example clock-controller node below have a clocks and clock-names
> property?

fin_pll does not feed into exynos5410-clock controller, but into mct do.

> diff --git a/arch/arm/boot/dts/exynos5410.dtsi b/arch/arm/boot/dts/exynos5410.dtsi
> new file mode 100644
> index 0000000..3839c26
> --- /dev/null
> +++ b/arch/arm/boot/dts/exynos5410.dtsi
> @@ -0,0 +1,206 @@
> +/*
> + * SAMSUNG EXYNOS5410 SoC device tree source
> + *
> + * Copyright (c) 2013 Samsung Electronics Co., Ltd.
> + *             http://www.samsung.com
> + *
> + * SAMSUNG EXYNOS5410 SoC device nodes are listed in this file.
> + * EXYNOS5410 based board files can include this file and provide
> + * values for board specfic bindings.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include "skeleton.dtsi"
> +#include <dt-bindings/clock/exynos5410.h>
> +
> +/ {
> +       compatible = "samsung,exynos5410", "samsung,exynos5";
> +       interrupt-parent = <&gic>;
[snip]
> +               mct: mct@101C0000 {
> +                       compatible = "samsung,exynos4210-mct";
> +                       reg = <0x101C0000 0xB00>;
> +                       interrupt-parent = <&interrupt_map>;
> +                       interrupts = <0>, <1>, <2>, <3>,
> +                               <4>, <5>, <6>, <7>,
> +                               <8>, <9>, <10>, <11>;
> +                       clocks = <&fin_pll>, <&clock CLK_MCT>;
> +                       clock-names = "fin_pll", "mct";
> +
> +                       interrupt_map: interrupt-map {
> +                               #interrupt-cells = <1>;
> +                               #address-cells = <0>;
> +                               #size-cells = <0>;
> +                               interrupt-map = <0 &combiner 23 3>,
> +                                               <1 &combiner 23 4>,
> +                                               <2 &combiner 25 2>,
> +                                               <3 &combiner 25 3>,
> +                                               <4 &gic 0 120 0>,
> +                                               <5 &gic 0 121 0>,
> +                                               <6 &gic 0 122 0>,
> +                                               <7 &gic 0 123 0>,
> +                                               <8 &gic 0 128 0>,
> +                                               <9 &gic 0 129 0>,
> +                                               <10 &gic 0 130 0>,
> +                                               <11 &gic 0 131 0>;
> +                       };
> +               };
> +

That's why I documented fin_pll. Should I add mct binding example to
documentation too?

Best regards,
     Tarek
