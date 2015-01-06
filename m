Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbbAFNDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 08:03:35 -0500
Received: from casper.infradead.org ([85.118.1.10]:54060 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856AbbAFNDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 08:03:34 -0500
Date: Tue, 6 Jan 2015 14:03:17 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>, Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Chris Mason <clm@fb.com>
Subject: Re: Linux 3.19-rc3
Message-ID: <20150106130317.GX29390@twins.programming.kicks-ass.net>
References: <CA+icZUUcgP=nUPCOfEJrbO9OAAPLgQd8RWO-BJe+W0wi3fWiOw@mail.gmail.com>
 <CA+icZUUThdtXkRztRxk+zEqvMwUmEQeSoR3WD3qqXW9QspBoVw@mail.gmail.com>
 <20150106100621.GL29390@twins.programming.kicks-ass.net>
 <CA+icZUVy2rG3PwKhPTQojLEH2O8FD-0myO2sN8hQV4_+r9YNQQ@mail.gmail.com>
 <20150106110112.GQ29390@twins.programming.kicks-ass.net>
 <20150106110730.GA25846@kmo-pixel>
 <20150106114215.GS29390@twins.programming.kicks-ass.net>
 <20150106115645.GA26845@kmo-pixel>
 <20150106121603.GV29390@twins.programming.kicks-ass.net>
 <20150106124313.GD26845@kmo-pixel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150106124313.GD26845@kmo-pixel>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 04:43:13AM -0800, Kent Overstreet wrote:
> It might make the most sense to cook up something new, stealing some of the
> closure code but using standard the wait_queue_head_t - having a single standard
> waitlist type is definitely a good thing, and unfortunately I don't think it'd
> be a good idea to convert closures to wait_queue_head_t mainly because of the
> memory usage.
> 
> I will note that one thing that has been immensely useful with closures is the
> ability to pass a closure around - think of it as a "wait object" - to some code
> that may end up waiting on something, but you don't want to itself sleep, and
> then the caller can closure_sync() or continue_at() or whatever it wants (or use
> the same closure for waiting on multiple things, e.g. where we wait on writing
> the two new btree nodes after a split).
> 
> Think of it a souped up completion.

Yeah I got that aspect. I'm still trying to get my head around how the
wait_event bit would be a natural match though ;-)

Let me stew a bit on that.

That said, the RT people want a simple waitqueue, one that has
deterministic behaviour. This is only possibly by removing some of the
more obscure waitqueue features and thus also results in a slimmer
structure.

