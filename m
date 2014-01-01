Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbaAAWyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 17:54:23 -0500
Received: from mail.lang.hm ([64.81.33.126]:33658 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754686AbaAAWyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 17:54:21 -0500
X-Greylist: delayed 526 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Jan 2014 17:54:21 EST
Date: Wed, 1 Jan 2014 14:44:58 -0800 (PST)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
cc: Joe Xue <lgxue@hotmail.com>, "cooloney@gmail.com" <cooloney@gmail.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "rob@landley.net" <rob@landley.net>,
        "milo.kim@ti.com" <milo.kim@ti.com>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH] Add LED pattern trigger
In-Reply-To: <20140101201053.12be7d27@alan.etchedpixels.co.uk>
Message-ID: <alpine.DEB.2.02.1401011423180.27645@nftneq.ynat.uz>
References: <1388362275-1618-1-git-send-email-lgxue@hotmail.com> <20131230162158.7420e811@alan.etchedpixels.co.uk> <BLU172-W451DF59115DB2B0A7F694AACC90@phx.gbl> <20140101201053.12be7d27@alan.etchedpixels.co.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jan 2014, One Thousand Gnomes wrote:

> On Tue, 31 Dec 2013 13:48:50 -0500
> Joe Xue <lgxue@hotmail.com> wrote:
>
>>>> + * Based on Richard Purdie's ledtrig-timer.c and Atsushi Nemoto's
>>>> + * ledtrig-heartbeat.c and Shuah Khan's ledtrig-transient.c
>>>
>>> I stil think this belongs in user space except for platforms with hardware
>>> acceleration for it.
>>
>> This can free the user space application from loop or thread.
>
> Which is not a good reason for putting it in the kernel. I could make the
> same argument for putting firefox in the kernel ...
>

I agree with you that this isn't a good reason, but I think the performance 
could be a reason.

whatever mechanism is created for toggling LEDs should be able to toggle 
arbitrary GPIO pins, and there is a problem with the speed of the standard 
access mechanisms in /sysfs. see this post on hackaday for an example

http://hackaday.com/2013/12/07/speeding-up-beaglebone-black-gpio-a-thousand-times/

now, it may be that telling people to access /dev/mem is deemed a better option, 
but I would hope not.

Also, since there are a number of cases where this is hardware accelerated, it 
seems like there should be an abstration that userspace can use that doesn't 
care if or how it's accelerated, setup the output and tell the system to do it 
without worrying about the specific hardware details. Isn't that a large part of 
what the kernel is supposed to be doing?

David Lang
