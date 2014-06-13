Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbaFMHVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 03:21:39 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:49955 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751071AbaFMHVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 03:21:37 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18A4pUH52kFk2/XItV8Qmhi
Date: Fri, 13 Jun 2014 00:21:30 -0700
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: dwmw2@infradead.org, computersforpeace@gmail.com,
        kyungmin.park@samsung.com, pekon@ti.com,
        ezequiel.garcia@free-electrons.com, javier@dowhile0.org,
        nsekhar@ti.com, linux-omap@vger.kernel.org,
        linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/36] ARM: dts: OMAP2+: Fix NAND device nodes
Message-ID: <20140613072129.GL17845@atomide.com>
References: <1402477001-31132-1-git-send-email-rogerq@ti.com>
 <1402477001-31132-11-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402477001-31132-11-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [140611 01:58]:
> Add compatible id, GPMC register resource and interrupt
> resource to NAND controller nodes.
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  arch/arm/boot/dts/am335x-evm.dts         |  8 ++++++--
>  arch/arm/boot/dts/am335x-igep0033.dtsi   |  8 ++++++--
>  arch/arm/boot/dts/am43x-epos-evm.dts     |  8 ++++++--
>  arch/arm/boot/dts/omap3-devkit8000.dts   |  9 +++++++--
>  arch/arm/boot/dts/omap3-evm-37xx.dts     | 10 +++++++---
>  arch/arm/boot/dts/omap3-igep0020.dts     | 10 +++++++---
>  arch/arm/boot/dts/omap3-igep0030.dts     |  8 ++++++--
>  arch/arm/boot/dts/omap3-ldp.dts          | 10 +++++++---
>  arch/arm/boot/dts/omap3-lilly-a83x.dtsi  | 10 +++++++---
>  arch/arm/boot/dts/omap3-lilly-dbb056.dts |  7 ++++---
>  arch/arm/boot/dts/omap3430-sdp.dts       |  8 ++++++--
>  11 files changed, 69 insertions(+), 27 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
> index 6028217..fa25f2b 100644
> --- a/arch/arm/boot/dts/am335x-evm.dts
> +++ b/arch/arm/boot/dts/am335x-evm.dts
> @@ -437,9 +437,13 @@
>  	status = "okay";
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&nandflash_pins_s0>;
> -	ranges = <0 0 0x08000000 0x10000000>;	/* CS0: NAND */
> +	ranges = <0 0 0x08000000 0x10000000	/* CS0 space, 16MB */
> +		  255 0 0x50000000 0x36c>;	/* GPMC reg */

And here too let's not let the NAND driver tinker with the GPMC
registers.

Tony
