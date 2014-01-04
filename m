Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbaADLLm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 06:11:42 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1661 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751390AbaADLLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 06:11:39 -0500
From: Richard Weinberger <richard@nod.at>
To: Apelete Seketeli <apelete@seketeli.net>
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH v3 1/2] usb: musb: add support for JZ4740 usb device controller
Date: Sat, 04 Jan 2014 12:11:32 +0100
Message-ID: <1519380.Ih8x4XZWqx@sandpuppy>
User-Agent: KMail/4.11.2 (Linux/3.12.0-34.ge8fa6b4-desktop; KDE/4.11.2; x86_64; ; )
In-Reply-To: <20140104110622.GA7525@tao>
References: <1387485747-25759-1-git-send-email-apelete@seketeli.net> <CAFLxGvzL-NE+3Y4tWAmCiXq1DsdEDB2zMpm52X_uVTy9u7sCCg@mail.gmail.com> <20140104110622.GA7525@tao>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 4. Januar 2014, 12:06:22 schrieb Apelete Seketeli:
> On 04-Jan-14, Richard Weinberger wrote:
> > On Thu, Dec 19, 2013 at 9:42 PM, Apelete Seketeli <apelete@seketeli.net> 
wrote:
> > > Add support for Ingenic JZ4740 USB Device Controller through a
> > > specific musb glue layer.
> > > 
> > > JZ4740 UDC not being OTG compatible and missing some hardware
> > > registers, this musb glue layer is written from scratch to be used in
> > > gadget mode only and take silicon design specifics into account.
> > > 
> > > Signed-off-by: Apelete Seketeli <apelete@seketeli.net>
> > > Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> > > ---
> > > 
> > >  drivers/usb/musb/Kconfig  |    8 +-
> > >  drivers/usb/musb/Makefile |    1 +
> > >  drivers/usb/musb/jz4740.c |  201
> > >  +++++++++++++++++++++++++++++++++++++++++++++ 3 files changed, 209
> > >  insertions(+), 1 deletion(-)
> > >  create mode 100644 drivers/usb/musb/jz4740.c
> > > 
> > > diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
> > > index 57dfc0c..14d7e72 100644
> > > --- a/drivers/usb/musb/Kconfig
> > > +++ b/drivers/usb/musb/Kconfig
> > > @@ -93,6 +93,12 @@ config USB_MUSB_BLACKFIN
> > > 
> > >  config USB_MUSB_UX500
> > >  
> > >         tristate "Ux500 platforms"
> > > 
> > > +config USB_MUSB_JZ4740
> > > +       tristate "JZ4740"
> > > +       depends on MACH_JZ4740 || COMPILE_TEST
> > > +       depends on USB_MUSB_GADGET
> > > +       depends on USB_OTG_BLACKLIST_HUB
> > > +
> > > 
> > >  endchoice
> > >  
> > >  config USB_MUSB_AM335X_CHILD
> > > 
> > > @@ -100,7 +106,7 @@ config USB_MUSB_AM335X_CHILD
> > > 
> > >  choice
> > >  
> > >         prompt 'MUSB DMA mode'
> > > 
> > > -       default MUSB_PIO_ONLY if ARCH_MULTIPLATFORM
> > > +       default MUSB_PIO_ONLY if ARCH_MULTIPLATFORM || USB_MUSB_JZ4740
> > 
> > Just out of curiosity, why can't we use DMA?
> 
> We wrote the musb glue layer for the Ben Nanonote handheld computer
> only to provide ethernet-over-usb functionality.
> 
> I was thinking about adding DMA support later, but Lars-Peter Clausen
> did experiment with DMA, and found out that all ethernet packets were
> unaligned, while the DMA only works if they are aligned.
> As a consequence, the DMA was bypassed all the time, making it useless
> at least for the ethernet gadget we are interested in.
> 
> That's why DMA didn't make it into the glue layer.

DMA support would be nice to have.
Especially to make the USB storage gadget work well with the Ben NanoNote.

Thanks,
//richard
