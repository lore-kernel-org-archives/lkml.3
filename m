Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbaKYXQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 18:16:10 -0500
Received: from mga01.intel.com ([192.55.52.88]:30413 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994AbaKYXQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 18:16:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,458,1413270000"; 
   d="scan'208";a="628263075"
Date: Wed, 26 Nov 2014 06:55:23 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Juri Lelli <juri.lelli@arm.com>
Cc: Wanpeng Li <wanpeng.li@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kirill Tkhai <ktkhai@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] sched/deadline: fix pull if dl task who's prio
 changed is not on queue
Message-ID: <20141125225523.GA5058@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1416386103-90800-1-git-send-email-wanpeng.li@linux.intel.com>
 <1416386103-90800-2-git-send-email-wanpeng.li@linux.intel.com>
 <5474C255.6020703@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5474C255.6020703@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Juri,
On Tue, Nov 25, 2014 at 05:54:29PM +0000, Juri Lelli wrote:
>Hi,
>
>On 19/11/14 08:35, Wanpeng Li wrote:
>> Dl task who is not on queue and it is also the curr task simultaneously 
>> can not happen. In addition, pull since the priority of a not on queue 
>> dl task doesn't make any sense.
>> 
>> This patch fix it by don't pull if dl task who's prio changed is not on 
>> queue.
>> 
>> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
>> ---
>>  kernel/sched/deadline.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>> 
>> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
>> index b9e44ae..4eaf55c 100644
>> --- a/kernel/sched/deadline.c
>> +++ b/kernel/sched/deadline.c
>> @@ -1678,7 +1678,10 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
>>  static void prio_changed_dl(struct rq *rq, struct task_struct *p,
>>  			    int oldprio)
>>  {
>> -	if (task_on_rq_queued(p) || rq->curr == p) {
>> +	if (!task_on_rq_queued(p))
>> +		return;
>> +
>> +	if (rq->curr == p) {
>
>Yeah. I already posted a patches for this, that I forgot to properly
>post again :/. I'll do it soon.

Cool, so we can ignore this patch from me, and you can move forward. ;-)
I will resend the recent posted patches in one patchset so you can
review them easily.

Regards,
Wanpeng Li 

>
>Thanks,
>
>- Juri
>
>>  #ifdef CONFIG_SMP
>>  		/*
>>  		 * This might be too much, but unfortunately
>> 
