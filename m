Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab3LCLKR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 06:10:17 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:39738 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab3LCLKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 06:10:13 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Roger Quadros <rogerq@ti.com>
Cc: tony@atomide.com, bcousson@baylibre.com, balbi@ti.com, nm@ti.com,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: omap3-beagle: Fix USB host on beagle boards (for 3.13)
Date: Tue, 03 Dec 2013 12:10:17 +0100
Message-ID: <5279201.QqSaKtdayD@avalon>
User-Agent: KMail/4.10.5 (Linux/3.10.17-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <529DA639.8000905@ti.com>
References: <1385387745-7162-1-git-send-email-rogerq@ti.com> <3636447.xncPcCYRzc@avalon> <529DA639.8000905@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

On Tuesday 03 December 2013 11:36:57 Roger Quadros wrote:
> On 12/03/2013 05:54 AM, Laurent Pinchart wrote:
> > Hi Roger,
> > 
> > On Monday 25 November 2013 15:55:45 Roger Quadros wrote:
> >> Beagle (rev. C4) and Beagle-XM (all revs) need VAUX2 1.8V supply
> >> for the USB PHY.
> >> 
> >> As the generic PHY driver can't handle more than one supply
> >> at the moment, we configure this supply to be always on.
> >> This will cause a very small power impact if the USB host subsystem
> >> is not in use, about 76.86 micro-W + LDO power.
> >> 
> >> Older Beagle boards (prior to C4) don't have VAUX2 connected anywhere,
> >> so there won't be any functional impact on those boards other than
> >> some additional LDO power consumption.
> > 
> > Do I need any patch other than this one (on top of v3.13-rc1) to enable
> > the ethernet port on a Beagleboard-xM rev B ? Here's what the kernel
> > reports at boot (with ignore_loglevel set on the command line).
> 
> It seems on Rev A/B, the power enable line for the USB hub has reversed
> polarity than Rev C.
> 
> Does the below patch work for you?

It does, thank you.

> If yes, how do we account for it? Do we add a new file
> "omap3-beagle-xm-ab.dts" for rev A/B boards?

Unless we want to add board code back with a runtime check, which I doubt 
would be regarded as a good idea, I don't see any other easy solution.

> diff --git a/arch/arm/boot/dts/omap3-beagle-xm.dts
> b/arch/arm/boot/dts/omap3-beagle-xm.dts index b39918e..434d903 100644
> --- a/arch/arm/boot/dts/omap3-beagle-xm.dts
> +++ b/arch/arm/boot/dts/omap3-beagle-xm.dts
> @@ -78,6 +78,7 @@
>  		regulator-max-microvolt = <3300000>;
>  		gpio = <&twl_gpio 18 0>;	/* GPIO LEDA */
>  		startup-delay-us = <70000>;
> +		enable-active-high;
>  	};
> 
>  	/* HS USB Host PHY on PORT 2 */

-- 
Regards,

Laurent Pinchart

