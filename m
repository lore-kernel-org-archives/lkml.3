Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663Ab3HUH6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 03:58:34 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:17253 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751090Ab3HUH6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 03:58:32 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/ZIhDySOdB5svz0SGPQ3b/
Date: Wed, 21 Aug 2013 00:58:28 -0700
From: Tony Lindgren <tony@atomide.com>
To: Zubair Lutfullah <zubair.lutfullah@gmail.com>
Cc: sameo@linux.intel.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] typo fixes (coordiante -> coordinate) in am335x
Message-ID: <20130821075828.GZ7656@atomide.com>
References: <1373901928-19605-1-git-send-email-zubair.lutfullah@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373901928-19605-1-git-send-email-zubair.lutfullah@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Zubair Lutfullah <zubair.lutfullah@gmail.com> [130715 08:33]:
> Did a grep for coordiante and replaced them all
> with coordinate.
> 
> This applies to the mfd-next tree.

This should be safe to apply via the MFD tree as a non-critical
fix assuming the bootloaders are not yet using this:

Acked-by: Tony Lindgren <tony@atomide.com>

> Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
> ---
>  .../bindings/input/touchscreen/ti-tsc-adc.txt      |    4 ++--
>  arch/arm/boot/dts/am335x-evm.dts                   |    2 +-
>  drivers/input/touchscreen/ti_am335x_tsc.c          |    2 +-
>  drivers/mfd/ti_am335x_tscadc.c                     |    2 +-
>  4 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/input/touchscreen/ti-tsc-adc.txt b/Documentation/devicetree/bindings/input/touchscreen/ti-tsc-adc.txt
> index 491c97b..3e22aec 100644
> --- a/Documentation/devicetree/bindings/input/touchscreen/ti-tsc-adc.txt
> +++ b/Documentation/devicetree/bindings/input/touchscreen/ti-tsc-adc.txt
> @@ -6,7 +6,7 @@ Required properties:
>  	ti,wires: Wires refer to application modes i.e. 4/5/8 wire touchscreen
>  		  support on the platform.
>  	ti,x-plate-resistance: X plate resistance
> -	ti,coordiante-readouts: The sequencer supports a total of 16
> +	ti,coordinate-readouts: The sequencer supports a total of 16
>  				programmable steps each step is used to
>  				read a single coordinate. A single
>                                  readout is enough but multiple reads can
> @@ -34,7 +34,7 @@ Example:
>  		tsc {
>  			ti,wires = <4>;
>  			ti,x-plate-resistance = <200>;
> -			ti,coordiante-readouts = <5>;
> +			ti,coordinate-readouts = <5>;
>  			ti,wire-config = <0x00 0x11 0x22 0x33>;
>  		};
>  
> diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
> index 0fa4c7f..e50b781 100644
> --- a/arch/arm/boot/dts/am335x-evm.dts
> +++ b/arch/arm/boot/dts/am335x-evm.dts
> @@ -250,7 +250,7 @@
>  	tsc {
>  		ti,wires = <4>;
>  		ti,x-plate-resistance = <200>;
> -		ti,coordiante-readouts = <5>;
> +		ti,coordinate-readouts = <5>;
>  		ti,wire-config = <0x00 0x11 0x22 0x33>;
>  	};
>  
> diff --git a/drivers/input/touchscreen/ti_am335x_tsc.c b/drivers/input/touchscreen/ti_am335x_tsc.c
> index 0e9f02a..6422f65 100644
> --- a/drivers/input/touchscreen/ti_am335x_tsc.c
> +++ b/drivers/input/touchscreen/ti_am335x_tsc.c
> @@ -348,7 +348,7 @@ static int titsc_parse_dt(struct platform_device *pdev,
>  	if (err < 0)
>  		return err;
>  
> -	err = of_property_read_u32(node, "ti,coordiante-readouts",
> +	err = of_property_read_u32(node, "ti,coordinate-readouts",
>  			&ts_dev->coordinate_readouts);
>  	if (err < 0)
>  		return err;
> diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
> index b003a16..dd31e23 100644
> --- a/drivers/mfd/ti_am335x_tscadc.c
> +++ b/drivers/mfd/ti_am335x_tscadc.c
> @@ -106,7 +106,7 @@ static	int ti_tscadc_probe(struct platform_device *pdev)
>  
>  	node = of_get_child_by_name(pdev->dev.of_node, "tsc");
>  	of_property_read_u32(node, "ti,wires", &tsc_wires);
> -	of_property_read_u32(node, "ti,coordiante-readouts", &readouts);
> +	of_property_read_u32(node, "ti,coordinate-readouts", &readouts);
>  
>  	node = of_get_child_by_name(pdev->dev.of_node, "adc");
>  	of_property_for_each_u32(node, "ti,adc-channels", prop, cur, val) {
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
