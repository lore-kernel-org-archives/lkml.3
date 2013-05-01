Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab3EATNt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 15:13:49 -0400
Received: from one.firstfloor.org ([193.170.194.197]:60992 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349Ab3EATNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 15:13:43 -0400
Date: Wed, 1 May 2013 21:13:42 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
        "mingo@elte.hu" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf, x86: Add workaround for MEM_*_RETIRED errata BV98
Message-ID: <20130501191342.GH17814@two.firstfloor.org>
References: <1367261108-9567-1-git-send-email-andi@firstfloor.org>
 <20130501090718.GA28253@dyad.programming.kicks-ass.net>
 <m261z3uipb.fsf@firstfloor.org>
 <20130501111219.GF28253@dyad.programming.kicks-ass.net>
 <CABPqkBT-VdWQ0c5AASDfQLssBRSfbtoH0-L1eHMXONqe5d_YRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBT-VdWQ0c5AASDfQLssBRSfbtoH0-L1eHMXONqe5d_YRw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Unfortunately, Andi's patch fails to correct the problem though
> it is the right approach. As he said, the problem is unfortunately

perf stat -a / record -a / top will work.

The case it doesn't fix is per thread when the other sibling
is not running a counter.

Essentially with the patch you may still get under-counting
on these specific events if they run per thread (or are really
unlucky in multiplexing), but never over-counting on anything.

In the past Ingo's guidance was to focus on the most common 
use cases, which I think this patch does.

It would be possible to fix the per thread mode too, but it would
need quite a bit of new infrastructure and I have doubts that's 
worth it.

-Andi
