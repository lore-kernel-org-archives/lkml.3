Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761113AbaGYTdW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 15:33:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755604AbaGYTdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 15:33:20 -0400
Date: Fri, 25 Jul 2014 15:32:59 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Przemo Firszt <przemo@firszt.eu>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH v2 00/10] Input - wacom: conversion to HID driver, series
 2
Message-ID: <20140725193259.GC12268@mail.corp.redhat.com>
References: <1406225645-32141-1-git-send-email-benjamin.tissoires@redhat.com>
 <1406292140.2664.17.camel@fedora-lan>
 <20140725125820.GA12268@mail.corp.redhat.com>
 <1406295035.2664.43.camel@fedora-lan>
 <20140725145400.GB12268@mail.corp.redhat.com>
 <1406316376.12682.18.camel@fedora-lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1406316376.12682.18.camel@fedora-lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 25 2014 or thereabouts, Przemo Firszt wrote:
> Dnia 2014-07-25, pią o godzinie 10:54 -0400, Benjamin Tissoires pisze:
> > [..]
> Hi Benjamin,
> >  
> > > If I understand you correctly we cannot have the same entry point in
> > > sysfs for OLEDs unless we can tell userspace somehow if the tablet is
> > > conected over USB or over bluetooth. The hardware of Intuos4 Wireless
> > > over bluetooth allows only 1-bit images. The same hardware over USB
> > > allows 4-bit images. Formatting of the images is also completely
> > 
> > Holy crap! I missed that. I did not noticed the 1-bit vs 4-bits
> > difference :(
> > 
> > > different and it's not "plain". Check [1] for usb and exisitng
> > > hid-wacom.c/wacom_scramble function for bluetooth.
> > 
> > Maybe I overlooked it, but I thought that in case of USB, the scrambling
> > is done in user space, and in case of BT, the same scrambling made in the
> > kernel. They looks very similar so I thought the user-space scramble for
> > USB would have fit. However, the 4-bits/1-bits kills that assumption.
> 
> You're correct - USB requires scrambling in the user space, but
> scrambling for USB is different than for BT. Example of USB scramble is
> here: https://github.com/PrzemoF/i4oled/blob/master/src/i4oled.c#L401
> 
> > > 
> > > If we want to make it consistent single entry on kernel level we
> > > probably have to implement image conversion in the kernel. The user land
> > > would always use 4-bit, plain formatted images and kernel driver would
> > > convert them to 4-bit, wacom usb format or 1-bit wacom bluetooth format
> > > depending on how the tablet is connected.
> > > 
> > > The downside of this approach is that the user land wouldn't have 100%
> > > control over 1-bit images for bluetooth as kernel would have to create
> > > them from 4-bit images.
> > 
> > The USB interface is *very* simple:
> > - if incoming data != 1024 -> reject
> > - forward everything to the device without in kernel treatment*
> > 
> > How about just changing the expected size to 256 in case of a BT tablet,
> > and let the user-space scramble in both cases and forward proper raw
> > data?
> > 
> > This way, user space will still have control over 1-bit vs 4-bits, and
> > the changes required in the kernel will be small enough.
> Sounds good to me. Bit more coding in gnome, but it's a small thing.

yeah, gnome already scramble for USB, let's have it scramble for BT too
:)

> 
> > My concern is that I'd like to have this series in 3.17 and I will not
> > have access to the hardware until next week :/
> > Having all of the user-spaces breakages in the same kernel release will
> > I think simplify the user space work.
> I agree.

OK.

> 
> P.S. Could you send me that set of 23 patches using git-send-email that
> I should apply on top of linux-next? I got it from lkml, but there is
> still something messed (fails on patch 09/23). Of course, if it's not a
> problem for you :-)

Sure, I can definitively do that. I also made a small patch to check for
1024 or 256 bits in OLEDs, so if you could give a try, that would be
great.

Cheers,
Benjamin

