Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474AbaJXPEF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:04:05 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:54439 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955AbaJXPED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:04:03 -0400
MIME-Version: 1.0
In-Reply-To: <1413983529-21887-3-git-send-email-eddie.huang@mediatek.com>
References: <1413983529-21887-1-git-send-email-eddie.huang@mediatek.com>
	<1413983529-21887-3-git-send-email-eddie.huang@mediatek.com>
Date: Fri, 24 Oct 2014 17:04:00 +0200
Message-ID: <CABuKBe+EY4nJSFKgaBe4dtd1iFj_iyPBMxZgosmuTQ2V2NzTAQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] ARM: mediatek: add UART dts for mt8127 and mt8135
From: Matthias Brugger <matthias.bgg@gmail.com>
To: Eddie Huang <eddie.huang@mediatek.com>
Cc: Rob Herring <robh+dt@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Jiri Slaby <jslaby@suse.cz>,
        Alan Cox <alan@linux.intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org, Yuhau Chen <yh.chen@mediatek.com>,
        Hsien-Chun Yen <hc.yen@mediatek.com>,
        Nathan Chung <nathan.chung@mediatek.com>,
        srv_heupstream <srv_heupstream@mediatek.com>,
        Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-10-22 15:12 GMT+02:00 Eddie Huang <eddie.huang@mediatek.com>:
> This add dts support for mt8127 and mt8135 SOC UART
>
> Signed-off-by: Eddie Huang <eddie.huang@mediatek.com>
> ---
>  arch/arm/boot/dts/mt8127.dtsi | 34 ++++++++++++++++++++++++++++++++++
>  arch/arm/boot/dts/mt8135.dtsi | 36 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 70 insertions(+)
>
> diff --git a/arch/arm/boot/dts/mt8127.dtsi b/arch/arm/boot/dts/mt8127.dtsi
> index 25c9f69..249c218 100644
> --- a/arch/arm/boot/dts/mt8127.dtsi
> +++ b/arch/arm/boot/dts/mt8127.dtsi
> @@ -64,6 +64,12 @@
>                         clock-frequency = <32000>;
>                         #clock-cells = <0>;
>                 };
> +
> +               uart_clk: dummy26m {
> +                       compatible = "fixed-clock";
> +                       clock-frequency = <26000000>;
> +                       #clock-cells = <0>;
> +                };
>         };
>
>         soc {
> @@ -89,5 +95,33 @@
>                               <0 0x10214000 0 0x2000>,
>                               <0 0x10216000 0 0x2000>;
>                 };
> +
> +               uart0: serial@11006000 {
> +                       compatible = "mediatek,mt8127-uart","mediatek,mt6577-uart";
> +                       reg = <0 0x11002000 0 0x400>;
> +                       interrupts = <GIC_SPI 51 IRQ_TYPE_LEVEL_LOW>;

As long as the interrupt polarity patches from Joe are not
merged,IRQ_TYPE_LEVEL_LOW triggers won't work as the GIC does not
support them.

> +                       clocks = <&uart_clk>;
> +               };
> +
> +               uart1: serial@11007000 {
> +                       compatible = "mediatek,mt8127-uart","mediatek,mt6577-uart";
> +                       reg = <0 0x11003000 0 0x400>;
> +                       interrupts = <GIC_SPI 52 IRQ_TYPE_LEVEL_LOW>;
> +                       clocks = <&uart_clk>;
> +               };
> +
> +               uart2: serial@11008000 {
> +                       compatible = "mediatek,mt8127-uart","mediatek,mt6577-uart";
> +                       reg = <0 0x11004000 0 0x400>;
> +                       interrupts = <GIC_SPI 53 IRQ_TYPE_LEVEL_LOW>;
> +                       clocks = <&uart_clk>;
> +               };
> +
> +               uart3: serial@11009000 {
> +                       compatible = "mediatek,mt8127-uart","mediatek,mt6577-uart";
> +                       reg = <0 0x11005000 0 0x400>;
> +                       interrupts = <GIC_SPI 54 IRQ_TYPE_LEVEL_LOW>;
> +                       clocks = <&uart_clk>;
> +               };
>         };
>  };
> diff --git a/arch/arm/boot/dts/mt8135.dtsi b/arch/arm/boot/dts/mt8135.dtsi
> index 90a56ad..683b761 100644
> --- a/arch/arm/boot/dts/mt8135.dtsi
> +++ b/arch/arm/boot/dts/mt8135.dtsi
> @@ -86,6 +86,13 @@
>                         clock-frequency = <32000>;
>                         #clock-cells = <0>;
>                 };
> +
> +               uart_clk: dummy26m {
> +                       compatible = "fixed-clock";
> +                       clock-frequency = <26000000>;
> +                       #clock-cells = <0>;
> +               };
> +
>         };
>
>         soc {
> @@ -111,5 +118,34 @@
>                               <0 0x10214000 0 0x2000>,
>                               <0 0x10216000 0 0x2000>;
>                 };
> +
> +               uart0: serial@11006000 {
> +                       compatible = "mediatek,mt8135-uart","mediatek,mt6577-uart";
> +                       reg = <0 0x11006000 0 0x400>;
> +                       interrupts = <GIC_SPI 51 IRQ_TYPE_LEVEL_LOW>;
> +                       clocks = <&uart_clk>;
> +               };
> +
> +               uart1: serial@11007000 {
> +                       compatible = "mediatek,mt8135-uart","mediatek,mt6577-uart";
> +                       reg = <0 0x11007000 0 0x400>;
> +                       interrupts = <GIC_SPI 52 IRQ_TYPE_LEVEL_LOW>;
> +                       clocks = <&uart_clk>;
> +               };
> +
> +               uart2: serial@11008000 {
> +                       compatible = "mediatek,mt8135-uart","mediatek,mt6577-uart";
> +                       reg = <0 0x11008000 0 0x400>;
> +                       interrupts = <GIC_SPI 53 IRQ_TYPE_LEVEL_LOW>;
> +                       clocks = <&uart_clk>;
> +               };
> +
> +               uart3: serial@11009000 {
> +                       compatible = "mediatek,mt8135-uart","mediatek,mt6577-uart";
> +                       reg = <0 0x11009000 0 0x400>;
> +                       interrupts = <GIC_SPI 54 IRQ_TYPE_LEVEL_LOW>;
> +                       clocks = <&uart_clk>;
> +               };
> +
>         };
>  };
> --
> 1.8.1.1.dirty
>



-- 
motzblog.wordpress.com
