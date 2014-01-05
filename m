Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101AbaAEWXw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 17:23:52 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33401 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbaAEWXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 17:23:48 -0500
Date: Sun, 5 Jan 2014 23:23:46 +0100
From: Pavel Machek <pavel@ucw.cz>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, pali.rohar@gmail.com,
        sre@ring0.de, milo.kim@ti.com, linus.walleij@linaro.org
Cc: Bryan Wu <cooloney@gmail.com>, David Lang <david@lang.hm>,
        Joe Xue <lgxue@hotmail.com>, "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "rob@landley.net" <rob@landley.net>,
        "milo.kim@ti.com" <milo.kim@ti.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: n900 led compiler (was Re: [PATCH] Add LED pattern trigger)
Message-ID: <20140105222346.GA25152@amd.pavel.ucw.cz>
References: <1388362275-1618-1-git-send-email-lgxue@hotmail.com>
 <20131230162158.7420e811@alan.etchedpixels.co.uk>
 <BLU172-W451DF59115DB2B0A7F694AACC90@phx.gbl>
 <20140101201053.12be7d27@alan.etchedpixels.co.uk>
 <alpine.DEB.2.02.1401011423180.27645@nftneq.ynat.uz>
 <20140101230135.48f6f781@alan.etchedpixels.co.uk>
 <alpine.DEB.2.02.1401011547340.27645@nftneq.ynat.uz>
 <CAK5ve-KTQvJeLXmJt-NgPy6Ju+kBzWVoSQB7TKR9TW+mfD=bxg@mail.gmail.com>
 <20140103152313.4fd5c48f@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140103152313.4fd5c48f@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > IMHO, firstly we should take this trigger into kernel, most time it
> > works as a module. But we need to define a good interface between
> > kernel and user space.
> 
> You need the interface defined first. To do that it needs to reflect the
> actual hardware accelerated devices, and also to deal with resource
> management for those devices if necessary (eg if they can only manage one
> led of a set at a time).

Hardware can do quite a lot:

http://wiki.maemo.org/LED_patterns#Lysti_Format_Engine_Patterns_and_Commands

(and more).

I implemented compiler for it (should we put it into tools/ somewhere?)

https://gitorious.org/tui/tui/source/5b3f5cacf8e208d3ea50d6066e549940d85e55be:maemo/notcc.py

It can do quite a lot, including prime number computation. This uses
33% of program memory and only one of three execution units; but it
does not work, maybe I made mistake somewhere or maybe our kernel
can't take program this long. It only has 3 writable variables, which
is quite limiting.

start()
a = 1
next_number: a += 1
b = 1
next_divisor: b += 1
br = b
if (b==a) goto is_prime
c = 0
c = c+b
test_prime: if (c==a) goto not_prime
if (a<c) goto not_divisor
c = c+b
goto test_prime
not_divisor: goto next_divisor
not_prime: goto next_number
is_prime: b = 0
show_prime: c = 255
br = c
ramp_up_long(30,0)
c = 0
br = c
ramp_up_long(30,0)
b += 1
if (b == a) goto next_number2
goto show_prime
next_number2: goto next_number

> So the starting point has to be the hardware accelerated devices, whether
> you then support software emulation in kernel or user space is a follow
> on discussion. What the kernel/user API is also has to be a follow on

Well... this one is turing complete, and I have a compiler, but I
don't think it is good interface, either for library or kernel.

I believe series of RGB values might be good interface, maybe with
additional "want interpolation between these".
     		      	  	      	     	      	      	     Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
