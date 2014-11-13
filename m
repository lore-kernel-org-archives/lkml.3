Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588AbaKMBYP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 20:24:15 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:40720 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbaKMBYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 20:24:12 -0500
Date: Thu, 13 Nov 2014 09:23:59 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Stefan Agner <stefan@agner.ch>
Cc: kernel@pengutronix.de, linus.walleij@linaro.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] ARM: dts: vf-colibri: add USB regulators
Message-ID: <20141113012358.GN2704@dragon>
References: <1415106430-6271-1-git-send-email-stefan@agner.ch>
 <1415106430-6271-4-git-send-email-stefan@agner.ch>
 <20141111141228.GB2704@dragon>
 <0bb62bdfc866f75977d01070d228ed4c@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0bb62bdfc866f75977d01070d228ed4c@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 04:51:16PM +0100, Stefan Agner wrote:
> >> diff --git a/arch/arm/boot/dts/vf-colibri.dtsi b/arch/arm/boot/dts/vf-colibri.dtsi
> >> index 2371760..79ccfe2 100644
> >> --- a/arch/arm/boot/dts/vf-colibri.dtsi
> >> +++ b/arch/arm/boot/dts/vf-colibri.dtsi
> >> @@ -163,5 +163,17 @@
> >>  				VF610_PAD_PTD3__UART2_CTS		0x21a1
> >>  			>;
> >>  		};
> >> +
> >> +		pinctrl_usbh1_ext: gpio_usb_vbus {
> >> +			fsl,pins = <
> >> +				VF610_PAD_PTD4__GPIO_83			0x22ed
> > 
> > We used to know the GPIO usage by looking for the phandle reference to
> > the node.  But it doesn't work for VF610 case now.
> > 
> > I guess this is for usbh_vbus_reg usage?  It would be nice to have a
> > comment telling the usage of the GPIO.
> 
> Yeah its true, its assign is not required for Vybird. However, we could
> assign them anyway, it would even enforce correct pin setup from
> Startup... This would then make a comment superfluous. What do you
> think?

I agree with the approach of assigning the phandle anyway.

> 
> 
> > 
> >> +			>;
> >> +		};
> >> +
> >> +		pinctrl_usbdev0_ext: gpio_usb_cdet {
> >> +			fsl,pins = <
> >> +				VF610_PAD_PTC29__GPIO_102		0x22ed
> > 
> > How is this one used?
> 
> This is not yet used. It is more or less the OTG-ID pin, but on 3.3V
> level. We use that on the Colibri standard to switch between Host/Device
> mode, however a driver which uses that GPIO is still outstanding. I can
> also leave that away for now, if you prefer....

Then let's add it when it's actually required.

Shawn
