Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948Ab3BFBxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 20:53:10 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:49161 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986Ab3BFBxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 20:53:08 -0500
Date: Tue, 5 Feb 2013 17:55:11 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: balbi@ti.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arm@kernel.org,
        Shawn Guo <shawn.guo@linaro.org>, linux-usb@vger.kernel.org,
        Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH 12/15] USB: gadget/freescale: disable non-multiplatform
 drivers
Message-ID: <20130206015511.GC1073@kroah.com>
References: <1358788568-11137-1-git-send-email-arnd@arndb.de>
 <20130205170027.GB1081@kroah.com>
 <20130205213710.GA3739@arwen.pp.htv.fi>
 <201302052254.00426.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201302052254.00426.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 10:54:00PM +0000, Arnd Bergmann wrote:
> On Tuesday 05 February 2013, Felipe Balbi wrote:
> > [linus/master] Merge branch 'fix-max-write' of git://git.kernel.org/pub/scm/linux/kernel/git/teigland/linux-dlm
> > 
> > It's building find for me:
> > 
> > $ crossmake drivers/usb/gadget/fsl_udc_core.o \
> >         drivers/usb/gadget/fsl_mxc_udc.o > /dev/null
> > 
> > (crossmake is an alias to make ARCH=arm)
> > 
> > Arnd, are you maybe missing a merge of v3.8-rc6 ?
> >
> > I can see that imx_udc.c is broken still, but there are no maintainers
> > for that driver. I'm adding Sascha to Cc list, maybe he knows someone
> > who can help, but if this driver isn't fixed in 2 merge windows, I will
> > schedule for removal from tree and someone else will have to
> > re-introduce it later without all the bogus includes.
> 
> Ah, I see what happened now: I submitted a patch that lumped together
> two patches, disabling both fsl_mxc_udc and imx_udc. You already had
> a fix for the first one, so I dropped my patch, but now I see the
> build error for the second one that my patch was avoiding.
> 
> The last patch to imx_udc that seems to have seen more than just
> build testing was probably "USB: gadget: imx_udc: don't queue more
> data when zlp is to be sent", while fsl_mxc_udc looks actively
> maintained. It's not completely clear to me whether these
> are actually two drivers for the same hardware, of whether
> imx_udc is the i.mx1 variant and fsl_mxc_udc is the i.mx2 variant.
> 
> What I can say is that no platform in the kernel currently defines
> an "imx_udc" platform_device, so it is certainly unused, and has
> been since at least e08300043e in 2010.
> 
> I would suggest that we mark the imx_udc driver as 'depends on
> BROKEN' right away, since no in-tree user needs it, and any
> out of tree user is already broken in 3.8. I also wouldn't
> mind removing the driver unless the imx maintainers have
> a plan for it.

Sure, someone just send me a patch for that and I'll be glad to mark it
BROKEN.

thanks,

greg k-h
