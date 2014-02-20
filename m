Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899AbaBTVzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 16:55:44 -0500
Received: from ip-64-139-1-69.sjc.megapath.net ([64.139.1.69]:50136 "EHLO
	ip-64-139-1-69.sjc.megapath.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752204AbaBTVzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 16:55:42 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3
To: Peter Hurley <peter@hurleysoftware.com>
cc: Hal Murray <murray+fedora@ip-64-139-1-69.sjc.megapath.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-rt-users@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
From: Hal Murray <murray+fedora@ip-64-139-1-69.sjc.megapath.net>
Subject: Re: locking changes in tty broke low latency feature
In-Reply-To: Message from Peter Hurley <peter@hurleysoftware.com>
   of "Wed, 19 Feb 2014 21:55:21 EST." <53056E99.9070900@hurleysoftware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Thu, 20 Feb 2014 13:55:41 -0800
Message-Id: <20140220215541.7D694406062@ip-64-139-1-69.sjc.megapath.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Have you tried 3.12+ without low_latency? I ripped out a lot of locks from
> 3.12+ so it's possible it already meets your requirements. 

Looks good.  I don't think I could tell the difference by looking at my 
normal collection of graphs.


> Hopefully you meant "milliseconds" here; single-digit microsecond latency on
> any kind of stable duty cycle is linux-rt territory, and simply not a
> reasonable goal for mainline. 

No, I really meant microseconds.  Remember, I'm running on a lightly loaded 
system, not trying to squeeze the impossible out of an overloaded system.

top says gpsd has niced itself to -10, and ntpd is marked RT. 

100 microseconds is easy.  I can get down to a few 10s of microseconds.  I'm 
not sure how low I could get.


>> What does "unsupported termios changes" mean?

> For example, once the port is in low_latency mode, setting L_ECHO (and its
> ilk) would be rejected. And vice versa, if the L_ECHO is set in termios,
> low_latency would be rejected.

> So running a vt console is low_latency mode is not going to work. 

OK.  I doubt if there is any problem, but we should be sure to be explicit 
about what "and its ilk" really means.

------------

I don't understand the scheduler issues that triggered this bug.

Let's go back to the big picture.  In the old old days, time sharing systems 
had lots of serial ports.  It was common for the hardware to buffer up 
several characters before requesting an interrupt in order to reduce the CPU 
load.  There was usually a bit in the hardware to bypass this if you thought 
that response time was more important than CPU load.  I was expecting 
low_latency to set that bit.

Is that option even present in modern serial chips?  Do the various chips 
claiming to be 8250/16550 and friends correctly implement all the details of 
the specs?

Many gigabit ethernet controllers have the same issue.  It's often called 
interrupt coalescing.

What/why is the serial/scheduler doing differently in the low_latency case?  
What case does that help?



-- 
These are my opinions.  I hate spam.



