Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbaKGMJH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 07:09:07 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:60766 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbaKGMJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 07:09:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Peter Griffin <peter.griffin@linaro.org>, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, devicetree@vger.kernel.org,
        lee.jones@linaro.org
Subject: Re: [PATCH 03/13] ARM: STi: DT: STiH416: Add DT nodes for the ehci and ohci usb controllers.
Date: Fri, 07 Nov 2014 13:08:57 +0100
Message-ID: <2945908.5UNg8NaKcc@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1415361475-6218-4-git-send-email-peter.griffin@linaro.org>
References: <1415361475-6218-1-git-send-email-peter.griffin@linaro.org> <1415361475-6218-4-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:o0403HRZwBkkSgO6MgbVS+P0s9Nt9/wngJjBRcG99jn
 nj1ZzjnYVeKzgdjFaspBRp+b5j/FmwxBXFrgzGlr30+N0cy18U
 8S8IlREUumtw1glAnesX0Y//p1g7wwliacL33O0Wq4Yr5gKCSR
 330IiFSvSsz9uss6tZep1t9+Bgys6NCKS7X7wxPoOAShbivEP1
 3lKJhy6XCDhv6LX40MD4PrJcV1iUNnoPZlWNIVJ5KMa+9Ks9Zl
 gbc6lm/7S+oLfadxUvLHfv87KiHU2CGbIquqehY9YVoeifn2Tl
 5UB14iqnlQAuiYmwz2DlWpqDRm7kdta9/aqouAPDDA+F/MLctc
 +kKr2CWSspT0kpV9FVmc=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 November 2014 11:57:45 Peter Griffin wrote:
> diff --git a/arch/arm/boot/dts/stih416.dtsi b/arch/arm/boot/dts/stih416.dtsi
> index 0f3019a..6238d9e 100644
> --- a/arch/arm/boot/dts/stih416.dtsi
> +++ b/arch/arm/boot/dts/stih416.dtsi
> @@ -325,5 +325,149 @@
>                         clock-names = "osc_phy";
>  
>                 };
> +
> +               ehci0: usb@0xfe1ffe00 {

Please drop the '0x' from the unit address in all instances.

> +                       compatible = "st,st-ehci-300x";
> +                       reg = <0xfe1ffe00 0x100>;
> +                       interrupts = <GIC_SPI 148 IRQ_TYPE_NONE>;
> +                       pinctrl-names = "default";
> +                       pinctrl-0 = <&pinctrl_usb0>;
> +                       clocks = <&clk_s_a1_ls 0>,
> +                                <&clockgen_b0 0>;
> +                       clock-names = "ic", "clk48";
> +
> +                       phys = <&usb2_phy>;
> +                       phy-names = "usb";
> +                       status = "okay";

No need to list 'status="okay"', it's the default. It might
make sense to change this to 'status="disabled"' though, if the ports
might be unused on some boards.

>                 mmc0: sdhci@fe81e000 {
>                         bus-width = <8>;
>                 };
> +
> +               usb0: usb@fe100000 {
> +                       status = "okay";
> +               };
> +
> +               usb1: usb@fe200000 {
> +                       status = "okay";
> +               };
> +
> +               usb2: usb@fe300000 {
> +                       status = "okay";
> +               };

I don't understand this part: why do you add extra nodes here that only
contain a status property?

Note that if you add the devices to the per-soc file instead of the
per-board file, you can just access the nodes by label.

	Arnd
