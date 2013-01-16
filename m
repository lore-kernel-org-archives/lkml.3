Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab3APF3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 00:29:17 -0500
Received: from mga09.intel.com ([134.134.136.24]:9631 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705Ab3APF3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 00:29:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,476,1355126400"; 
   d="scan'208";a="272608289"
Message-ID: <50F63AE8.8090908@intel.com>
Date: Wed, 16 Jan 2013 13:30:16 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Morten Rasmussen <Morten.Rasmussen@arm.com>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>, "pjt@google.com" <pjt@google.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "efault@gmx.de" <efault@gmx.de>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 11/22] sched: consider runnable load average in effective_load
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com> <1357375071-11793-12-git-send-email-alex.shi@intel.com> <20130110112817.GD2046@e103034-lin> <50EF8683.7040404@intel.com> <20130114120138.GJ2046@e103034-lin>
In-Reply-To: <20130114120138.GJ2046@e103034-lin>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2013 08:01 PM, Morten Rasmussen wrote:
>>>>  static long effective_load(struct task_group *tg, int cpu, long wl, long wg)
>>>> > >>  {
>>>> > >>  	struct sched_entity *se = tg->se[cpu];
>>>> > >>  
>>>> > >>  	if (!tg->parent)	/* the trivial, non-cgroup case */
>>>> > >> -		return wl;
>>>> > >> +		return wl * tg->cfs_rq[cpu]->tg_runnable_contrib
>>>> > >> +						>> NICE_0_SHIFT;
>>> > > 
>>> > > Why do we need to scale the load of the task (wl) by runnable_contrib
>>> > > when the task is in the root task group? Wouldn't the load change still
>>> > > just be wl?
>>> > > 
>> > 
>> > Here, wl is the load weight, runnable_contrib engaged the runnable time.
> Yes, wl is the load weight of the task. But I don't understand why you
> multiply it with the tg_runnable_contrib of the group you want to insert
> it into. Since effective_load() is supposed to return the load change
> caused by adding the task to the cpu it would make more sense if you
> multiplied with the task runnable_avg_sum / runnable_avg_period of the
> task in question.
> 

I was consider the task will follow the cpu's runnable time, like
throttle etc.
But may it is a bit early to consider this. use the task's runnable avg
seems better.

-- 
Thanks
    Alex
