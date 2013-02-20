Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935171Ab3BTMj2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 07:39:28 -0500
Received: from mga09.intel.com ([134.134.136.24]:20096 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933751Ab3BTMj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 07:39:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,701,1355126400"; 
   d="scan'208";a="288197078"
Message-ID: <5124C3F8.70901@intel.com>
Date: Wed, 20 Feb 2013 20:39:20 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
CC: torvalds@linux-foundation.org, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        morten.rasmussen@arm.com
Subject: Re: [patch v5 06/15] sched: log the cpu utilization at rq
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com> <1361164062-20111-7-git-send-email-alex.shi@intel.com> <5124BF47.7070500@linux.vnet.ibm.com>
In-Reply-To: <5124BF47.7070500@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 08:19 PM, Preeti U Murthy wrote:
> Hi everyone,
> 
> On 02/18/2013 10:37 AM, Alex Shi wrote:
>> The cpu's utilization is to measure how busy is the cpu.
>>         util = cpu_rq(cpu)->avg.runnable_avg_sum
>>                 / cpu_rq(cpu)->avg.runnable_avg_period;
> 
> Why not cfs_rq->runnable_load_avg? I am concerned with what is the right
> metric to use here.

Here we care the utilization of the cpu not the load avg. load avg maybe
quit bigger on a heavy task(with a big load weight), but maybe it just
used 20% of cpu time, while a light task with 100% cpu usage maybe still
has smaller load avg.

For power consideration, above light task with 100% usage need to take a
cpu, while another heavy task can packing into one cpu with other tasks.


> Refer to this discussion:https://lkml.org/lkml/2012/10/29/448
> 
> Regards
> Preeti U Murthy
> 


-- 
Thanks
    Alex
