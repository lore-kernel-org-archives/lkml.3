Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbbAUIz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 03:55:57 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:56045 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbbAUIzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 03:55:48 -0500
MIME-Version: 1.0
In-Reply-To: <20150119145147.GG20386@saruman>
References: <1421654209-6486-1-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
	<1421654209-6486-5-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
	<20150119145147.GG20386@saruman>
Date: Wed, 21 Jan 2015 16:55:47 +0800
Message-ID: <CAJ1gpc33-BH1e=VpJ0ocjNRJk6CGswCuQ8UYrO=Pkanqhv+xLg@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] xhci: Platform: Set Synopsis device disconnection
 quirk based on platform data
From: Sneeker Yeh <sneeker.yeh@gmail.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>, Huang Rui <ray.huang@amd.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, Andy Green <andy.green@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

2015-01-19 22:51 GMT+08:00 Felipe Balbi <balbi@ti.com>:
>
> On Mon, Jan 19, 2015 at 03:56:48PM +0800, Sneeker Yeh wrote:
> > If an xhci platform has Synopsis device disconnection errata then enable
> > XHCI_DISCONNECT_QUIRK quirk flag.
> >
> > Signed-off-by: Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
> > ---
> >  drivers/usb/host/xhci-plat.c     |    3 +++
> >  include/linux/usb/xhci_pdriver.h |    4 ++++
> >  2 files changed, 7 insertions(+)
> >
> > diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
> > index 08d402b..40beb95 100644
> > --- a/drivers/usb/host/xhci-plat.c
> > +++ b/drivers/usb/host/xhci-plat.c
> > @@ -147,6 +147,9 @@ static int xhci_plat_probe(struct platform_device *pdev)
> >       if ((node && of_property_read_bool(node, "usb3-lpm-capable")) ||
> >                       (pdata && pdata->usb3_lpm_capable))
> >               xhci->quirks |= XHCI_LPM_SUPPORT;
> > +
> > +     if (pdata && pdata->delay_portcsc_clear)
> > +             xhci->quirks |= XHCI_DISCONNECT_QUIRK;
> >       /*
> >        * Set the xHCI pointer before xhci_plat_setup() (aka hcd_driver.reset)
> >        * is called by usb_add_hcd().
> > diff --git a/include/linux/usb/xhci_pdriver.h b/include/linux/usb/xhci_pdriver.h
> > index 376654b..a37a3a5 100644
> > --- a/include/linux/usb/xhci_pdriver.h
> > +++ b/include/linux/usb/xhci_pdriver.h
> > @@ -18,10 +18,14 @@
> >   *
> >   * @usb3_lpm_capable:        determines if this xhci platform supports USB3
> >   *                   LPM capability
> > + * @delay_portcsc_clear:     determines if Synopsis USB3 core has errata in
> > + *                           "DWC_USB3_SUSPEND_ON_DISCONNECT_EN=1" hardware
> > + *                           configuration.
> >   *
> >   */
> >  struct usb_xhci_pdata {
> >       unsigned        usb3_lpm_capable:1;
> > +     unsigned        delay_portcsc_clear:1;
>
> previous patch won't build before this is applied. That's a problem.
> Please shuffle things around so that each and every patch builds and
> works on its own.
>
> We cannot break bisectability ;-)

Ah...sorry I seem to make a mess here,
i'll re-arrange all patches next round.

Much appreciate,
Sneeker

>
> --
> balbi
