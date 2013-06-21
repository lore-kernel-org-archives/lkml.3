Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423330Ab3FUISg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 04:18:36 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:53389 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161355Ab3FUIST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 04:18:19 -0400
Message-ID: <51C40C10.9040306@huawei.com>
Date: Fri, 21 Jun 2013 16:17:20 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/uprobes: Support ftrace_event_file base multibuffer
References: <51BA7578.4080108@huawei.com> <20130614144442.GA1943@redhat.com> <20130620164355.GA7910@redhat.com>
In-Reply-To: <20130620164355.GA7910@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/6/21 0:43, Oleg Nesterov wrote:
> Hi,
> 
> Now that we finished the discussion of the similar code in kprobes,
> let me summarize.
> 
> On 06/14, Oleg Nesterov wrote:
>>
>> On 06/14, zhangwei(Jovi) wrote:
>>>
>>> +		rcu_assign_pointer(tu->files, new);
>>> +		tu->flags |= TP_FLAG_TRACE;
>>> +
>>> +		if (old) {
>>> +			/* Make sure the probe is done with old files */
>>> +			synchronize_sched();
>>> +			kfree(old);
>>> +		}
>>> +	} else
>>> +		tu->flags |= TP_FLAG_PROFILE;
>>
>> So it can set both TP_FLAG_TRACE and TP_FLAG_PROFILE, yes?
>>
>> If yes, this is not right. Until we change the pre-filtering at least.
>> Currently TP_FLAG_TRACE/TP_FLAG_PROFILE are mutually exclusive.
> 
> Yes. So please update this patch so that TP_FLAG_PROFILE can't be
> set if TP_FLAG_TRACE is set and vice versa.
> 
> Once again, this limitation is artificial. But it was always here,
> and we need more changes to remove it. I'll try to do this later.
> (but if you want to play with this code - welcome ;)
> 
> Don't add the mutex, and do not use array-of-pointers (I hope you
> noticed the recent discussion).
> 
> Locking. Oh, OK. Let it be rcu for now (but please do not forget
> that you need rcu_read_lock, uprobe handlers run in the sleepable
> context). This is sub-optimal, but this is just another indication
> that uprobes API is not perfect, we can't use uprobe->register_sem.
> 
> Also. When I was reading trace_kprobes.c I notice the new (and imho
> useful) feature, soft disable/enable. Perhaps you can make a 2nd
> patch which adds the FTRACE_EVENT_FL_SOFT_DISABLED_BIT check?
> 
> Oleg.
> 
Thanks Oleg, I will send v2 patch soon.

.jovi




