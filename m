Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273AbaDDToc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 15:44:32 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:41344 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754019AbaDDToa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 15:44:30 -0400
Date: Fri, 4 Apr 2014 15:44:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>, "Theodore Ts'o" <tytso@mit.edu>,
        Joerg Roedel <joro@8bytes.org>, Jiri Kosina <jkosina@suse.cz>,
        Mateusz Guzik <mguzik@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
Message-ID: <20140404154426.6f099f7d@gandalf.local.home>
In-Reply-To: <20140404115139.3ea3d53126094f41bc0579a0@linux-foundation.org>
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
	<CA+55aFz=rnGo_DvtYa4aonm_JUyWe5cynLcsCYDfr+jMZ91+Sg@mail.gmail.com>
	<20140404115139.3ea3d53126094f41bc0579a0@linux-foundation.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Apr 2014 11:51:39 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 4 Apr 2014 11:42:51 -0700 Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > Most users will never notice. The whole "writable /dev/kmsg" may go
> > back to 2002, but there aren't _that_ many users, and pretty much all
> > I've ever seen tend to write the occasional "I started up" messages or
> > other very small notes. I had to write a test-script to trigger even
> > the (very draconian) default ratelimits.
> 
> Is there anything here that we really need to fix?  What goes wrong if
> we leave kmsg as-is and systemd gets fixed?

I saw one commenter say that this was a kernel bug because writing to
kmsg shouldn't cause the system to hang.

The rate-limit patch would go along with that idea, and I honestly
think it would be good to rate-limit it in case something else breaks
and starts spamming kmsg.

-- Steve
