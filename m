Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbaBKSwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 13:52:42 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:38306 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbaBKSwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 13:52:39 -0500
Date: Tue, 11 Feb 2014 20:51:36 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Nishanth Menon <nm@ti.com>
Cc: =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: omap3-n9 family: mark proper OMAP version
Message-ID: <20140211185136.GG573@drone.musicnaut.iki.fi>
References: <1392132541-25340-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392132541-25340-1-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Feb 11, 2014 at 09:29:01AM -0600, Nishanth Menon wrote:
> Nokia N900 uses OMAP3430 and N9/N950 uses OMAP3630. Mark SoC compatibilty
> as per Documentation/devicetree/bindings/arm/omap/omap.txt else
> N9/N950 will be probed as a OMAP3430 type device, since default ti,omap3
> maps to OMAP3430 compatibility.

I already sent & tested patches for this:

http://marc.info/?l=linux-omap&m=139194800711362&w=2
http://marc.info/?l=linux-omap&m=139194800011360&w=2

The N9/N950 is mandatory for 3.14, as the boot hangs without it.

A.

> Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
> 
> just build tested. but given examples such as 
> http://thread.gmane.org/gmane.linux.ports.arm.omap/110006
> 
> I guess, some form of failure is expected.
> 
> based on v3.14-rc2
> 
>  arch/arm/boot/dts/omap3-n9.dts   |    2 +-
>  arch/arm/boot/dts/omap3-n900.dts |    2 +-
>  arch/arm/boot/dts/omap3-n950.dts |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/omap3-n9.dts b/arch/arm/boot/dts/omap3-n9.dts
> index 39828ce..9938b5d 100644
> --- a/arch/arm/boot/dts/omap3-n9.dts
> +++ b/arch/arm/boot/dts/omap3-n9.dts
> @@ -14,5 +14,5 @@
>  
>  / {
>  	model = "Nokia N9";
> -	compatible = "nokia,omap3-n9", "ti,omap3";
> +	compatible = "nokia,omap3-n9", "ti,omap36xx", "ti,omap3";
>  };
> diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
> index 6fc85f9..97db027 100644
> --- a/arch/arm/boot/dts/omap3-n900.dts
> +++ b/arch/arm/boot/dts/omap3-n900.dts
> @@ -13,7 +13,7 @@
>  
>  / {
>  	model = "Nokia N900";
> -	compatible = "nokia,omap3-n900", "ti,omap3";
> +	compatible = "nokia,omap3-n900", "ti,omap3430", "ti,omap3";
>  
>  	cpus {
>  		cpu@0 {
> diff --git a/arch/arm/boot/dts/omap3-n950.dts b/arch/arm/boot/dts/omap3-n950.dts
> index b076a52..261c558 100644
> --- a/arch/arm/boot/dts/omap3-n950.dts
> +++ b/arch/arm/boot/dts/omap3-n950.dts
> @@ -14,5 +14,5 @@
>  
>  / {
>  	model = "Nokia N950";
> -	compatible = "nokia,omap3-n950", "ti,omap3";
> +	compatible = "nokia,omap3-n950", "ti,omap36xx", "ti,omap3";
>  };
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
