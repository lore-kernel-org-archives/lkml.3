Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669Ab3HUMdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 08:33:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55985 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab3HUMdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 08:33:24 -0400
Date: Wed, 21 Aug 2013 14:33:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando_b1@lab.ntt.co.jp>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] nohz: Synchronize sleep time stats with seqlock
Message-ID: <20130821123311.GA31370@twins.programming.kicks-ass.net>
References: <20130819111026.GE24092@twins.programming.kicks-ass.net>
 <521313D8.9080500@lab.ntt.co.jp>
 <20130820084405.GC3258@twins.programming.kicks-ass.net>
 <52138BE9.5090005@linux.intel.com>
 <20130820160146.GG3258@twins.programming.kicks-ass.net>
 <20130820163312.GA17957@redhat.com>
 <20130820175429.GI3258@twins.programming.kicks-ass.net>
 <20130820182553.GB22287@redhat.com>
 <20130821083130.GM3258@twins.programming.kicks-ass.net>
 <20130821113551.GA1472@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130821113551.GA1472@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 01:35:51PM +0200, Oleg Nesterov wrote:
> On 08/21, Peter Zijlstra wrote:

> > Yes its the right rq, but the wrong time.
> 
> Hmm. Just in case, it is not that I think this patch really makes sense,
> but I'd like to understand why do you think it is wrong.
 
> But it is not "after it switches out", it is after it switched back.

D'uh I was being particularly dense it seems :/

Yes I think it is correct. You're now trading two atomic ops on a
different cacheline than rq->lock for one atomic op on the rq->lock.

Might be a win, esp. since hopefully there's a fair chance its the same
runqueue.


