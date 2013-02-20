Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935342Ab3BTM1z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 07:27:55 -0500
Received: from mga02.intel.com ([134.134.136.20]:64178 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935224Ab3BTM1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 07:27:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,701,1355126400"; 
   d="scan'208";a="265037616"
Message-ID: <5124C144.40108@intel.com>
Date: Wed, 20 Feb 2013 20:27:48 +0800
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
Subject: Re: [patch v5 07/15] sched: add new sg/sd_lb_stats fields for incoming
 fork/exec/wake balancing
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com>  <1361164062-20111-8-git-send-email-alex.shi@intel.com> <1361353109.10155.7.camel@laptop>
In-Reply-To: <1361353109.10155.7.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 05:38 PM, Peter Zijlstra wrote:
> On Mon, 2013-02-18 at 13:07 +0800, Alex Shi wrote:
>> @@ -4214,6 +4214,11 @@ struct sd_lb_stats {
>>         unsigned int  busiest_group_weight;
>>  
>>         int group_imb; /* Is there imbalance in this sd */
>> +
>> +       /* Varibles of power awaring scheduling */
>> +       unsigned int  sd_utils; /* sum utilizations of this domain */
>> +       unsigned long sd_capacity;      /* capacity of this domain */
>> +       struct sched_group *group_leader; /* Group which relieves
>> group_min */
>>  };
>>  
>>  /*
>> @@ -4229,6 +4234,7 @@ struct sg_lb_stats {
>>         unsigned long group_weight;
>>         int group_imb; /* Is there an imbalance in the group ? */
>>         int group_has_capacity; /* Is there extra capacity in the
>> group? */
>> +       unsigned int group_utils;       /* sum utilizations of group
>> */
>>  };
> 
> So I have two problems with the _utils name, firstly its a single value
> and therefore we shouldn't give it a name in plural, secondly, whenever
> I read utils I read utilities, not utilizations.

I think you are right. At least don't need a plural utilization.
Sorry for my bad English. how about group_util here?
> 
> As a non native speaker I'm not entirely sure, but utilizations sounds
> iffy to me, is there even a plural of utilization?
> 


-- 
Thanks
    Alex
