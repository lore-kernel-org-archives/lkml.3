Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbaCaS1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 14:27:39 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:59148 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726AbaCaS1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 14:27:09 -0400
Message-ID: <1396290426.5261.80.camel@marge.simpson.net>
Subject: Re: [PATCH] sched: update_rq_clock() must skip ONE update
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 31 Mar 2014 20:27:06 +0200
In-Reply-To: <CA+55aFywHpvUfghS4GFc3UC1WGZx3Of+zeKHxmRNcMQMoKoiJQ@mail.gmail.com>
References: <1396164244.28950.15.camel@marge.simpson.net>
	 <CA+55aFzGVLTiD5QVqZ6YK41b9n0SUxDGD3+yE9CuGJek2U-+MQ@mail.gmail.com>
	 <1396239636.5361.57.camel@marge.simpson.net>
	 <CA+55aFywHpvUfghS4GFc3UC1WGZx3Of+zeKHxmRNcMQMoKoiJQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-31 at 09:13 -0700, Linus Torvalds wrote: 
> On Sun, Mar 30, 2014 at 9:20 PM, Mike Galbraith
> <umgwanakikbuti@gmail.com> wrote:
> >
> > Point of being verbose was to make sure it was clear exactly how this
> > harmless little bug selectively kills large IO boxen..
> 
> My point is that if you want it to be applied hours before I make a
> release, I need to be made aware of how critical it is.

Oh, I didn't cc you because I wanted it applied instantly as ultra
critical, only because the chain of events might be of interest.

It takes a lot of cycles to add up to NMI.  Those cycles exist with or
without the throttle being fooled into picking on watchdog.  How bad can
wakeup latency get with modprobe mptsas?  So bad that you don't even
need this little bug to _further_ incapacitate the watchdog?  Can the
wakeup latency do the job all by itself?  It's wakeup latency that is
being improperly attributed to watchdog in the trace data.

(then there's "is watchdog being subject to throttle a good idea")

> The data/commentary in the commit message made *zero* sense to me in
> that regards. It was just noise.

One of my sisters says I speak Martian, she may be right.  Looks clear
to me, but then I did the tracing, condensed the output and hastily
wrote the apparently useless words.. perhaps a tad too hastily.

I haven't yet received confirmation that this is the fix, so there may
be more to it, this only a part.  A huge interrupt hit at the right time
and no irq accounting enabled could properly trigger the throttle.. but
it'd be difficult to reliably hit such thin targets on multiple CPUs.

-Mike

