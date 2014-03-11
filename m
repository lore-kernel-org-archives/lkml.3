Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583AbaCKJgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 05:36:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:33791 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752382AbaCKJgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 05:36:21 -0400
X-IronPort-AV: E=Sophos;i="4.97,629,1389715200"; 
   d="scan'208";a="9678097"
Message-ID: <531ED89C.4050408@cn.fujitsu.com>
Date: Tue, 11 Mar 2014 17:34:20 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, joe@perches.com, mingo@kernel.org,
        tglx@linutronix.de, heiko.carstens@de.ibm.com,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 07/16] ioprio: Add a macro named NICE_TO_IOPRIO.
References: <cover.1394529373.git.yangds.fnst@cn.fujitsu.com> <008cf8bba167646424d0fca68d96463feace2aee.1394529373.git.yangds.fnst@cn.fujitsu.com> <20140311092856.GU9987@twins.programming.kicks-ass.net>
In-Reply-To: <20140311092856.GU9987@twins.programming.kicks-ass.net>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 17:33:28,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 17:33:35,
	Serialize complete at 2014/03/11 17:33:35
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2014 05:28 PM, Peter Zijlstra wrote:
> On Tue, Mar 11, 2014 at 05:20:28PM +0800, Dongsheng Yang wrote:
>> As the task nice value is in [-20, 19] and the io priority is in [0, 7],
>> and the convert method from niceval to ioprio is implemented with an
>> opened code in task_nice_ioprio().
>>
>> This patch move the implementation to a macro NICE_TO_IOPRIO, making
>> it more readable and modular.
>>
>> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
>> ---
>>   include/linux/ioprio.h | 7 ++++++-
>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/linux/ioprio.h b/include/linux/ioprio.h
>> index beb9ce1..c0faa0b 100644
>> --- a/include/linux/ioprio.h
>> +++ b/include/linux/ioprio.h
>> @@ -18,6 +18,11 @@
>>   #define ioprio_valid(mask)	(IOPRIO_PRIO_CLASS((mask)) != IOPRIO_CLASS_NONE)
>>   
>>   /*
>> + * Convert the nice value [19,-20] to io priority value [0,7].
>> + */
>> +#define NICE_TO_IOPRIO(nice)	(nice_to_rlimit(nice) / 5)
>> +
>> +/*
>>    * These are the io priority groups as implemented by CFQ. RT is the realtime
>>    * class, it always gets premium service. BE is the best-effort scheduling
>>    * class, the default for any process. IDLE is the idle scheduling class, it
>> @@ -52,7 +57,7 @@ enum {
>>    */
>>   static inline int task_nice_ioprio(struct task_struct *task)
>>   {
>> -	return (task_nice(task) + 20) / 5;
>> +	return NICE_TO_IOPRIO(task_nice(task));
>>   }
> How exactly is adding a macro and code complexity making this code
> better?

About this patch, I think convert a nice value in [-20, 19] to ioprio in 
[0, 7]
is a common requirement. So I add a macro NICE_TO_IOPRIO to achieve it.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

