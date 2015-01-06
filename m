Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbbAFLmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 06:42:32 -0500
Received: from casper.infradead.org ([85.118.1.10]:53654 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881AbbAFLmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 06:42:31 -0500
Date: Tue, 6 Jan 2015 12:42:15 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>, Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Chris Mason <clm@fb.com>
Subject: Re: Linux 3.19-rc3
Message-ID: <20150106114215.GS29390@twins.programming.kicks-ass.net>
References: <CA+icZUU4ALYvEq7SkUewnZytf62R0d9x+MVPvMrR0zzFf+-f3Q@mail.gmail.com>
 <20150106094039.GI29390@twins.programming.kicks-ass.net>
 <CA+icZUUcgP=nUPCOfEJrbO9OAAPLgQd8RWO-BJe+W0wi3fWiOw@mail.gmail.com>
 <CA+icZUUThdtXkRztRxk+zEqvMwUmEQeSoR3WD3qqXW9QspBoVw@mail.gmail.com>
 <20150106100621.GL29390@twins.programming.kicks-ass.net>
 <CA+icZUVy2rG3PwKhPTQojLEH2O8FD-0myO2sN8hQV4_+r9YNQQ@mail.gmail.com>
 <20150106110112.GQ29390@twins.programming.kicks-ass.net>
 <20150106110730.GA25846@kmo-pixel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150106110730.GA25846@kmo-pixel>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 03:07:30AM -0800, Kent Overstreet wrote:
> > No, the root cause is nesting sleep primitives, this is not fixable in
> > the one place, both prepare_to_wait and mutex_lock are using
> > task_struct::state, they have to, no way around it.
> 
> No, it's completely possible to construct a prepare_to_wait() that doesn't
> require messing with the task state. Had it for years.
> 
> http://evilpiepirate.org/git/linux-bcache.git/log/?h=aio_ring_fix

Your closures are cute but not the same. And sure you can do a wait
queue like interface -- my wait_woken thing is an example -- that
doesn't require task state.

The point remains that you then have to fix every instance to conform to
the new interface.

