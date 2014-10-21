Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645AbaJUNiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 09:38:09 -0400
Received: from service87.mimecast.com ([91.220.42.44]:54007 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932509AbaJUNiH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 09:38:07 -0400
Message-ID: <544661BA.3040203@arm.com>
Date: Tue, 21 Oct 2014 14:38:02 +0100
From: Juri Lelli <juri.lelli@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Wanpeng Li <kernellwp@gmail.com>, Wanpeng Li <wanpeng.li@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] sched/deadline: don't need to check SD_BALANCE_FORK
References: <1413253360-5318-1-git-send-email-wanpeng.li@linux.intel.com> <54464F30.9000706@gmail.com>
In-Reply-To: <54464F30.9000706@gmail.com>
X-OriginalArrivalTime: 21 Oct 2014 13:38:02.0066 (UTC) FILETIME=[3C2C6B20:01CFED34]
X-MC-Unique: 114102114380202801
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 21/10/14 13:18, Wanpeng Li wrote:
> Cc Juri,
> 
> 于 10/14/14, 10:22 AM, Wanpeng Li 写道:
>> There is no need to do balance during fork since SCHED_DEADLINE 
>> tasks can't fork. This patch avoid the SD_BALANCE_FORK check.
>>
>> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
>> ---
>>  kernel/sched/deadline.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
>> index abfaf3d..f46b7f1 100644
>> --- a/kernel/sched/deadline.c
>> +++ b/kernel/sched/deadline.c
>> @@ -914,7 +914,7 @@ select_task_rq_dl(struct task_struct *p, int cpu, int sd_flag, int flags)
>>  	struct task_struct *curr;
>>  	struct rq *rq;
>>  
>> -	if (sd_flag != SD_BALANCE_WAKE && sd_flag != SD_BALANCE_FORK)
>> +	if (sd_flag != SD_BALANCE_WAKE)
>>  		goto out;
>>  
>>  	rq = cpu_rq(cpu);

Yes, makes sense.

Thanks,

- Juri

