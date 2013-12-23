Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576Ab3LWQ5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 11:57:22 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:42676 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757326Ab3LWQ5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 11:57:20 -0500
Date: Mon, 23 Dec 2013 11:57:12 -0500
From: Matt Porter <mporter@linaro.org>
To: Tomasz Figa <t.figa@samsung.com>
Cc: balbi@ti.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Paul Zimmerman <paulz@synopsys.com>,
        Kamil Debski <k.debski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dinh Nguyen <dinh.linux@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: Re: [PATCH v8 3/9] usb: gadget: s3c-hsotg: enable build for other
 platforms
Message-ID: <20131223165712.GB9826@beef>
References: <1387462990-12039-1-git-send-email-mporter@linaro.org>
 <1387462990-12039-4-git-send-email-mporter@linaro.org>
 <20131223162557.GC28679@saruman.home>
 <1831289.ILfyABDFji@amdc1227>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1831289.ILfyABDFji@amdc1227>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 23, 2013 at 05:30:41PM +0100, Tomasz Figa wrote:
> On Monday 23 of December 2013 10:25:57 Felipe Balbi wrote:
> > On Thu, Dec 19, 2013 at 09:23:04AM -0500, Matt Porter wrote:
> > > Remove unused Samsung-specific machine include and Kconfig
> > > dependency on S3C.
> > > 
> > > Signed-off-by: Matt Porter <mporter@linaro.org>
> > > Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
> > > Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
> > > ---
> > >  drivers/usb/gadget/Kconfig     | 7 +++----
> > >  drivers/usb/gadget/s3c-hsotg.c | 2 --
> > >  2 files changed, 3 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
> > > index a91e642..181e760 100644
> > > --- a/drivers/usb/gadget/Kconfig
> > > +++ b/drivers/usb/gadget/Kconfig
> > > @@ -294,11 +294,10 @@ config USB_PXA27X
> > >  	   gadget drivers to also be dynamically linked.
> > >  
> > >  config USB_S3C_HSOTG
> > > -	tristate "S3C HS/OtG USB Device controller"
> > > -	depends on S3C_DEV_USB_HSOTG
> > > +	tristate "Designware/S3C HS/OtG USB Device controller"
> > 
> > causes build failure in x86. Sorry dropping from my queue.
> 
> Maybe depends on ARM would be a good enough stepping stone?

Yes, we could then move from readsl/writesl to ioread_read/io_write_rep
next time around as that fixes the portability issue.

Felipe, since depending on ARM is a trivial fix for this, can you take
an updated version at this point?

-Matt
