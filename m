Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122AbaBRGDw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 01:03:52 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:32885 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbaBRGDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 01:03:50 -0500
Message-ID: <5302F7B7.60802@linaro.org>
Date: Tue, 18 Feb 2014 14:03:35 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Michael wang <wangyun@linux.vnet.ibm.com>, mingo@redhat.com,
        peterz@infradead.org, morten.rasmussen@arm.com
CC: vincent.guittot@linaro.org, daniel.lezcano@linaro.org, fweisbec@gmail.com,
        linux@arm.linux.org.uk, tony.luck@intel.com, fenghua.yu@intel.com,
        james.hogan@imgtec.com, jason.low2@hp.com, viresh.kumar@linaro.org,
        hanjun.guo@linaro.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        pjt@google.com, fengguang.wu@intel.com, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v2 0/11] remove cpu_load in rq
References: <1392602117-20773-1-git-send-email-alex.shi@linaro.org> <5302E6FA.508@linux.vnet.ibm.com>
In-Reply-To: <5302E6FA.508@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2014 12:52 PM, Michael wang wrote:
> On 02/17/2014 09:55 AM, Alex Shi wrote:
>> The cpu_load decays on time according past cpu load of rq. The sched_avg also decays tasks' load on time. Now we has 2 kind decay for cpu_load. That is a kind of redundancy. And increase the system load by decay calculation. This patch try to remove the cpu_load decay.
>>
>> There are 5 load_idx used for cpu_load in sched_domain. busy_idx and idle_idx are not zero usually, but newidle_idx, wake_idx and forkexec_idx are all zero on every arch. A shortcut to remove cpu_Load decay in the first patch. just one line patch for this change.
>>
>> V2,
>> 1, This version do some tuning on load bias of target load, to maximum match current code logical.
>> 2, Got further to remove the cpu_load in rq.
>> 3, Revert the patch 'Limit sd->*_idx range on sysctl' since no needs
>>
>> Any testing/comments are appreciated.
> 
> Tested on 12-cpu-x86 box with tip/master, ebizzy and hackbench
> works fine, show little improvements for each time's testing.

Thanks a lot for your data!
> 
> 
> BTW, I got panic while rebooting, but should not caused by
> this patch set, will recheck and post the report later.
> 

I reviewed my patch again. Also didn't find suspicious line for the
following rcu stall.  Will wait for your report. :)
> 

-- 
Thanks
    Alex
