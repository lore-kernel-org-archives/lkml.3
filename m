Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbaADLPc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 06:15:32 -0500
Received: from seketeli.net ([94.23.218.202]:54774 "EHLO ms.seketeli.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbaADLPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 06:15:30 -0500
X-Greylist: delayed 558 seconds by postgrey-1.27 at vger.kernel.org; Sat, 04 Jan 2014 06:15:29 EST
Date: Sat, 4 Jan 2014 12:06:22 +0100
From: Apelete Seketeli <apelete@seketeli.net>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH v3 1/2] usb: musb: add support for JZ4740 usb device
 controller
Message-ID: <20140104110622.GA7525@tao>
References: <1387485747-25759-1-git-send-email-apelete@seketeli.net>
 <1387485747-25759-2-git-send-email-apelete@seketeli.net>
 <CAFLxGvzL-NE+3Y4tWAmCiXq1DsdEDB2zMpm52X_uVTy9u7sCCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLxGvzL-NE+3Y4tWAmCiXq1DsdEDB2zMpm52X_uVTy9u7sCCg@mail.gmail.com>
X-Operating-System: Debian GNU/Linux 7
X-URL: http://apelete.seketeli.net
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04-Jan-14, Richard Weinberger wrote:
> On Thu, Dec 19, 2013 at 9:42 PM, Apelete Seketeli <apelete@seketeli.net> wrote:
> > Add support for Ingenic JZ4740 USB Device Controller through a
> > specific musb glue layer.
> >
> > JZ4740 UDC not being OTG compatible and missing some hardware
> > registers, this musb glue layer is written from scratch to be used in
> > gadget mode only and take silicon design specifics into account.
> >
> > Signed-off-by: Apelete Seketeli <apelete@seketeli.net>
> > Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> > ---
> >  drivers/usb/musb/Kconfig  |    8 +-
> >  drivers/usb/musb/Makefile |    1 +
> >  drivers/usb/musb/jz4740.c |  201 +++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 209 insertions(+), 1 deletion(-)
> >  create mode 100644 drivers/usb/musb/jz4740.c
> >
> > diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
> > index 57dfc0c..14d7e72 100644
> > --- a/drivers/usb/musb/Kconfig
> > +++ b/drivers/usb/musb/Kconfig
> > @@ -93,6 +93,12 @@ config USB_MUSB_BLACKFIN
> >  config USB_MUSB_UX500
> >         tristate "Ux500 platforms"
> >
> > +config USB_MUSB_JZ4740
> > +       tristate "JZ4740"
> > +       depends on MACH_JZ4740 || COMPILE_TEST
> > +       depends on USB_MUSB_GADGET
> > +       depends on USB_OTG_BLACKLIST_HUB
> > +
> >  endchoice
> >
> >  config USB_MUSB_AM335X_CHILD
> > @@ -100,7 +106,7 @@ config USB_MUSB_AM335X_CHILD
> >
> >  choice
> >         prompt 'MUSB DMA mode'
> > -       default MUSB_PIO_ONLY if ARCH_MULTIPLATFORM
> > +       default MUSB_PIO_ONLY if ARCH_MULTIPLATFORM || USB_MUSB_JZ4740
> 
> Just out of curiosity, why can't we use DMA?

We wrote the musb glue layer for the Ben Nanonote handheld computer
only to provide ethernet-over-usb functionality.

I was thinking about adding DMA support later, but Lars-Peter Clausen
did experiment with DMA, and found out that all ethernet packets were
unaligned, while the DMA only works if they are aligned.
As a consequence, the DMA was bypassed all the time, making it useless
at least for the ethernet gadget we are interested in.

That's why DMA didn't make it into the glue layer.

Cheers.
-- 
        Apelete
