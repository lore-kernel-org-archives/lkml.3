Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbbAFN0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 08:26:14 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:61748 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbbAFN0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 08:26:12 -0500
Date: Tue, 6 Jan 2015 05:28:44 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sedat Dilek <sedat.dilek@gmail.com>, Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Chris Mason <clm@fb.com>
Subject: Re: Linux 3.19-rc3
Message-ID: <20150106132844.GF26845@kmo-pixel>
References: <CA+icZUUThdtXkRztRxk+zEqvMwUmEQeSoR3WD3qqXW9QspBoVw@mail.gmail.com>
 <20150106100621.GL29390@twins.programming.kicks-ass.net>
 <CA+icZUVy2rG3PwKhPTQojLEH2O8FD-0myO2sN8hQV4_+r9YNQQ@mail.gmail.com>
 <20150106110112.GQ29390@twins.programming.kicks-ass.net>
 <20150106110730.GA25846@kmo-pixel>
 <20150106114215.GS29390@twins.programming.kicks-ass.net>
 <20150106115645.GA26845@kmo-pixel>
 <20150106121603.GV29390@twins.programming.kicks-ass.net>
 <20150106124313.GD26845@kmo-pixel>
 <20150106130317.GX29390@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150106130317.GX29390@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 02:03:17PM +0100, Peter Zijlstra wrote:
> Yeah I got that aspect. I'm still trying to get my head around how the
> wait_event bit would be a natural match though ;-)
> 
> Let me stew a bit on that.

Also, I think it was kind of a surprise to me back in the day how structurally
similar the wait_event() implementation (circa several years ago, not the
monstrosity it is now :) and closure_wait_event() turned out - I wasn't aiming
for that, but that got me thinking there must be something more fundamental
going on here.

Probably rambling at this point though.

> That said, the RT people want a simple waitqueue, one that has
> deterministic behaviour. This is only possibly by removing some of the
> more obscure waitqueue features and thus also results in a slimmer
> structure.

Oh really? That's good to hear.

I do like wake_all() being cheaper with the singly linked list, wakups are much
more common than waiting on things (e.g. the aio code delivering events to the
ringbuffer, anything that's freeing up resources).

Been kind of wondering how sane it would be to implement
finish_wait()/wake_one() with a singly linked list, and maybe preserve some of
the locklessness. You do fancy lockless stuff too, don't you? Maybe you have
some ideas :)
