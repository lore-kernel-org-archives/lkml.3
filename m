Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab3FJCBe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 22:01:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:63834 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929Ab3FJCBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 22:01:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,833,1363158000"; 
   d="scan'208";a="252746973"
Message-ID: <51B53375.40102@intel.com>
Date: Mon, 10 Jun 2013 10:01:25 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org, mgorman@suse.de,
        riel@redhat.com, wangyun@linux.vnet.ibm.com,
        Jason Low <jason.low2@hp.com>,
        Changlong Xie <changlongx.xie@intel.com>, sgruszka@redhat.com,
        fweisbec@gmail.com
Subject: Re: [patch v8 6/9] sched: compute runnable load avg in cpu_load and
 cpu_avg_load_per_task
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com> <1370589652-24549-7-git-send-email-alex.shi@intel.com> <51B530AE.3020004@cn.fujitsu.com>
In-Reply-To: <51B530AE.3020004@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2013 09:49 AM, Gu Zheng wrote:
> On 06/07/2013 03:20 PM, Alex Shi wrote:
> 
>> > They are the base values in load balance, update them with rq runnable
>> > load average, then the load balance will consider runnable load avg
>> > naturally.
>> > 
>> > We also try to include the blocked_load_avg as cpu load in balancing,
>> > but that cause kbuild performance drop 6% on every Intel machine, and
>> > aim7/oltp drop on some of 4 CPU sockets machines.
> Hi Alex,
>    Could you explain me why including the blocked_load_avg causes performance drop ?


Thanks for review!

the 9th patch has few explanation. like, after the only task got into
sleep in a CPU, there is only blocked_load_avg left, it looks quite big
in short time. that, block it get tasks before sleep, drive task to
other cpu in periodic balance. So, it cause clear load imbalance.

-- 
Thanks
    Alex
