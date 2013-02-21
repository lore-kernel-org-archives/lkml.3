Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab3BUOkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 09:40:14 -0500
Received: from mga01.intel.com ([192.55.52.88]:25036 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046Ab3BUOkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 09:40:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,709,1355126400"; 
   d="scan'208";a="290134911"
Message-ID: <512631C7.8060103@intel.com>
Date: Thu, 21 Feb 2013 22:40:07 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: torvalds@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, morten.rasmussen@arm.com
Subject: Re: [patch v5 09/15] sched: add power aware scheduling in fork/exec/wake
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com>    <1361164062-20111-10-git-send-email-alex.shi@intel.com>   <1361353360.10155.9.camel@laptop> <5124BCEB.8030606@intel.com>  <1361367371.10155.32.camel@laptop> <5124DC76.2010801@intel.com> <1361453587.26780.18.camel@laptop>
In-Reply-To: <1361453587.26780.18.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2013 09:33 PM, Peter Zijlstra wrote:
> On Wed, 2013-02-20 at 22:23 +0800, Alex Shi wrote:
>>> But but but,... nr_running is completely unrelated to utilization.
>>>
>>
>> Actually, I also hesitated on the name, how about using nr_running to
>> replace group_util directly?
> 
> 
> The name is a secondary issue, first you need to explain why you think
> nr_running is a useful metric at all.
> 
> You can have a high nr_running and a low utilization (a burst of
> wakeups, each waking a process that'll instantly go to sleep again), or
> low nr_running and high utilization (a single process cpu bound
> process).

It is true in periodic balance. But in fork/exec/waking timing, the
incoming processes usually need to do something before sleep again.

I use nr_running to measure how the group busy, due to 3 reasons:
1, the current performance policy doesn't use utilization too.
2, the power policy don't care load weight.
3, I tested some benchmarks, kbuild/tbench/hackbench/aim7 etc, some
benchmark results looks clear bad when use utilization. if my memory
right, the hackbench/aim7 both looks bad. I had tried many ways to
engage utilization into this balance, like use utilization only, or use
utilization * nr_running etc. but still can not find a way to recover
the lose. But with nr_running, the performance seems doesn't lose much
with power policy.

> 
> There is absolutely no relation between utilization and nr_running,
> building something on that assumption is just wrong and broken.

I just had tried all my benchmarks dbench/loop netperf/specjbb/sysbench
etc seems the performance/power testing result are all acceptable.

> 
> 
> 


-- 
Thanks
    Alex
