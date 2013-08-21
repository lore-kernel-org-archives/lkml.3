Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab3HUSi4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 14:38:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810Ab3HUSiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 14:38:55 -0400
Date: Wed, 21 Aug 2013 20:32:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando_b1@lab.ntt.co.jp>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] nohz: Synchronize sleep time stats with seqlock
Message-ID: <20130821183227.GA20050@redhat.com>
References: <52138BE9.5090005@linux.intel.com> <20130820160146.GG3258@twins.programming.kicks-ass.net> <20130820163312.GA17957@redhat.com> <20130820175429.GI3258@twins.programming.kicks-ass.net> <20130820182553.GB22287@redhat.com> <20130821083130.GM3258@twins.programming.kicks-ass.net> <20130821113551.GA1472@redhat.com> <20130821124849.GB31370@twins.programming.kicks-ass.net> <20130821170927.GA15838@redhat.com> <20130821183157.GE31370@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130821183157.GE31370@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21, Peter Zijlstra wrote:
>
> OK, so do not remove the MAX_SCHEDULE_TIMEOUT check from
> __schedule_timeout() and change the above to:
>
> static __always_inline long schedule_timeout(long timeout)
> {
> 	if (__builtin_constant_p(timeout) && timeout == MAX_SCHEDULE_TIMEOUT) {
> 		schedule();
> 		return timeout;
> 	}
> 	return __schedule_timeout(timeout);
> }

Agreed, this looks nice.

Hmm. And this can simplify some changes in linux/wait.h I am going
to resend.

Oleg.

