Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbaDDSmy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 14:42:54 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:43726 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839AbaDDSmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 14:42:52 -0400
MIME-Version: 1.0
In-Reply-To: <533EF832.1030902@mit.edu>
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
Date: Fri, 4 Apr 2014 11:42:51 -0700
X-Google-Sender-Auth: nDV-aY1Cq7UR06T_8XpT6SXTZrQ
Message-ID: <CA+55aFz=rnGo_DvtYa4aonm_JUyWe5cynLcsCYDfr+jMZ91+Sg@mail.gmail.com>
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

On Fri, Apr 4, 2014 at 11:21 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> I'm using /dev/kmsg in virtme so that I can easily capture, with
> timestamps, the ten or so log lines that it produces.  It would be sad
> if I had to worry about small ratelimits here.

So the _default_ rate limits (which is what my example patch used) are
almost certainly not appropriate for /dev/kmsg.

It would be good to hear suggestions for what *would* be reasonable.
Because it does sound like we'll have to add rate limiting.

Most users will never notice. The whole "writable /dev/kmsg" may go
back to 2002, but there aren't _that_ many users, and pretty much all
I've ever seen tend to write the occasional "I started up" messages or
other very small notes. I had to write a test-script to trigger even
the (very draconian) default ratelimits.

                 Linus
