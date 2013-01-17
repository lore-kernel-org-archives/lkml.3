Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab3AQRLL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 12:11:11 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:35093 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946Ab3AQRLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 12:11:10 -0500
Date: Thu, 17 Jan 2013 18:11:00 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: lars@metafoo.de
Cc: christophe.leroy@c-s.fr, jic23@cam.ac.uk, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, patrick.vasseur@c-s.fr
Subject: Re: [PATCH] IIO ADC support for AD7923
Message-ID: <20130117171100.GA24398@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <50F199F7.7020600@metafoo.de>
References: <50F199F7.7020600@metafoo.de>
  <201301080842.r088gKWO031124@localhost.localdomain>
 <20130108091414.GA28404@mail.gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I wonder if IIO config symbols should have IIO_ in their name, so
>> people looking at config files knows what they actually are.
>> Actually, all USB drivers have USB in their config name, which is
>> useful even if e.g. "PL2303" cannot be but USB.
>> 
>> On the other hand, AD7923 and all the others can well be driven by
>> something else than IIO, even if currently this is the only mainstream
>> option.
> 
> No, IIO is and should be the only option for these devices. We really don't
> want to drivers for the same device in different subsystems of the kernel.

We really don't want a non-USB driver for a USB device, but still the
name is in the config symbol and is useful. And this is an hardware
constraint.

And your argument may well have applied to comedi. But they wisely
made the right choice and allowed iio to take over and possibly drive
the same devices.

But sure your code is perfect and no other subsystem will ever be needed.


To explain, this is the problem I had: IIO was still in staging, and I
had to use the ADC in the at91sam9g20.  The platform data there was
protected by "IS_ENABLED(CONFIG_AT91_ADC)", which is actually only
selectable if IIO is configured in.

What should I do if I wanted to drive directly the hardware with a
simple custom thing, because, for example, my target board is very
small?  Currently I run a patched kernel, because otherwise I can't
load my custom module and use the already-available platform data.
No, it's not only a name change, it's that the description of the
hardware should not depend on which subsystems are selected.


But yes, you are right. I'm working on another I/O subsystem. We are
gong to release zio-1.0 in a few days, because the thing is mature
and used in production.

I hope to meet you in person at fosdem and be able to talk over a beer
or two.

regards
/alessandro
