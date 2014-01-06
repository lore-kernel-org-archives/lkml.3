Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbaAFAhS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 19:37:18 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55718 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbaAFAhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 19:37:16 -0500
Date: Mon, 6 Jan 2014 01:37:14 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Bryan Wu <cooloney@gmail.com>
Cc: Greg KH <greg@kroah.com>, Geert Uytterhoeven <geert@linux-m68k.org>,
        Joe Xue <lgxue@hotmail.com>, "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "rob@landley.net" <rob@landley.net>,
        "milo.kim@ti.com" <milo.kim@ti.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: how to represent sequence of brightnesses in /sys (was Re:
 [PATCH] Add the LED burst trigger)
Message-ID: <20140106003714.GD27517@amd.pavel.ucw.cz>
References: <20131228101622.GA13564@amd.pavel.ucw.cz>
 <CAMuHMdVz7FWgYZRVHy6pK+g_2QKxTW00N8jmjWHe05m5CJvPOw@mail.gmail.com>
 <20131228192935.GA28119@amd.pavel.ucw.cz>
 <CAMuHMdXDJ6uhe6srV-+0a8=cpBUgP+VakG+_wyLwAuiQSRVhqQ@mail.gmail.com>
 <20131228212523.GA8733@amd.pavel.ucw.cz>
 <20131228215042.GA7048@kroah.com>
 <20131228235045.GA8786@amd.pavel.ucw.cz>
 <20131229014324.GB18455@kroah.com>
 <20131229112101.GB26295@amd.pavel.ucw.cz>
 <CAK5ve-LOFE6h5w=+pSgfYMaW5GZQfayVfpRzP0NAfMPWZkk5iw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK5ve-LOFE6h5w=+pSgfYMaW5GZQfayVfpRzP0NAfMPWZkk5iw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> > Reason to do it in kernel is that some machines actually have
> >> > "coprocessor" on i2c that can do it while main CPU is suspended. (For
> >> > more reasons, see beggining of thread).
> >>
> >> Ick ick.
> >>
> >> > Binary attribute with array of bytes should be acceptable, rights?
> >>
> >> Not at all.
> >>
> >> > (IOW write(..., buf, size) )
> >> >
> >> > Ascii array of decimal integers -- no so, right?
> >> >
> >> > (IOW printf("%d %d ..", buf[0], buf[1]) )
> >>
> >> Use an ioctl with a structure to get things correct as a character
> >> device.  As odds are, you aren't going to be able to create a "generic"
> >> format for all of this for all types of devices that support such a
> >> "co-processor".
> >
> > Well, we already do have hw-specific driver in the tree,
> > drivers/leds/leds-lp55xx-common.c . But the interface is
> > "interesting" and I believe we should have generic interface and it
> > should use existing trigger framework -- array of brightnesses does
> > not seem too complicated.
> >
> > Do you have suggestion how to pass the brightnesses over sysfs?
> >
> 
> What about send those binary stuff as firmware through kernel firmware
> interface and LED trigger sysfs is just for parameters setup and
> enable/disable controlling.

That might be a bit too heavy. LED patterns do change quite often.

lp5523 driver uses this to push binary data through /sys. (It is code
for lp5523 processor in this case). Something like that would still be
better than firmware loader... 

cd /sys/class/i2c-adapter/i2c-2/2-0032 
echo load > engine1_mode 
echo cd /sys/class/i2c-adapter/i2c-2/2-0032 
echo 9d804000427f0d7f7f007f0042000000  > engine1_load 
echo run > engine1_mode
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
