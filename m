Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489Ab3EBAjO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 20:39:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:52779 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757311Ab3EBAjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 20:39:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,592,1363158000"; 
   d="scan'208";a="235602074"
Message-ID: <5181B579.9000808@intel.com>
Date: Thu, 02 May 2013 08:38:17 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, len.brown@intel.com,
        rafael.j.wysocki@intel.com, jkosina@suse.cz, clark.williams@gmail.com,
        tony.luck@intel.com, keescook@chromium.org, mgorman@suse.de,
        riel@redhat.com
Subject: Re: [PATCH v4 0/6] sched: use runnable load based balance
References: <1367040344-14485-1-git-send-email-alex.shi@intel.com> <20130501121421.GA19602@dyad.programming.kicks-ass.net>
In-Reply-To: <20130501121421.GA19602@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2013 08:14 PM, Peter Zijlstra wrote:
> On Sat, Apr 27, 2013 at 01:25:38PM +0800, Alex Shi wrote:
>> This patchset bases on tip/sched/core.
>>
>> The patchset remove the burst wakeup detection which had worked fine on 3.8
> 
> Was this part of the original series from PJT or some patches afterwards?
> I missed a few months worth of patches so any extra information to help me
> catch up is greatly appreciated :-)

On 3.8 kernel, the first problem commit is 5a505085f043 ("mm/rmap:
Convert the struct anon_vma::mutex to an rwsem"), It cause much
imbalance among cpus on aim7 benchmark. The reason is here,
https://lkml.org/lkml/2013/1/29/84.

With PJT's patch, we know in first few seconds from wakeup, task's
runnable load maybe nearly zero. The nearly zero runnable load increases
the imbalance among cpus. So there are about extra 5% performance drop
when use runnable load to do balance on aim7(in testing, aim7 will fork
2000 threads, and then wait for a trigger, then run as fast as possible).

But, after we use rwsem lock stealing in 3.9 kernel, commit
ce6711f3d196f09ca0e, aim7 wakeup won't has clear imbalance issue. And
then aim7 won't need this extra burst wakeup detection.
> 
>> kernel, since the aim7 is very imbalance. But rwsem write lock stealing 
>> enabled in 3.9 kernel. aim7 imbalance disappeared. So the burst wakeup
>> care doesn't needed. 
> 
> How does this follow.. surely something else can cause burst wakeups just fine
> too?
> 
>> Peter, 
>> Would you like to consider pick up the patchset? or give some comments? :)
> 
> I'll go read them.. :-)
> 

I appreciate for this. :)

-- 
Thanks Alex
