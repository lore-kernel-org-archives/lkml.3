Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab3JNBTn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 21:19:43 -0400
Received: from mail.active-venture.com ([67.228.131.205]:59851 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755454Ab3JNBTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 21:19:42 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <525B46A7.8000605@roeck-us.net>
Date: Sun, 13 Oct 2013 18:19:35 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-kernel@vger.kernel.org
CC: Chris Eastwood <chris2027@gmail.com>, gregkh@linuxfoundation.org
Subject: Re: support for Intel Atom based QNAP LEDs/buttons/buzzer in Linux?
References: <1381707976.3914.22.camel@heisenberg.scientia.net>
In-Reply-To: <1381707976.3914.22.camel@heisenberg.scientia.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2013 04:46 PM, Christoph Anton Mitterer wrote:
> Hi Greg, Guenter and Chris.
>
> Coming back to the stuff discussed previously[0].
>
> Chris Eastwood has made most of these (i.e. LEDs and buttons, the
> buzzers may work on at least some of the devices via some other serial
> device) working (AFAIU based on the previously mentioned code at
> Github[1]), he told me in several iterations of private mail.
>
> I'm not sure now, whether anything based on this code would be
> appropriate for the mainline kernel, since Guenter mentioned he'd prefer
> a mfd core driver for all that... OTOH, the later may probably never
> happen, and Chris' work seems to already do the job.
>
> I don't know however, whether he needs to patch any other places in the
> kernel, but I'm sure he can show his work (and ask questions) better
> than I, thereby inviting him to do so.
> Greg you had mentioned before that you might be able to spend some time
> on this, so if you could help Chris, that would be great.
>
>
You really have two options - either an mfd driver with client drivers
for hwmon, gpio, watchdog (and possibly others), or a gpio driver which
shares access to the superio control registers. Both the it87 hwmon driver
and the it87 watchdog driver support the latter mechanism already, so that
would be the (much) simpler option. To control the LEDs you would then
simply use the leds-gpio driver. Input would need something similar -
no idea if there is a generic input-gpio driver; if not it might make sense
to write one. Another option there would be to have a platform driver which
would tie into the gpio driver and pass the gpio pin status to the input
subsystem.

I had a look at Chris' driver, but in my opinion it is simply too hardware
specific to be acceptable as-is. Of course, I would not make the call,
so that is just my persional opinion.

Thanks,
Guenter

