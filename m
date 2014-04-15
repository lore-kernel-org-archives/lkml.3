Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbaDOLO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 07:14:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54537 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925AbaDOLOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 07:14:25 -0400
Date: Tue, 15 Apr 2014 13:14:10 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 2/2] nohz: Synchronize sleep time stats with memory
 barriers
Message-ID: <20140415111410.GN13658@twins.programming.kicks-ass.net>
References: <1396469872-14877-1-git-send-email-dvlasenk@redhat.com>
 <1396469872-14877-2-git-send-email-dvlasenk@redhat.com>
 <20140415105138.GO11096@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140415105138.GO11096@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 12:51:38PM +0200, Peter Zijlstra wrote:
> That said; I thing the fundamental flaw in the entire thing is
> accounting the entire nohz idle period as one type, since the period is
> basically unbounded.

So basically anything with the current per-cpu nr_iowait is bound to
yield crack induced results.

Like you said in your other email, we need to somehow intersect actual
idle time with the presence of iowait tasks. Now that's a global problem
and is unlikely to scale well. Which is of course why we have this
problem to begin with, if it were easy it'd be done right to begin with
(optimistic world view here).


