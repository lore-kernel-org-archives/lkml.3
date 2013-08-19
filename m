Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317Ab3HSLQJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 07:16:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57289 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab3HSLQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 07:16:08 -0400
Date: Mon, 19 Aug 2013 13:15:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 2/4] nohz: Synchronize sleep time stats with seqlock
Message-ID: <20130819111556.GF24092@twins.programming.kicks-ass.net>
References: <1376667753-29014-1-git-send-email-fweisbec@gmail.com>
 <1376667753-29014-3-git-send-email-fweisbec@gmail.com>
 <20130816160201.GA31682@redhat.com>
 <20130816162056.GE24210@somewhere>
 <20130816162654.GA453@redhat.com>
 <20130816164626.GH24210@somewhere>
 <20130819111026.GE24092@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130819111026.GE24092@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 01:10:26PM +0200, Peter Zijlstra wrote:
> So no, if we need per-cpu iowait time we have to do A.
> 
> Since we already have atomics in the io_schedule*() paths, please
> replace those with (seq)locks. Also see if you can place the entire
> iowait accounting thing in a separate cacheline.

Also, it completely blows to have these extra atomics in the IO paths,
I'm sure that the Mega-IOP/s people would be much pleased if we could
remove these.


