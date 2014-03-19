Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906AbaCSCWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 22:22:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:32089 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758484AbaCSCWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 22:22:06 -0400
X-IronPort-AV: E=Sophos;i="4.97,682,1389715200"; 
   d="scan'208";a="9722370"
Message-ID: <5328FED8.7090007@cn.fujitsu.com>
Date: Wed, 19 Mar 2014 10:20:08 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@redhat.com
Subject: Re: [PATCH 1/3 Resend] tracing: Use inline task_nice() to get rid
 of an open coded implementation of it.
References: <cover.1394619587.git.yangds.fnst@cn.fujitsu.com> <6188b0062bdba8e3170b09c88fac6004a8f6fa7c.1394619587.git.yangds.fnst@cn.fujitsu.com> <20140318221533.45c479bd@gandalf.local.home>
In-Reply-To: <20140318221533.45c479bd@gandalf.local.home>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/19 10:19:06,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/19 10:19:07,
	Serialize complete at 2014/03/19 10:19:07
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2014 10:15 AM, Steven Rostedt wrote:
> On Wed, 12 Mar 2014 18:26:42 +0800
> Dongsheng Yang <yangds.fnst@cn.fujitsu.com> wrote:
>
>> Function task_nice() was reimplemented as inline function, we can use it here
>> to replace the open coded implementation.
>>
>> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
>> cc: Steven Rostedt <rostedt@goodmis.org>
>> ---
>>   kernel/trace/trace.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
>> index 815c878..dba0e3d 100644
>> --- a/kernel/trace/trace.c
>> +++ b/kernel/trace/trace.c
>> @@ -1003,7 +1003,7 @@ __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
>>   	else
>>   		max_data->uid = task_uid(tsk);
>>   
>> -	max_data->nice = tsk->static_prio - 20 - MAX_RT_PRIO;
>> +	max_data->nice = task_nice(tsk);
> task_nice() is still an extern function in mainline, and this is the
> tracing side. I rather wait till it becomes inline in Linus's tree
> before I take this.

Sounds reasonable to me.

Thanx.
>
> -- Steve
>
>>   	max_data->policy = tsk->policy;
>>   	max_data->rt_priority = tsk->rt_priority;
>>   
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

