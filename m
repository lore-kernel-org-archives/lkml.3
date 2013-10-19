Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab3JSQUS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 12:20:18 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:60131 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab3JSQUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 12:20:16 -0400
Date: Sat, 19 Oct 2013 18:20:12 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 4/5] sched: Refactor iowait accounting
Message-ID: <20131019162011.GB13534@localhost.localdomain>
References: <1382195841-6558-1-git-send-email-fweisbec@gmail.com>
 <1382195841-6558-5-git-send-email-fweisbec@gmail.com>
 <20131019153535.GA2490@laptop.programming.kicks-ass.net>
 <20131019160235.GA13534@localhost.localdomain>
 <20131019160517.GB2490@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131019160517.GB2490@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 19, 2013 at 06:05:17PM +0200, Peter Zijlstra wrote:
> On Sat, Oct 19, 2013 at 06:02:37PM +0200, Frederic Weisbecker wrote:
> > > I just had a look at delayacct; wth wrote that crap; that too uses
> > > gtod.
> > 
> > I can't find where it does that. kernel/delayacct.c doesn't seem to at least.
> 
> Look for do_posix_clock_monotonic_gettime() ;-)

Oh. Well that's a good news, it appears to be a nice low hanging fruit :)

Also perhaps we could make it use the same timestamp as cpu_iowait_start/end.
