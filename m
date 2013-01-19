Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089Ab3ASRTs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 12:19:48 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60583 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab3ASRTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 12:19:47 -0500
Date: Sat, 19 Jan 2013 18:19:36 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Takashi Iwai <tiwai@suse.de>
Cc: kernel list <linux-kernel@vger.kernel.org>, perex@perex.cz,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Null pointer dereference when accessing /dev/dsp1 with USB
 speakers
Message-ID: <20130119171936.GA4275@amd.pavel.ucw.cz>
References: <20130118203657.GA3555@amd.pavel.ucw.cz>
 <s5hlibpzb3w.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hlibpzb3w.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I have USB speakers 
> > 
> > Bus 004 Device 002: ID 04fa:4201 Dallas Semiconductor DS4201 Audio DAC
> > 
> > ... which make problems again
> > (https://lkml.org/lkml/2008/3/20/274). They refuse to produce sound,
> > so I updated to 3.8.0-rc2 in hope that would help... and tried testing
> > them by "cat /bin/bash > /dev/dsp1". Instant crash :-(.
> > 
> > I guess this will happen in more than one config...?
> 
> This Oops should have been fixed recently.  Please try 3.8-rc4.
> 
> commit 31be5425d795585251a3ee970319c37643e0cda2
>     ALSA: usb-audio: Fix NULL dereference by access to non-existing
>     substream


It is fixed in 3.8-rc4. But... I still get this: (it happened at least
once with 3.8-rc2 and once with 3.8-rc4).

> > Jan 18 21:23:00 amd kernel: Slab corruption (Tainted: G        W   ):
> > size-128 start=edd71b40, len=128
> > Jan 18 21:23:00 amd kernel: 070: 6b 6b 6b 6b 6b 6b 6b 6b 00 6b 6b 6b
> > 6b 6b 6b a5  kkkkkkkk.kkkkkk.
> > Jan 18 21:23:00 amd kernel: Prev obj: start=edd71ac0, len=128
> > Jan 18 21:23:00 amd kernel: 000: 00 7f e9 e9 c8 2f 40 f0 00 00 00 00
> > 00 00 00 00  ...../@.........
> > Jan 18 21:23:00 amd kernel: 010: 00 00 00 00 00 00 00 00 00 6c 94 e9
> > 00 00 00 00  .........l......
> > Jan 18 21:23:00 amd kernel: Next obj: start=edd71bc0, len=128
> > Jan 18 21:23:00 amd kernel: 000: 40 12 d7 ed 40 11 d7 ed 02 00 00 00
> > 02 00 00 00  @...@...........
> > Jan 18 21:23:00 amd kernel: 010: 00 00 00 00 00 00 00 00 20 53 77 69
> > 74 63 68 00  ........ Switch.
> > Jan 18 21:23:00 amd kernel: 8:0: cannot get min/max values for control
> > 5 (id 8)
> > Jan 18 21:23:00 amd kernel: 8:0: cannot get min/max values for control
> > 6 (id 8)
> > Jan 18 21:23:00 amd kernel: 8:0: cannot get min/max values for control
> > 1 (id 8)
> > Jan 18 21:23:00 amd kernel: 8:0: cannot get min/max values for control
> > 2 (id 8)
> > Jan 18 21:23:00 amd kernel: usb 4-1: adding 4-1:1.1 (config #1,
> > interface 1)
> > Jan 18 21:23:00 amd kernel: hub 4-0:1.0: state 7 ports 2 chg 0000 evt
> > 0002

Any ideas? Any similar reports?

(Hmm, and maybe "SLAB corruption" messages should have higher
severity? KERN_ALERT or something, so that it is broadcast to all
consoles?)

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
