Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693Ab3L1T3k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 14:29:40 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55187 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab3L1T3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 14:29:38 -0500
Date: Sat, 28 Dec 2013 20:29:35 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Geert Uytterhoeven <geert@linux-m68k.org>, Greg KH <greg@kroah.com>
Cc: Joe Xue <lgxue@hotmail.com>, "cooloney@gmail.com" <cooloney@gmail.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "rob@landley.net" <rob@landley.net>,
        "milo.kim@ti.com" <milo.kim@ti.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: how to represent sequence of brightnesses in /sys (was Re: [PATCH]
 Add the LED burst trigger)
Message-ID: <20131228192935.GA28119@amd.pavel.ucw.cz>
References: <1387895407-28031-1-git-send-email-lgxue@hotmail.com>
 <20131225230935.GB13593@amd.pavel.ucw.cz>
 <BLU172-W52032BFEF4512123D7516EACC20@phx.gbl>
 <20131226142607.GA15225@amd.pavel.ucw.cz>
 <BLU172-W30E6E7C0BC2B6C08FA0552ACCD0@phx.gbl>
 <20131227095705.GC17143@amd.pavel.ucw.cz>
 <BLU172-W8D850A8DEA8C0D87FBF45ACCC0@phx.gbl>
 <20131228101622.GA13564@amd.pavel.ucw.cz>
 <CAMuHMdVz7FWgYZRVHy6pK+g_2QKxTW00N8jmjWHe05m5CJvPOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdVz7FWgYZRVHy6pK+g_2QKxTW00N8jmjWHe05m5CJvPOw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2013-12-28 19:51:59, Geert Uytterhoeven wrote:
> On Sat, Dec 28, 2013 at 11:16 AM, Pavel Machek <pavel@ucw.cz> wrote:
> >> Good idea.
> >> I have finished but I'll change it to this way soon and test it in next some days.
> >>
> >> What the idea about the character to indicate stop?
> >>
> >> I mean this patten maybe indicate just once maybe indicate repeatedly until the next patten.
> >>
> >> What about "/"?
> >> If there is a "/" at end then stop it else repeat it?
> >
> > Actually, I'd put a do_repeat attribute somewhere instead of using
> > magic character for automatic repeats.
> >
> > And while " " for pause and "#" for light would work. Maybe we chould
> > do "\0" for pause and "\177" for light... and interpret everything
> > between as an intensity. That will make it useful for LEDs with
> > variable intensites, too...
> 
> Sysfs is meant to be human-readable/writable, so please use plain ASCII
> numbers in strings instead.

Actually, sysfs is meant to be one value per file, and it is
understood that data that are "natively blob" are just passed as
blob. (I believe this qualifies).

Sequence of ascii numbers would work for me, but I don't think that is
allowed.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
