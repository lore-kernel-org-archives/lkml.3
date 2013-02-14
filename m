Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614Ab3BNDKd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 22:10:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:48587 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753935Ab3BNDK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 22:10:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,660,1355126400"; 
   d="scan'208";a="285500482"
Message-ID: <511C559F.4090800@intel.com>
Date: Thu, 14 Feb 2013 11:10:23 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: torvalds@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v4 11/18] sched: log the cpu utilization at rq
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>  <1358996820-23036-12-git-send-email-alex.shi@intel.com> <1360665592.4485.26.camel@laptop>
In-Reply-To: <1360665592.4485.26.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2013 06:39 PM, Peter Zijlstra wrote:
> On Thu, 2013-01-24 at 11:06 +0800, Alex Shi wrote:
>>
>> The cpu's utilization is to measure how busy is the cpu.
>>         util = cpu_rq(cpu)->avg.runnable_avg_sum
>>                 / cpu_rq(cpu)->avg.runnable_avg_period;
>>
>> Since the util is no more than 1, we use its percentage value in later
>> caculations. And set the the FULL_UTIL as 100%.
>>
>> In later power aware scheduling, we are sensitive for how busy of the
>> cpu, not how much weight of its load. As to power consuming, it is more
>> related with cpu busy time, not the load weight.
> 
> I think we can make that argument in general; that is irrespective of
> the actual policy. We simply never had anything better to go with.
> 
> So please clarify why you think this only applies to power aware
> scheduling.

Um, the rq->util is a general argument. It can be used on any other
places if needed, not power aware scheduling specific.
> 


-- 
Thanks
    Alex
