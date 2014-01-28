Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbaA0MMP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 07:12:15 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:34258 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbaA0MMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 07:12:14 -0500
X-IronPort-AV: E=Sophos;i="4.95,728,1384272000"; 
   d="scan'208";a="9458194"
Message-ID: <52E70362.2070207@cn.fujitsu.com>
Date: Mon, 27 Jan 2014 20:09:54 -0500
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, raistlin@linux.it, juri.lelli@gmail.com,
        clark.williams@gmail.com, mingo@redhat.com, rostedt@goodmis.org
Subject: Re: [PATCH 3/3] sched: Implement task_nice and task_prio as static
 inline functions.
References: <cover.1390859827.git.yangds.fnst@cn.fujitsu.com> <1800e6249ff54199573ea5f0aa4ec16b15bb5158.1390859827.git.yangds.fnst@cn.fujitsu.com> <20140127103258.GZ11314@laptop.programming.kicks-ass.net>
In-Reply-To: <20140127103258.GZ11314@laptop.programming.kicks-ass.net>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/27 20:10:38,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/27 20:10:39,
	Serialize complete at 2014/01/27 20:10:39
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2014 05:32 AM, Peter Zijlstra wrote:
> On Mon, Jan 27, 2014 at 05:15:39PM -0500, Dongsheng Yang wrote:
>> +/**
>> + * task_prio - return the priority value of a given task.
>> + * @p: the task in question.
>> + *
>> + * Return: The priority value as seen by users in /proc.
>> + * RT tasks are offset by -200. Normal tasks are centered
>> + * around 0, value goes from -16 to +15.
>> + */
>> +static inline int task_prio(const struct task_struct *p)
>> +{
>> +	return p->prio - MAX_RT_PRIO;
>> +}
> Who would ever want to use/rely on this? It doesn't make any sense. And
> therefore it shouldn't ever be considered time critical.

I just copy it from kernel/sched/core.c. Currently, it is used in 
fs/proc/array.c.
>
>> +/**
>> + * task_nice - return the nice value of a given task.
>> + * @p: the task in question.
>> + *
>> + * Return: The nice value [ -20 ... 0 ... 19 ].
>> + */
>> +static inline int task_nice(const struct task_struct *p)
>> +{
>> +	return TASK_NICE(p);
>> +}
> Urgh, no. Just remove the macro already. Although arguably we should
> remove ->static_prio and clean up that entire mess.
>

Oops, sorry for the noise. I am a newbie here, could you help to point 
out that
  which tree is the latest version for sched. Thanx :)

