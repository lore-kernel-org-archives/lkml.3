Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbaFXVMM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 17:12:12 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:39720 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaFXVMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 17:12:09 -0400
MIME-Version: 1.0
In-Reply-To: <1403547659-24558-2-git-send-email-balbi@ti.com>
References: <1403547659-24558-1-git-send-email-balbi@ti.com> <1403547659-24558-2-git-send-email-balbi@ti.com>
From: Rob Herring <robherring2@gmail.com>
Date: Tue, 24 Jun 2014 16:11:48 -0500
Message-ID: <CAL_JsqJx_DJqxpEJebi0Etfv5g7=eYje_53vd_44GykreA-rkQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] arm: dts: am4372: let boards access all nodes
 through phandles
To: Felipe Balbi <balbi@ti.com>
Cc: Benoit Cousson <bcousson@baylibre.com>, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rajendra Nayak <rnayak@ti.com>, Nishanth Menon <nm@ti.com>,
        Sricharan R <r.sricharan@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 1:20 PM, Felipe Balbi <balbi@ti.com> wrote:
> by providing phandles to rtc, wdt, cpu and dispc nodes,
> boards can access them to add board-specific data.

Strictly speaking, you are adding labels, not phandles. You can do
phandles without using labels, but the syntax is not so obvious. I'd
tell you what it is but offhand I don't remember. :)

Rob

> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---
>
> Changes since v1:
>         - added phandles to cpu and dispc
>
>  arch/arm/boot/dts/am4372.dtsi | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.dtsi
> index 49fa596..8d3c163 100644
> --- a/arch/arm/boot/dts/am4372.dtsi
> +++ b/arch/arm/boot/dts/am4372.dtsi
> @@ -30,7 +30,7 @@
>         cpus {
>                 #address-cells = <1>;
>                 #size-cells = <0>;
> -               cpu@0 {
> +               cpu: cpu@0 {
>                         compatible = "arm,cortex-a9";
>                         device_type = "cpu";
>                         reg = <0>;
> @@ -270,7 +270,7 @@
>                         ti,hwmods = "counter_32k";
>                 };
>
> -               rtc@44e3e000 {
> +               rtc: rtc@44e3e000 {
>                         compatible = "ti,am4372-rtc","ti,da830-rtc";
>                         reg = <0x44e3e000 0x1000>;
>                         interrupts = <GIC_SPI 75 IRQ_TYPE_LEVEL_HIGH
> @@ -279,7 +279,7 @@
>                         status = "disabled";
>                 };
>
> -               wdt@44e35000 {
> +               wdt: wdt@44e35000 {
>                         compatible = "ti,am4372-wdt","ti,omap3-wdt";
>                         reg = <0x44e35000 0x1000>;
>                         interrupts = <GIC_SPI 91 IRQ_TYPE_LEVEL_HIGH>;
> @@ -871,7 +871,7 @@
>                         #size-cells = <1>;
>                         ranges;
>
> -                       dispc@4832a400 {
> +                       dispc: dispc@4832a400 {
>                                 compatible = "ti,omap3-dispc";
>                                 reg = <0x4832a400 0x400>;
>                                 interrupts = <GIC_SPI 127 IRQ_TYPE_LEVEL_HIGH>;
> --
> 2.0.0.390.gcb682f8
>
