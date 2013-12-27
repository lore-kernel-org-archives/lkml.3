Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547Ab3L0M52 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 07:57:28 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34873 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab3L0M51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 07:57:27 -0500
Date: Fri, 27 Dec 2013 13:57:25 +0100
From: Pavel Machek <pavel@ucw.cz>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Joe Xue <lgxue@hotmail.com>, "cooloney@gmail.com" <cooloney@gmail.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "rob@landley.net" <rob@landley.net>,
        "milo.kim@ti.com" <milo.kim@ti.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH] Add the LED burst trigger
Message-ID: <20131227125725.GA21506@amd.pavel.ucw.cz>
References: <1387895407-28031-1-git-send-email-lgxue@hotmail.com>
 <20131225230935.GB13593@amd.pavel.ucw.cz>
 <BLU172-W52032BFEF4512123D7516EACC20@phx.gbl>
 <20131227115746.4cbd9523@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131227115746.4cbd9523@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Yes, Morse code can indicate any means. But when we look at the LEDs, would we like to also have a Morse code book in hand?
> > 
> > The burst led blink idea is because it is easy to use and easy to describe. Mostly when users on site are describing the LEDs states to the support engineer.
> 
> Sure but 
> - Why bother putting it into the kernel when you can do it in user
> space

At least nokia N900 actually has "hardware acceleration" for LED
blinking. (Tiny CPU connected over i2c, able to control 3 LEDs, turing
complete with something like 20 _bits_ of storage and 30 program
steps). Apparently, it makes more stable patterns (timing is very hard
to guarantee from userspace) and better power consumption (no need to
wake the CPU to blink the LEDs).

Now, wins from going userspace->kernel will not be too huge. But "If
the hardware can accelerate it, kernel should offer it even on
hardware that can not do it, for consistency".

[Ok, I should mention that N900 can actually do 3-colored LED with PWM
and synchronization between the colors -- so it can do smooth power
ramp ups. Proposed interface does not cover that.

Actually even better interface might be:

integer: time in msec for each step
pattern: binary string, with each u8 being intensity in 0-255 range

That would cover N900 features that are easy to emulate while being
practical to do on machines that do not have hardware acceleration for
LEDs. But it still does not cover synchronization between the three
RGB channels :-(.]

> - Why use morse code when you are probably better using something that
>   can be decoded in software off a phone video and so has FEC (viterbi or
>   similar) on it ?

I'd say decoding "3 blinks" -- dishwasher lacks water is easier than
pulling than installing decoding app on a phone.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
