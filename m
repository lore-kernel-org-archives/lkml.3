Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbaDDTJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 15:09:23 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:39018 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbaDDTJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 15:09:22 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrW7-AEZkfnFy1L0heyKxo188C9DB+ruFAvfT6iUkKxYZw@mail.gmail.com>
References: <20140402144219.4cafbe37@gandalf.local.home>
	<20140402221212.GD16570@mguzik.redhat.com>
	<CA+55aFyZSr4G2a1X5+EeSgKGtZvzBfBg0D0L39g-DB9TLi+ZEw@mail.gmail.com>
	<alpine.LRH.2.00.1404030119270.23421@twin.jikos.cz>
	<20140402162839.d3c00e9845e89d0f092c2ce3@linux-foundation.org>
	<CA+55aFw7NyryF3F3x05rLjt6rFwD5xUoZB06CV2mpwwRxcVHxg@mail.gmail.com>
	<alpine.LNX.2.00.1404030145490.32122@pobox.suse.cz>
	<CA+55aFzo85-sdC_eDVRWcCdsK2p1JxCjswYidq-QSi5RieGmBA@mail.gmail.com>
	<CA+55aFyphF8kd4OwWdar4p5M1=Sxc54sfk0RWFPpO6zrezZwJA@mail.gmail.com>
	<20140403104308.GP13491@8bytes.org>
	<20140403170541.GA19010@thunk.org>
	<533EF832.1030902@mit.edu>
	<CA+55aFxC_+zCD8BQ637WJLf2VXWjhJOQB7uUkVARneSKsQ2+Hg@mail.gmail.com>
	<CALCETrW7-AEZkfnFy1L0heyKxo188C9DB+ruFAvfT6iUkKxYZw@mail.gmail.com>
Date: Fri, 4 Apr 2014 12:09:21 -0700
X-Google-Sender-Auth: 18Kubs70mzM4OiMHRCMCyQjo6Yk
Message-ID: <CA+55aFz8wxNGBU9nibJu9TTNac9v7hhrSN4o=6D2qNTsVx2rXA@mail.gmail.com>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Joerg Roedel <joro@8bytes.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mateusz Guzik <mguzik@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Kay Sievers <kay@vrfy.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 4, 2014 at 11:57 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> What would break if we used CLOCK_BOOTTIME or CLOCK_MONOTONIC?

I wouldn't object to trying - I thought you meant changing the format
itself. If we keep the semantics (seconds since boot) but just change
the clock source in other ways, I wouldn't worry.

Of course, one issue is locking and performance. Most clock sources
are nasty as hell to read. "sched_clock()" is special.

But I'm absolutely ok with trying things out, so if you have an idea
for a patch...

> It would be really neat if we even went back and edited the queued up
> messages once we have a clocksource.

Sounds great, I'd love to see it. Patches welcome ;)

> There are also log message metadata fields now; we could stick more
> than one timestamp in there, and existing tools either won't see them
> at all (if they use klogctl) or they already know how to ignore
> unknown fields (/dev/kmsg).

That sounds like overkill, but trying to aim for something that is
actually accurate to within a second is fine.

That said, I *also* suspect that we could easily just have a simple
heartbeat message that gives accurate real time. Adding a kernel
heartbeat to dmesg is something I've often wanted to have myself.
Having something that prints out real wall-clock time every 30 minutes
or so in dmesg does not sound like a bad idea, and could be used to
correct for time skew with the existing one even if we decided that
CLOCK_BOOTTIME has too many locking/performance issues.

                  Linus
