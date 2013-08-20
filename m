Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746Ab3HTPcB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 11:32:01 -0400
Received: from mga14.intel.com ([143.182.124.37]:47447 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732Ab3HTPcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 11:32:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,921,1367996400"; 
   d="scan'208";a="349048782"
Message-ID: <52138BE9.5090005@linux.intel.com>
Date: Tue, 20 Aug 2013 08:31:53 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando_b1@lab.ntt.co.jp>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] nohz: Synchronize sleep time stats with seqlock
References: <1376667753-29014-1-git-send-email-fweisbec@gmail.com> <1376667753-29014-3-git-send-email-fweisbec@gmail.com> <20130816160201.GA31682@redhat.com> <20130816162056.GE24210@somewhere> <20130816162654.GA453@redhat.com> <20130816164626.GH24210@somewhere> <20130819111026.GE24092@twins.programming.kicks-ass.net> <521313D8.9080500@lab.ntt.co.jp> <20130820084405.GC3258@twins.programming.kicks-ass.net>
In-Reply-To: <20130820084405.GC3258@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/20/2013 1:44 AM, Peter Zijlstra wrote:
> On Tue, Aug 20, 2013 at 03:59:36PM +0900, Fernando Luis Vázquez Cao wrote:
>> That said, if deemed acceptable, option A is the one I would
>> choose.
>
> Right, so I think we can do A without much extra cost mostly because we
> already have 2 atomics in the io_schedule() path. If we replace those
> two atomic operations with locks and modify nr_iowait and the other
> stats under the same lock, and ensure all those variables (including the
> lock) live in the same cacheline we should have the same cost we have
> now.
>
> Of course, if we can get away with completely removing all of that
> (which I think Arjan suggested was a real possibility) then that would
> be ever so much better still :-)

I'm quite ok with removing that.

however note that "top" also reports per cpu iowait...
and that's a userspace expectation

>

