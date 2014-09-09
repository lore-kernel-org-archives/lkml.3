Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbaIIA6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 20:58:19 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:17584 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097AbaIIA6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 20:58:17 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+8ayucRyg4VXJIYDir7Vu6
Date: Mon, 8 Sep 2014 17:58:09 -0700
From: Tony Lindgren <tony@atomide.com>
To: Nishanth Menon <nm@ti.com>
Cc: Tero Kristo <t-kristo@ti.com>, Paul Walmsley <paul@pwsan.com>,
        =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Keerthy <j-keerthy@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 1/6] ARM: dts: OMAP3+: Add PRM interrupt
Message-ID: <20140909005808.GG10785@atomide.com>
References: <1408716235-26164-1-git-send-email-nm@ti.com>
 <1408716235-26164-2-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408716235-26164-2-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nishanth Menon <nm@ti.com> [140822 07:08]:
> Provide OMAP3, 4 and OMAP5 with interrupt number for PRM
> 
> And for DRA7, provide crossbar number for prm interrupt.
> 
> Signed-off-by: Nishanth Menon <nm@ti.com>

I've picked this patch only into omap-for-v3.18/soc as
this is needed for Felipe's intc related changes to work
properly with the wake-up interrupts for DT based booting
for off-idle.

So please don't include this patch into your pull request
for the other dts changes you have.

Regards,

Tony

> ---
>  arch/arm/boot/dts/dra7.dtsi  |    1 +
>  arch/arm/boot/dts/omap3.dtsi |    1 +
>  arch/arm/boot/dts/omap4.dtsi |    1 +
>  arch/arm/boot/dts/omap5.dtsi |    1 +
>  4 files changed, 4 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
> index 97f603c..7a3e011 100644
> --- a/arch/arm/boot/dts/dra7.dtsi
> +++ b/arch/arm/boot/dts/dra7.dtsi
> @@ -89,6 +89,7 @@
>  		prm: prm@4ae06000 {
>  			compatible = "ti,dra7-prm";
>  			reg = <0x4ae06000 0x3000>;
> +			interrupts = <GIC_SPI 6 IRQ_TYPE_LEVEL_HIGH>;
>  
>  			prm_clocks: clocks {
>  				#address-cells = <1>;
> diff --git a/arch/arm/boot/dts/omap3.dtsi b/arch/arm/boot/dts/omap3.dtsi
> index 575a49b..3136ed1 100644
> --- a/arch/arm/boot/dts/omap3.dtsi
> +++ b/arch/arm/boot/dts/omap3.dtsi
> @@ -97,6 +97,7 @@
>  		prm: prm@48306000 {
>  			compatible = "ti,omap3-prm";
>  			reg = <0x48306000 0x4000>;
> +			interrupts = <11>;
>  
>  			prm_clocks: clocks {
>  				#address-cells = <1>;
> diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
> index 69408b5..7375d44 100644
> --- a/arch/arm/boot/dts/omap4.dtsi
> +++ b/arch/arm/boot/dts/omap4.dtsi
> @@ -129,6 +129,7 @@
>  		prm: prm@4a306000 {
>  			compatible = "ti,omap4-prm";
>  			reg = <0x4a306000 0x3000>;
> +			interrupts = <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>;
>  
>  			prm_clocks: clocks {
>  				#address-cells = <1>;
> diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
> index fc8df17..df0a09b 100644
> --- a/arch/arm/boot/dts/omap5.dtsi
> +++ b/arch/arm/boot/dts/omap5.dtsi
> @@ -131,6 +131,7 @@
>  		prm: prm@4ae06000 {
>  			compatible = "ti,omap5-prm";
>  			reg = <0x4ae06000 0x3000>;
> +			interrupts = <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>;
>  
>  			prm_clocks: clocks {
>  				#address-cells = <1>;
> -- 
> 1.7.9.5
> 
