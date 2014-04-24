Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888AbaDXNYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 09:24:17 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:36828 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbaDXNYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 09:24:15 -0400
MIME-Version: 1.0
In-Reply-To: <2386bd1367aa44741979461358a72dec89608597.1398335771.git.anders.berg@lsi.com>
References: <cover.1398335771.git.anders.berg@lsi.com>
	<2386bd1367aa44741979461358a72dec89608597.1398335771.git.anders.berg@lsi.com>
Date: Thu, 24 Apr 2014 15:24:14 +0200
Message-ID: <CACRpkdbU6UashxCuPMDjEB_nbB=mXicGpjJy=HGC6r3qfxCtVQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/6] ARM: dts: Device tree for AXM55xx.
From: Linus Walleij <linus.walleij@linaro.org>
To: Anders Berg <anders.berg@lsi.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Mike Turquette <mturquette@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 12:44 PM, Anders Berg <anders.berg@lsi.com> wrote:

> Add device tree for the Amarillo validation board with an AXM5516 SoC.
>
> Signed-off-by: Anders Berg <anders.berg@lsi.com>
(...)

> +                       timer0: timer@2010091000 {
> +                               compatible = "arm,sp804", "arm,primecell";
> +                               reg = <0x20 0x10091000 0 0x1000>;
> +                               interrupts = <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>,
> +                                            <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>,
> +                                            <GIC_SPI 47 IRQ_TYPE_LEVEL_HIGH>,
> +                                            <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>,
> +                                            <GIC_SPI 49 IRQ_TYPE_LEVEL_HIGH>,
> +                                            <GIC_SPI 50 IRQ_TYPE_LEVEL_HIGH>,
> +                                            <GIC_SPI 51 IRQ_TYPE_LEVEL_HIGH>,
> +                                            <GIC_SPI 52 IRQ_TYPE_LEVEL_HIGH>,
> +                                            <GIC_SPI 53 IRQ_TYPE_LEVEL_HIGH>;
> +                               clocks = <&clk_per>;
> +                               clock-names = "apb_pclk";
> +                               status = "okay";
> +                       };
> +
> +                       gpio0: gpio@2010092000 {
> +                               #gpio-cells = <2>;
> +                               compatible = "arm,pl061", "arm,primecell";
> +                               gpio-controller;
> +                               reg = <0x20 0x10092000 0x00 0x1000>;
> +                               interrupts = <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>,
> +                                            <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>,
> +                                            <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>,
> +                                            <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>,
> +                                            <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>,
> +                                            <GIC_SPI 15 IRQ_TYPE_LEVEL_HIGH>,
> +                                            <GIC_SPI 16 IRQ_TYPE_LEVEL_HIGH>,
> +                                            <GIC_SPI 17 IRQ_TYPE_LEVEL_HIGH>;
> +                               clocks = <&clk_per>;
> +                               clock-names = "apb_pclk";
> +                               status = "disabled";
> +                       };

One interrupt per CPU core?

The drivers for these blocks will really just grab the first IRQ and
then I guess they
will only be able to execute on CPU0.

It's definately correct to list all the IRQs here, but how do you envision
the drivers making use of them in the long run?

Yours,
Linus Walleij
