Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758801AbaDKPbJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 11:31:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40948 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755577AbaDKPbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 11:31:07 -0400
Date: Fri, 11 Apr 2014 17:30:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: mingo@kernel.org, tglx@linutronix.de, luto@amacapital.net,
        nicolas.pitre@linaro.org, daniel.lezcano@linaro.org,
        umgwanakikbuti@gmail.com, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH 2/8] sched,idle,tile: Switch from TS_POLLING to
 TIF_POLLING_NRFLAG
Message-ID: <20140411153059.GY11096@twins.programming.kicks-ass.net>
References: <20140411134243.160989490@infradead.org>
 <20140411135218.242750053@infradead.org>
 <53480702.3080100@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53480702.3080100@tilera.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 11:15:14AM -0400, Chris Metcalf wrote:
> It's unfortunate that you're rolling the fetch_or() unconditionally
> out of cmpxchg(), since some architectures (like tilegx) do have
> support for "fetchor" as a primitive atomic operation.  Currently the
> tilegx fetchor is only exposed to architecture-independent code via
> set_bit() and test_and_set_bit(), but perhaps it's worth having an
> atomic_or() in atomic.h so architectures can choose to optimize it?

Yeah, I know.. Linus hated atomic_or_return() -- which admittedly is a
little worse than fetch_or, because the operation isn't reversible.

Note that atomic_or_return() or rather, atomic_return_or() won't
actually work here because thread_info::flags is not a fixed typed
between archs, some have int, some have long.

Then again, when I proposed that thing, I didn't have a usage for it.
Still, Linus' main argument still holds, its a crappy primitive on x86
and one should not encourage its use by pretending its 'easy'.


