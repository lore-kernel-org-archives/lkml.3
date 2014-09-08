Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbaIHNUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 09:20:38 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:46860 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbaIHNUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 09:20:36 -0400
MIME-Version: 1.0
In-Reply-To: <20140908113233.GA9560@localhost>
References: <1409930279-1382-1-git-send-email-octavian.purdila@intel.com>
	<1409930279-1382-2-git-send-email-octavian.purdila@intel.com>
	<20140908113233.GA9560@localhost>
Date: Mon, 8 Sep 2014 16:20:34 +0300
Message-ID: <CAE1zotL3rKb3ayjgp0DbTr-a9xAhEJk6ybdqGEzg3UtuBUKWMw@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] mfd: add support for Diolan DLN-2 devices
From: Octavian Purdila <octavian.purdila@intel.com>
To: Johan Hovold <johan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, wsa@the-dreams.de,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Daniel Baluta <daniel.baluta@intel.com>,
        Laurentiu Palcu <laurentiu.palcu@intel.com>, linux-usb@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 8, 2014 at 2:32 PM, Johan Hovold <johan@kernel.org> wrote:
>
> On Fri, Sep 05, 2014 at 06:17:57PM +0300, Octavian Purdila wrote:
> > This patch implements the USB part of the Diolan USB-I2C/SPI/GPIO
> > Master Adapter DLN-2. Details about the device can be found here:
> >
<snip>
>
> First of all, this is much cleaner than the first non-MFD version. I'll
> have a look at the subdrivers shortly as well.
>

Hi Johan,

I have addressed all you comments except one, please see bellow. I
will wait for the review on the subdrivers before submitting a new
version of the patch set. Thanks for for review !

<snip>
> > +static bool find_free_slot(struct dln2_mod_rx_slots *rxs, int *slot)
> > +{
> > +     unsigned long flags;
> > +
> > +     spin_lock_irqsave(&rxs->lock, flags);
> > +
> > +     *slot = find_first_zero_bit(&rxs->bmap, DLN2_MAX_RX_SLOTS);
> > +
> > +     if (*slot < DLN2_MAX_RX_SLOTS) {
> > +             struct dln2_rx_context *rxc = &rxs->slots[*slot];
> > +
> > +             init_completion(&rxc->done);
>
> Initialise the completions when you allocate them (and there's no need
> to re-init here).
>

You are right, but I think we need a reinit_completion(). Technically
we don't, as we don't use complete_all(), but I feel it is cleaner
that way. I will move the initialization in probe and add the
reinit_completion() in free_rx_slot. Is that OK with you?
