Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095AbaBSSK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 13:10:58 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:37936 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077AbaBSSKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 13:10:55 -0500
Message-ID: <5304F38E.3090701@oracle.com>
Date: Wed, 19 Feb 2014 13:10:22 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Michael wang <wangyun@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, Dave Jones <davej@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched: fair: NULL ptr deref in check_preempt_wakeup
References: <52FFF7F8.2070801@oracle.com> <5301C41D.5000009@linux.vnet.ibm.com> <20140217092055.GP27965@twins.programming.kicks-ass.net> <5302C4F1.3020907@linux.vnet.ibm.com>
In-Reply-To: <5302C4F1.3020907@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2014 09:26 PM, Michael wang wrote:
> On 02/17/2014 05:20 PM, Peter Zijlstra wrote:
> [snip]
>>> >>  static void switched_to_fair(struct rq *rq, struct task_struct *p)
>>> >>  {
>>> >>-	if (!p->se.on_rq)
>>> >>+	struct sched_entity *se = &p->se;
>>> >>+#ifdef CONFIG_FAIR_GROUP_SCHED
>>> >>+	se->depth = se->parent ? se->parent->depth + 1 : 0;
>>> >>+#endif
>>> >>+	if (!se->on_rq)
>>> >>  		return;
>>> >>
>>> >>  	/*
>> >
>> >Yes indeed. My first idea yesterday was to put it in set_task_rq() to be
>> >absolutely sure we catch all; but if this is sufficient its better.
> Agree, let's wait for Sasha's testing result then:)

I took my time with testing it seems I'm hitting new issues with both sched and mm, and I've wanted 
to confirm I don't see this one any more.

It does seem like this patch fixes the problem for me, so:

	Tested-by: Sasha Levin <sasha.levin@oracle.com>


Thanks,
Sasha
