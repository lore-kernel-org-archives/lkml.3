Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751050Ab3HSPsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 11:48:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:17910 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996Ab3HSPsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 11:48:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,913,1367996400"; 
   d="scan'208";a="364961365"
Message-ID: <52123E1F.9030204@linux.intel.com>
Date: Mon, 19 Aug 2013 08:47:43 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] nohz: Synchronize sleep time stats with seqlock
References: <1376667753-29014-1-git-send-email-fweisbec@gmail.com> <1376667753-29014-3-git-send-email-fweisbec@gmail.com> <20130816160201.GA31682@redhat.com> <20130816162056.GE24210@somewhere> <20130816162654.GA453@redhat.com> <20130816164626.GH24210@somewhere> <20130816164922.GA1573@redhat.com> <20130816171208.GJ24210@somewhere> <20130819105817.GD24092@twins.programming.kicks-ass.net>
In-Reply-To: <20130819105817.GD24092@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/19/2013 3:58 AM, Peter Zijlstra wrote:
> On Fri, Aug 16, 2013 at 07:12:09PM +0200, Frederic Weisbecker wrote:
>> Or may be Peter could tell us as well. Peter, do you have a preference?
>
> Still trying to wrap my head around it, but conceptually
> get_cpu_iowait_time_us() doesn't make any kind of sense. iowait isn't
> per cpu since effectively tasks that aren't running aren't assigned a
> cpu (as Oleg already pointed out).
>
> The fact that cpufreq 'needs' this just means that cpufreq is broken --
> but I think I've said as much previously; cpufreq needs to stop living
> in the partitioned-mp era and get dragged (kicking and screaming) into
> the smp era.
>
> I'm also not entirely clear on the 'desired' semantics here. Do we count
> iowait time as idle or not?

fwiw only some Intel cpu's use this, and those by and large no longer use cpufreq
so this can just go away as far as I am concerned.

