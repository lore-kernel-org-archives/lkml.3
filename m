Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbaEEIiY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 04:38:24 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:48060 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883AbaEEIiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 04:38:22 -0400
Date: Mon, 5 May 2014 10:37:57 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>, Mugunthan V N <mugunthanvnm@ti.com>,
        Tony Lindgren <tony@atomide.com>, bcousson@baylibre.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Leigh Brown <leigh@solinno.co.uk>, devicetree@vger.kernel.org
Subject: Re: [PATCH 3.14 012/158] ARM: dts: am33xx: correcting dt node unit
 address for usb
Message-ID: <20140505083757.GB30739@localhost>
References: <20140504154029.975081050@linuxfoundation.org>
 <20140504154031.690140742@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140504154031.690140742@linuxfoundation.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 04, 2014 at 11:38:41AM -0400, Greg Kroah-Hartman wrote:
> 3.14-stable review patch.  If anyone has any objections, please let me know.

This one should not be backported without commit

	a2f8d6b30321 ("ARM: dts: am335x: update USB DT references")

which is in Linus' tree but is not marked for stable (or USB will be
disabled for the boards relying on the old node addresses).

Thanks,
Johan

> ------------------
> 
> From: Mugunthan V N <mugunthanvnm@ti.com>
> 
> commit 8abcdd680d543fb582371e146e62ba9f2af8a816 upstream.
> 
> DT node's unit address should be its own register offset address to make it a
> unique across the system. This patch corrects the incorrect USB entries with
> correct register offset for unit address.
> 
> Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Acked-by: Felipe Balbi <balbi@ti.com>
> Signed-off-by: Mugunthan V N <mugunthanvnm@ti.com>
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  arch/arm/boot/dts/am33xx.dtsi |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/arch/arm/boot/dts/am33xx.dtsi
> +++ b/arch/arm/boot/dts/am33xx.dtsi
> @@ -448,7 +448,7 @@
>  			ti,hwmods = "usb_otg_hs";
>  			status = "disabled";
>  
> -			usb_ctrl_mod: control@44e10000 {
> +			usb_ctrl_mod: control@44e10620 {
>  				compatible = "ti,am335x-usb-ctrl-module";
>  				reg = <0x44e10620 0x10
>  					0x44e10648 0x4>;
> @@ -551,7 +551,7 @@
>  					"tx14", "tx15";
>  			};
>  
> -			cppi41dma: dma-controller@07402000 {
> +			cppi41dma: dma-controller@47402000 {
>  				compatible = "ti,am3359-cppi41";
>  				reg =  <0x47400000 0x1000
>  					0x47402000 0x1000
