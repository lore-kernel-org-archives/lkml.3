Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab3JBOf4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:35:56 -0400
Received: from mga14.intel.com ([143.182.124.37]:61523 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753102Ab3JBOfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:35:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1019,1371106800"; 
   d="scan'208";a="302230679"
Message-ID: <524C2F45.4040401@linux.intel.com>
Date: Wed, 02 Oct 2013 07:35:49 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando_b1@lab.ntt.co.jp>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] nohz: Synchronize sleep time stats with seqlock
References: <20130820182553.GB22287@redhat.com> <20130821083130.GM3258@twins.programming.kicks-ass.net> <20130821113551.GA1472@redhat.com> <20130821123311.GA31370@twins.programming.kicks-ass.net> <20130821142356.GC31370@twins.programming.kicks-ass.net> <20130821164146.GA15194@redhat.com> <20131001140525.GE24825@localhost.localdomain> <20131001155633.GR3657@laptop.programming.kicks-ass.net> <20131001164708.GG24825@localhost.localdomain> <20131001165957.GT3657@laptop.programming.kicks-ass.net> <20131002124539.GF7941@localhost.localdomain>
In-Reply-To: <20131002124539.GF7941@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/2/2013 5:45 AM, Frederic Weisbecker wrote:
> On Tue, Oct 01, 2013 at 06:59:57PM +0200, Peter Zijlstra wrote:
>> On Tue, Oct 01, 2013 at 06:47:10PM +0200, Frederic Weisbecker wrote:
>>> Yeah thinking more about it, the preempt disable was probably not
>>> necessary. Now that's trading 2 atomics + 1 Lock/Unlock with 2 Lock/Unlock.
>>
>> It trades the current 2 atomics for 2 LOCK/UNLOCK. And on x86_64 that's
>> 2 atomics.
>
> Do you mean 2 atomics for LOCK/UNLOCK? Or is that pair optimized somehow
> in x86?

unlock is not actually an atomic.

and on some modern machines, neither is the lock, for the uncontended case ;-)

