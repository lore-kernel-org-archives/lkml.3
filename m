Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbaAAXCI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 18:02:08 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:60032 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876AbaAAXCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 18:02:05 -0500
Date: Wed, 1 Jan 2014 23:01:35 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: David Lang <david@lang.hm>
Cc: Joe Xue <lgxue@hotmail.com>, "cooloney@gmail.com" <cooloney@gmail.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "rob@landley.net" <rob@landley.net>,
        "milo.kim@ti.com" <milo.kim@ti.com>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH] Add LED pattern trigger
Message-ID: <20140101230135.48f6f781@alan.etchedpixels.co.uk>
In-Reply-To: <alpine.DEB.2.02.1401011423180.27645@nftneq.ynat.uz>
References: <1388362275-1618-1-git-send-email-lgxue@hotmail.com>
	<20131230162158.7420e811@alan.etchedpixels.co.uk>
	<BLU172-W451DF59115DB2B0A7F694AACC90@phx.gbl>
	<20140101201053.12be7d27@alan.etchedpixels.co.uk>
	<alpine.DEB.2.02.1401011423180.27645@nftneq.ynat.uz>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> whatever mechanism is created for toggling LEDs should be able to toggle 
> arbitrary GPIO pins, and there is a problem with the speed of the standard 
> access mechanisms in /sysfs. see this post on hackaday for an example
> 
> http://hackaday.com/2013/12/07/speeding-up-beaglebone-black-gpio-a-thousand-times/

The usage described is short human speed flashing patterns for things like
"my brain fell out" from devices, not trying to do 1KHz PWM dimming.
Dimming might actually be one case you want the kernel interface,
although it'll kill your power management.

> Also, since there are a number of cases where this is hardware accelerated, it 
> seems like there should be an abstration that userspace can use that doesn't 
> care if or how it's accelerated, setup the output and tell the system to do it 
> without worrying about the specific hardware details. Isn't that a large part of 
> what the kernel is supposed to be doing?

Not usually. The kernel is supposed to be providing a consistent interface
to hardware, not emulating bits you don't have. Now and then it does (Eg
FPU emulation) but in general the job it does is "make all the network
cards look the same" not "make pretend network cards out of string and
cups". It's not a hard and fast rule in either direction. There are cases
the kernel doesn't try and create a common interface for the hardware
because the abstraction that can be done at kernel level would be
nonsensical.

A library also allows a higher level of abstraction and better security,
and it allows consistency a kernel interface cannot provide as well as
not pinning down memory which at least in embedded space is valuable (and
may become more so in the 'internet of things' world of lower and lower
power and cheaper and cheaper widgets)

At best a kernel interface would mean people writing "post 3.15 do this,
pre 3.15 do the other". A library interface avoids that as it will work
with old kernels too, and can be taught to interface with acceleration
features, or even with other device types. A kernel interface cannot
drive X.10 for example, drive a remote bluetooth display, beep the code or
flash the LED patterns as an overlay on a monitor. Nor can it do things
like automatically routing the alert based upon stuff like "is the
display on", "is the management interface up" etc.

The library interface can also be made to do sensible things in virtual
environments, on other operating systems and so forth.

Alan
