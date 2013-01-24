Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab3AXPH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 10:07:56 -0500
Received: from mga03.intel.com ([143.182.124.21]:63589 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220Ab3AXPHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 10:07:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,530,1355126400"; 
   d="scan'208";a="194724367"
Message-ID: <51014E34.60309@intel.com>
Date: Thu, 24 Jan 2013 23:07:32 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, torvalds@linux-foundation.org,
        mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v4 0/18] sched: simplified fork, release load avg and
 power awareness scheduling
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com> <20130124094439.GB13463@pd.tnic>
In-Reply-To: <20130124094439.GB13463@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2013 05:44 PM, Borislav Petkov wrote:
> On Thu, Jan 24, 2013 at 11:06:42AM +0800, Alex Shi wrote:
>> Since the runnable info needs 345ms to accumulate, balancing
>> doesn't do well for many tasks burst waking. After talking with Mike
>> Galbraith, we are agree to just use runnable avg in power friendly 
>> scheduling and keep current instant load in performance scheduling for 
>> low latency.
>>
>> So the biggest change in this version is removing runnable load avg in
>> balance and just using runnable data in power balance.
>>
>> The patchset bases on Linus' tree, includes 3 parts,
>> ** 1, bug fix and fork/wake balancing clean up. patch 1~5,
>> ----------------------
>> the first patch remove one domain level. patch 2~5 simplified fork/wake
>> balancing, it can increase 10+% hackbench performance on our 4 sockets
>> SNB EP machine.
> 
> Ok, I see some benchmarking results here and there in the commit
> messages but since this is touching the scheduler, you probably would
> need to make sure it doesn't introduce performance regressions vs
> mainline with a comprehensive set of benchmarks.
> 

Thanks a lot for your comments, Borislav! :)

For this patchset, the code will just check current policy, if it is
performance, the code patch will back to original performance code at
once. So there should no performance change on performance policy.

I once tested the balance policy performance with benchmark
kbuild/hackbench/aim9/dbench/tbench on version 2, only hackbench has a
bit drop ~3%. others have no clear change.

> And, AFAICR, mainline does by default the 'performance' scheme by
> spreading out tasks to idle cores, so have you tried comparing vanilla
> mainline to your patchset in the 'performance' setting so that you can
> make sure there are no problems there? And not only hackbench or a
> microbenchmark but aim9 (I saw that in a commit message somewhere) and
> whatever else multithreaded benchmark you can get your hands on.
> 
> Also, you might want to run it on other machines too, not only SNB :-)

Anyway I will redo the performance testing on this version again on all
machine. but doesn't expect something change. :)

> And what about ARM, maybe someone there can run your patchset too?
> 
> So, it would be cool to see comprehensive results from all those runs
> and see what the numbers say.
> 
> Thanks.
> 


-- 
Thanks
    Alex
