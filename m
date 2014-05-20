Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512AbaETGSH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 02:18:07 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:57486 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbaETGSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 02:18:04 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1394614210-15698-7-git-send-email-maxime.coquelin@st.com>
References: <1394614210-15698-1-git-send-email-maxime.coquelin@st.com>
	<1394614210-15698-7-git-send-email-maxime.coquelin@st.com>
Date: Mon, 19 May 2014 23:18:03 -0700
Message-ID: <CAOesGMg5Jk_XB3zdfKz8VxRObYbFO8OMuRyo7Ba-kavANbci1w@mail.gmail.com>
Subject: Re: [PATCH v4 6/6] ARM: dts: STiH407: Add B2120 board support
From: Olof Johansson <olof@lixom.net>
To: Maxime COQUELIN <maxime.coquelin@st.com>
Cc: Rob Landley <rob@landley.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Just a quick drive-by review since I was looking at these patches in
the pull request you sent.



On Wed, Mar 12, 2014 at 1:50 AM, Maxime COQUELIN <maxime.coquelin@st.com> wrote:
> B2120 HDK is the reference board for STiH407 SoC.
> It has the following characteristics:
>  - 1GB DDR3
>  - 8GB eMMC / SD-Card slot
>  - 32MB NOR Flash
>  - 1 x Gbit Ethernet
>  - 1 x USB 3.0 port
>  - 1 x Mini-PCIe
>  - 1 x SATA
>  - 1 x HDMI output
>  - 1 x HDMI input
>  - 1 x SPDIF
>
> This patch only introduces basic functionnalities, such as I2C and UART.
>
> Acked-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
> ---
>  arch/arm/boot/dts/Makefile          |  3 +-
>  arch/arm/boot/dts/stih407-b2120.dts | 78 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 80 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm/boot/dts/stih407-b2120.dts
>
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index 12455cf..f760a88 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -317,7 +317,8 @@ dtb-$(CONFIG_ARCH_SPEAR6XX)+= spear600-evb.dtb
>  dtb-$(CONFIG_ARCH_STI)+= stih415-b2000.dtb \
>         stih416-b2000.dtb \
>         stih415-b2020.dtb \
> -       stih416-b2020.dtb
> +       stih416-b2020.dtb \
> +       stih407-b2120.dtb

These should be in alphanumerical order. 407 comes before 415. You've
been out of order with others as well.

>  dtb-$(CONFIG_ARCH_SUNXI) += \
>         sun4i-a10-a1000.dtb \
>         sun4i-a10-cubieboard.dtb \
> diff --git a/arch/arm/boot/dts/stih407-b2120.dts b/arch/arm/boot/dts/stih407-b2120.dts
> new file mode 100644
> index 0000000..9c97da4
> --- /dev/null
> +++ b/arch/arm/boot/dts/stih407-b2120.dts
> @@ -0,0 +1,78 @@
> +/*
> + * Copyright (C) 2014 STMicroelectronics (R&D) Limited.
> + * Author: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +/dts-v1/;
> +#include "stih407.dtsi"
> +/ {
> +       model = "STiH407 B2120";
> +       compatible = "st,stih407", "st,stih407-b2120";

This should go from specific to generic, so the order needs to be the other way.

Please check other dts files for the same (I didn't).

> +
> +       chosen {
> +               bootargs = "console=ttyAS0,115200";
> +               linux,stdout-path = &sbc_serial0;
> +       };
> +
> +       memory {
> +               device_type = "memory";
> +               reg = <0x40000000 0x80000000>;
> +       };
> +
> +       aliases {
> +               ttyAS0 = &sbc_serial0;
> +       };
> +
> +       soc {
> +               sbc_serial0: serial@9530000 {
> +                       status = "okay";
> +               };

You might want to consider reference-based syntax here instead, so you
don't have to mimic the hierarchy. That'd be (at the root level of the
file, below this secion:

&sbc_serial0: {
        status = "okay";
};

Same for others.


-Olof
