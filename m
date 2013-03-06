Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab3CFAoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 19:44:05 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:53665 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668Ab3CFAoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 19:44:02 -0500
Date: Wed, 6 Mar 2013 08:44:25 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 4/9] usb: gadget: fix omap_udc build errors
Message-ID: <20130306004425.GA28448@kroah.com>
References: <1362521809-22989-1-git-send-email-arnd@arndb.de>
 <1362521809-22989-5-git-send-email-arnd@arndb.de>
 <20130305222224.GA26278@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130305222224.GA26278@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 12:22:24AM +0200, Felipe Balbi wrote:
> Hi,
> 
> On Tue, Mar 05, 2013 at 11:16:44PM +0100, Arnd Bergmann wrote:
> > 1bf0cf6040 "usb: gadget: omap_udc: convert to udc_start/udc_stop"
> > made some trivial changes but was missing a ';' character.
> > 
> > 8c4cc00552 "ARM: OMAP1: DMA: Moving OMAP1 DMA channel definitions
> > to mach-omap1" added a definition for OMAP_DMA_USB_W2FC_TX0 to
> > the driver while making the header file it was defined in
> > unavailable for drivers, but this driver actually needs
> > OMAP_DMA_USB_W2FC_RX0 as well.
> > 
> > Both changes appear trivial, so let's add the missing semicolon
> > and the macro definition.
> > 
> > Cc: Felipe Balbi <balbi@ti.com>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> >  drivers/usb/gadget/omap_udc.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/usb/gadget/omap_udc.c b/drivers/usb/gadget/omap_udc.c
> > index 06be85c..f844565 100644
> > --- a/drivers/usb/gadget/omap_udc.c
> > +++ b/drivers/usb/gadget/omap_udc.c
> > @@ -62,6 +62,7 @@
> >  #define	DRIVER_VERSION	"4 October 2004"
> >  
> >  #define OMAP_DMA_USB_W2FC_TX0		29
> > +#define OMAP_DMA_USB_W2FC_RX0		26
> >  
> >  /*
> >   * The OMAP UDC needs _very_ early endpoint setup:  before enabling the
> > @@ -1310,7 +1311,7 @@ static int omap_pullup(struct usb_gadget *gadget, int is_on)
> >  }
> >  
> >  static int omap_udc_start(struct usb_gadget *g,
> > -		struct usb_gadget_driver *driver)
> > +		struct usb_gadget_driver *driver);
> 
> good catch, thanks. I'll queue it for v3.6-rc3. Make sure to Cc
> linux-usb for anything under drivers/usb/ though

I think you mean 3.9 :)

I can take this patch right now, if you ack it.

thanks,

greg k-h
