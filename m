Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab3I2QIW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 12:08:22 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:51801 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab3I2QIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 12:08:20 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] USB: OHCI: Check the overrides pointer for NULL in ohci_init_driver()
Date: Sun, 29 Sep 2013 18:08:15 +0200
Message-ID: <7503059.PJP4nLpymb@flatron>
User-Agent: KMail/4.11.1 (Linux/3.11.1-gentoo; KDE/4.11.1; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1309282259220.11462-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1309282259220.11462-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 of September 2013 23:00:27 Alan Stern wrote:
> On Sat, 28 Sep 2013, Tomasz Figa wrote:
> > A series of commit starting at
> > 
> > 50a97e059b USB: OHCI: make ohci-exynos a separate driver
> > 
> > and ending at
> > 
> > b8ad5c3706 USB: OHCI: make ohci-pxa27x a separate driver
> > 
> > introduced the concept of separate OHCI drivers for particular
> > controllers. Respective drivers need to call ohci_init_driver() to
> > initialize hc_driver struct with generic data and to certain extent
> > with platform specific overrides through ohci_driver_overrides struct
> > passed as second argument to this function. However the code does not
> > check if the ohci_driver_overrides struct pointer is non-NULL, which
> > leads for a NULL pointer dereference for drivers that do not need any
> > overrides.
> > 
> > This patch fixes the problem by dereferencing the passed pointer to
> > ohci_driver_overrides struct only if it is non-NULL.
> > 
> > Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
> > ---
> > 
> >  drivers/usb/host/ohci-hcd.c | 10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
> > index 21d937a..8ada13f 100644
> > --- a/drivers/usb/host/ohci-hcd.c
> > +++ b/drivers/usb/host/ohci-hcd.c
> > @@ -1161,10 +1161,12 @@ void ohci_init_driver(struct hc_driver *drv,
> > 
> >  	/* Copy the generic table to drv and then apply the overrides */
> >  	*drv = ohci_hc_driver;
> > 
> > -	drv->product_desc = over->product_desc;
> > -	drv->hcd_priv_size += over->extra_priv_size;
> > -	if (over->reset)
> > -		drv->reset = over->reset;
> > +	if (over) {
> > +		drv->product_desc = over->product_desc;
> > +		drv->hcd_priv_size += over->extra_priv_size;
> > +		if (over->reset)
> > +			drv->reset = over->reset;
> > +	}
> > 
> >  }
> >  EXPORT_SYMBOL_GPL(ohci_init_driver);
> 
> You were scooped by Kevin Hilman:
> 
> 	http://marc.info/?l=linux-usb&m=138029463906143&w=2

Happens. :)

Nice to have this fixed anyway.

Best regards,
Tomasz

