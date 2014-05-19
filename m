Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbaESISv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 04:18:51 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:32889 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbaESISu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 04:18:50 -0400
Message-ID: <5379BD2C.6080106@linux.vnet.ibm.com>
Date: Mon, 19 May 2014 13:43:32 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Ben Segall <bsegall@google.com>
CC: Preeti Murthy <preeti.lkml@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: fix exec_start/task_hot on migrated tasks
References: <20140515225920.7179.13924.stgit@sword-of-the-dawn.mtv.corp.google.com> <20140516080424.GM11096@twins.programming.kicks-ass.net> <CAM4v1pPNfpB+DumFHhi2UZS97zgfBFHEwQYsmQ5E1c2gZFbBww@mail.gmail.com> <20140516141745.GU11096@twins.programming.kicks-ass.net>
In-Reply-To: <20140516141745.GU11096@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051908-9332-0000-0000-000000D4367E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2014 07:47 PM, Peter Zijlstra wrote:
> On Fri, May 16, 2014 at 07:27:32PM +0530, Preeti Murthy wrote:
>>> 0 isn't strictly the right thing to do here, since the clock can wrap,
>>> but being wrong every ~585 years isn't too big an issue for this.
>>
>> I don't understand this. Will setting it to 0 not indicate beginning
>> of ticking? 
> 
> In modular spaces there is no beginnings nor endings.
> 
>> So when you find out for how long the task has run, the
>> difference would be larger than what would have been had you
>> let exec_start be at its previous value of the old cpu's clock_task right?
> 
> Nope, see the modular space thing, once every ~585 years we'll wrap the
> clock and 0 is within range of recently ran.
> 
>> Will not setting exec_start to the clock_task of the destination rq
>> during migration be better? This would be the closest we could
>> come to estimating the amount of time the task has run on this new
>> cpu while deciding task_hot or not no?
> 
> Setting it to the exact clock_task of the destination rq would make it
> hot on that rq, even though it hasn't yet ran there, so you'd have to do
> something like: rq_clock_task(dst_rq) - sysctl_sched_migration_cost.
> 
> But seeing as how that is far more work, and all this is heuristics
> anyhow and an extra fail term of 1/585 years is far below the current
> fail rate, all is well.
> 

Ok now I understand this.Thanks!

Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>

