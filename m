Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbaJJJRZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 05:17:25 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:46569 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbaJJJRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 05:17:22 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Fri, 10 Oct 2014 11:14:34 +0200
From: Johan Hovold <johan@kernel.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, Wolfram Sang <wsa@the-dreams.de>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Johan Hovold <johan@kernel.org>,
        Daniel Baluta <daniel.baluta@intel.com>,
        Laurentiu Palcu <laurentiu.palcu@intel.com>, linux-usb@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v7 1/4] mfd: add support for Diolan DLN-2 devices
Message-ID: <20141010091434.GB12494@localhost>
References: <1412882541-10934-1-git-send-email-octavian.purdila@intel.com>
 <1412882541-10934-2-git-send-email-octavian.purdila@intel.com>
 <1412883877.2975.26.camel@joe-AO725>
 <CAE1zotJTQATJkTQinnWOg=NJbG+SWzNNdgB2uVEJgubnhtyXbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE1zotJTQATJkTQinnWOg=NJbG+SWzNNdgB2uVEJgubnhtyXbA@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 11:27:12PM +0300, Octavian Purdila wrote:
> On Thu, Oct 9, 2014 at 10:44 PM, Joe Perches <joe@perches.com> wrote:
> > On Thu, 2014-10-09 at 22:22 +0300, Octavian Purdila wrote:

> >> diff --git a/drivers/mfd/dln2.c b/drivers/mfd/dln2.c
> > []
> > +struct dln2_mod_rx_slots {
> > +       /* RX slots bitmap */
> > +       unsigned long bmap;
> >
> > Probably better as:
> >         DECLARE_BITMAP(bmap, DLN2_MAX_RX_SLOTS);
> >
> > Then a lot of &ptr->bmap uses can be ptr->bmap
> >
> 
> Originally I was using DECLARE_BITMAP, but during the review process
> Johan suggested to use unsigned long. Now that I think about it, it
> sounds better to use DECLARE_BITMAP and of couse keep using
> find_first_bit, set_bit, etc. Johan do you see any issue with that?

No, that's fine as long as you keep the bitops.

> >> +struct dln2_dev {
> >> +     struct usb_device *usb_dev;
> >> +     struct usb_interface *interface;
> >> +     u8 ep_in;
> >> +     u8 ep_out;
> >> +
> >> +     struct urb *rx_urb[DLN2_MAX_URBS];
> >> +     void *rx_buf[DLN2_MAX_URBS];
> >> +
> >> +     struct dln2_mod_rx_slots mod_rx_slots[DLN2_HANDLES];
> >> +
> >> +     struct list_head event_cb_list;
> >> +     spinlock_t event_cb_lock;
> >> +
> >> +     bool disconnect;
> >> +     int active_transfers;
> >> +     wait_queue_head_t disconnect_wq;
> >> +     spinlock_t disconnect_lock;
> >> +};
> >
> > Maybe reorder the bools and u8s to pack this a bit better?
> 
> I prefer to keep it this way, it's not wasting a lot since you will
> only have a handful of these devices, and it keeps the related data
> together.

I agree.

Johan
