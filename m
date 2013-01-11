Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab3AKFnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 00:43:19 -0500
Received: from mga14.intel.com ([143.182.124.37]:33709 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200Ab3AKFnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 00:43:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,449,1355126400"; 
   d="scan'208";a="242594846"
Message-ID: <50EFA6B5.2060306@intel.com>
Date: Fri, 11 Jan 2013 13:44:21 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 07/22] sched: set initial load avg of new forked task
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com> <1357375071-11793-8-git-send-email-alex.shi@intel.com> <50EF9ED1.2000909@linux.vnet.ibm.com>
In-Reply-To: <50EF9ED1.2000909@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2013 01:10 PM, Preeti U Murthy wrote:
>> >  	update_curr(cfs_rq);
>> > -	enqueue_entity_load_avg(cfs_rq, se, flags & ENQUEUE_WAKEUP);
>> > +	enqueue_entity_load_avg(cfs_rq, se, flags);
>> >  	account_entity_enqueue(cfs_rq, se);
>> >  	update_cfs_shares(cfs_rq);
>> > 
> I had seen in my experiments, that the forked tasks with initial load to
> be 0,would adversely affect the runqueue lengths.Since the load for
> these tasks to pick up takes some time,the cpus on which the forked
> tasks are scheduled, could be candidates for "dst_cpu" many times and
> the runqueue lengths increase considerably.
> 
> This patch solves this issue by making the forked tasks contribute
> actively to the runqueue load.
> 
> Reviewed-by:Preeti U Murthy
> 

Thanks for review, Preeti! :)


-- 
Thanks Alex
