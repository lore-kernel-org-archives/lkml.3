Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab3EPH3j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 03:29:39 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:47907 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062Ab3EPH3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 03:29:38 -0400
Message-ID: <51948AD4.3020104@linux.vnet.ibm.com>
Date: Thu, 16 May 2013 15:29:24 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org, mgorman@suse.de,
        riel@redhat.com
Subject: Re: [patch 0/8]: use runnable load avg in balance
References: <1368199049-2798-1-git-send-email-alex.shi@intel.com>
In-Reply-To: <1368199049-2798-1-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051607-4790-0000-0000-00000854E8C9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2013 11:17 PM, Alex Shi wrote:
> This patchset bases on tip/sched/core.
> 
> This version changed the runnable load avg value setting for new task
> in patch 3rd.
> 
> We also tried to include blocked load avg in balance. but find many benchmark
> performance dropping. Guess the too bigger cpu load drive task to be waken
> on remote CPU, and cause wrong decision in periodic balance.
> 
> I retested on Intel core2, NHM, SNB, IVB, 2 and 4 sockets machines with
> benchmark kbuild, aim7, dbench, tbench, hackbench, oltp, and netperf loopback
> etc. The performance is better now. 
> 
> On SNB EP 4 sockets machine, the hackbench increased about 50%, and result
> become stable. on other machines, hackbench increased about 2~10%.
> oltp increased about 30% in NHM EX box.
> netperf loopback also increased on SNB EP 4 sockets box.
> no clear changes on other benchmarks.
> 
> Michael Wang had tested previous version on pgbench on his box:
> https://lkml.org/lkml/2013/4/2/1022

Tested the latest patch set (new 3/8 and 6/8) with pgbench, tip
3.10.0-rc1 and 12 cpu X86 box, works well and still benefit ;-)

Regards,
Michael Wang

> 
> And Morten tested previous version too.
> http://comments.gmane.org/gmane.linux.kernel/1463371
> 
> Thanks comments from Peter, Paul, Morten, Miacheal and Preeti.
> And more comments are appreciated!
> 
> Regards
> Alex
> 
> [patch v6 1/8] Revert "sched: Introduce temporary FAIR_GROUP_SCHED
> [patch v6 2/8] sched: move few runnable tg variables into CONFIG_SMP
> [patch v6 3/8] sched: set initial value of runnable avg for new
> [patch v6 4/8] sched: fix slept time double counting in enqueue
> [patch v6 5/8] sched: update cpu load after task_tick.
> [patch v6 6/8] sched: compute runnable load avg in cpu_load and
> [patch v6 7/8] sched: consider runnable load average in move_tasks
> [patch v6 8/8] sched: remove blocked_load_avg in tg
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

