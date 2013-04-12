Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab3DLIr0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 04:47:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:20733 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695Ab3DLIrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 04:47:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,461,1363158000"; 
   d="scan'208";a="226352262"
Message-ID: <5167C9FA.8050406@intel.com>
Date: Fri, 12 Apr 2013 16:46:50 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        len.brown@intel.com, rafael.j.wysocki@intel.com, jkosina@suse.cz,
        clark.williams@gmail.com, tony.luck@intel.com, keescook@chromium.org,
        mgorman@suse.de, riel@redhat.com,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [patch v7 0/21] sched: power aware scheduling
References: <1365040862-8390-1-git-send-email-alex.shi@intel.com> <516724F5.20504@kernel.org>
In-Reply-To: <516724F5.20504@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2013 05:02 AM, Len Brown wrote:
>> > x = 16   299.915 /43 77           259.127 /58 66
> Are you sure that powersave mode ran in 43 seconds
> when performance mode ran in 58 seconds?

Thanks a lot for comments, Len!
Will do more testing by your tool fspin. :)

powersaving using less time when thread = 16 or 32.
The main contribution come from CPU freq boost. I have disable the boost
of cpufreq. then find the compile time become similar between
powersaving and performance on thread 32, and powersaving is slower when
threads is 16.
And less Context Switch from less lazy power balance should also do some
help.
> 
> If that is true, than somewhere in this patch series
> you have a _significant_ performance benefit
> on this workload under these conditions!
> 
> Interestingly, powersave mode also ran at
> 15% higher power than performance mode.
> maybe "powersave" isn't quite the right name for it:-)

What other name you suggest? :)
> 
>> > x = 32   341.221 /35 83           323.418 /38 81
> Why does this patch series have a performance impact (8%)
> at x=32.  All the processors are always busy, no?

No, all processors are not always busy in 'make -j vmlinux'
So, compile time also get benefit from boost and less CS. the
performance policy doesn't introduce any impact. there is nothing added
in performance policy.
> 
>> > data explains: 189.416 /228 23
>> > 	189.416: average Watts during compilation
>> > 	228: seconds(compile time)
>> > 	23:  scaled performance/watts = 1000000 / seconds / watts
>> > The performance value of kbuild is better on threads 16/32, that's due
>> > to lazy power balance reduced the context switch and CPU has more boost 
>> > chance on powersaving balance.
> 25% is a huge difference in performance.
> Can you get a performance benefit in that scenario
> without having a negative performance impact
> in the other scenarios?  In particular,

will try packing task on cpu capacity not cpu weight.
> an 8% hit to the fully utilized case is a deal killer.

that is the 8% gain on powersaving, not 8% lose on performance policy. :)
> 
> The x=16 performance change here suggest there is value
> someplace in this patch series to increase performance.
> However, the case that these scheduling changes are
> a benefit from an energy efficiency point of view
> is yet to be made.


-- 
Thanks Alex
