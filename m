Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab3AQRfi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 12:35:38 -0500
Received: from smtp-out-070.synserver.de ([212.40.185.70]:1104 "EHLO
	smtp-out-070.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370Ab3AQRfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 12:35:34 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 30985
Message-ID: <50F83695.506@metafoo.de>
Date: Thu, 17 Jan 2013 18:36:21 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121122 Icedove/10.0.11
MIME-Version: 1.0
To: Alessandro Rubini <rubini@gnudd.com>
CC: christophe.leroy@c-s.fr, jic23@cam.ac.uk, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, patrick.vasseur@c-s.fr
Subject: Re: [PATCH] IIO ADC support for AD7923
References: <50F199F7.7020600@metafoo.de>  <201301080842.r088gKWO031124@localhost.localdomain> <20130108091414.GA28404@mail.gnudd.com> <20130117171100.GA24398@mail.gnudd.com>
In-Reply-To: <20130117171100.GA24398@mail.gnudd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2013 06:11 PM, Alessandro Rubini wrote:
>>> I wonder if IIO config symbols should have IIO_ in their name, so
>>> people looking at config files knows what they actually are.
>>> Actually, all USB drivers have USB in their config name, which is
>>> useful even if e.g. "PL2303" cannot be but USB.
>>>
>>> On the other hand, AD7923 and all the others can well be driven by
>>> something else than IIO, even if currently this is the only mainstream
>>> option.
>>
>> No, IIO is and should be the only option for these devices. We really don't
>> want to drivers for the same device in different subsystems of the kernel.
> 
> We really don't want a non-USB driver for a USB device, but still the
> name is in the config symbol and is useful. And this is an hardware
> constraint.
> 
> And your argument may well have applied to comedi. But they wisely
> made the right choice and allowed iio to take over and possibly drive
> the same devices.
> 
> But sure your code is perfect and no other subsystem will ever be needed.
> 

I'm not implying IIO is perfect. IIO has certain shortcomings and some of
these shortcomings have been addressed in ZIO.

Still it's a very bad idea to have two subsystem which have a huge overlap
in both functionality and targeted devices. It will gives us all lots of
headaches later on. As IIO continues to evolve it will get support for some
of the features that only ZIO supports at the moment and as ZIO grows it
will get support for features currently only supported by IIO. So in the end
we have two frameworks for the very same purpose.

Btw. I'd be arguing the same way if ZIO was currently inside the kernel and
Jonathan came along and proposed to merge IIO.

> 
> [...]
>
> But yes, you are right. I'm working on another I/O subsystem. We are
> gong to release zio-1.0 in a few days, because the thing is mature
> and used in production.
> 
> I hope to meet you in person at fosdem and be able to talk over a beer
> or two.
> 

Looking forward to meeting you :)

- Lars

