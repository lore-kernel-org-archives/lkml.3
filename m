Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbaJGSBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 14:01:31 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:58118 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbaJGSB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 14:01:28 -0400
MIME-Version: 1.0
In-Reply-To: <20141007171003.GI5362@localhost>
References: <1411661254-5204-1-git-send-email-octavian.purdila@intel.com>
	<1411661254-5204-2-git-send-email-octavian.purdila@intel.com>
	<20141003171207.GC2394@localhost>
	<CAE1zotLEV-=JvCJvEQqg8CA6fu3UWmPOx3ZYgpd+rYSuSEVmNQ@mail.gmail.com>
	<20141007171003.GI5362@localhost>
Date: Tue, 7 Oct 2014 21:01:27 +0300
Message-ID: <CAE1zotLmO=VPkE5RYpr1k0-3N8__7A8pWCEM23hXh6nzEqAjeQ@mail.gmail.com>
Subject: Re: [PATCH v6 1/4] mfd: add support for Diolan DLN-2 devices
From: Octavian Purdila <octavian.purdila@intel.com>
To: Johan Hovold <johan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, Wolfram Sang <wsa@the-dreams.de>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Daniel Baluta <daniel.baluta@intel.com>,
        Laurentiu Palcu <laurentiu.palcu@intel.com>, linux-usb@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 7, 2014 at 8:10 PM, Johan Hovold <johan@kernel.org> wrote:
> On Mon, Oct 06, 2014 at 03:17:22PM +0300, Octavian Purdila wrote:
>> On Fri, Oct 3, 2014 at 8:12 PM, Johan Hovold <johan@kernel.org> wrote:
>> >
>> > On Thu, Sep 25, 2014 at 07:07:31PM +0300, Octavian Purdila wrote:
>> > > This patch implements the USB part of the Diolan USB-I2C/SPI/GPIO
>> > > Master Adapter DLN-2. Details about the device can be found here:
>> > >
>>
>> <snip>
>>
>> > > +
>> > > +             ret = dln2_submit_urb(dln2, dln2->rx_urb[i], GFP_KERNEL);
>> > > +             if (ret < 0)
>> > > +                     return ret;
>> >
>> > Is it really worth having this helper only to save a couple of lines on
>> > a dev_err? If you do all resubmissions on completion inline in the
>> > handler, you only have three places where usb_submit_urb is called.
>> >
>>
>> I moved the completion in the handler as you suggested. I have kept
>> the helper, would you prefer to remove it?
>
> Moved the "completion"? I was suggesting that the URB resubmission
> should be done inline the URB completion handler.
>
> [ "Completion" may be a little ambiguous. The URB callback is called an
> URB completion handler. Not be confused with the completion structures
> you use to wait for responses. ]
>

Sorry, I meant to say resubmission instead of completion.

> It's fine to keep the helper as long as it's clear that the urb has been
> "cached" and should not be resubmitted (inline) in the completion
> handler in that case.
>

Not sure I follow you here. I kept the helper and I call it from the
completion handler, from free_rx_slot and from dln2_setup_rx_ubs.

>
>> <snip>
>>
>> > > +     id = dln2->usb_dev->bus->busnum << 8 | dln2->usb_dev->devnum;
>> >
>> > After giving this some more thought, I think you should just
>> > use PLATFORM_DEVID_AUTO as id. I have submitted a series to fix the
>> > other USB MFD drivers and add a convenience helper to register
>> > hotpluggable MFDs here:
>> >
>>
>> OK, I will use PLATFORM_DEVID_AUTO for now. If your series merges
>> first and I have to resubmit mine, I will switch to using
>> mfd_add_hotplug_devices.
>
> Lee merged the helper function earlier today.
>

Yep, noticed that, I did a rebase earlier.
