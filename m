Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab3DKKi7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 06:38:59 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:38318 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab3DKKi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 06:38:58 -0400
Message-ID: <516692BF.6070904@hitachi.com>
Date: Thu, 11 Apr 2013 19:38:55 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Anton Arapov <anton@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH 0/1] uprobes/tracing: Don't pass addr=ip to perf_trace_buf_submit()
References: <20130329181520.GA20670@redhat.com> <20130329181545.GA20697@redhat.com> <20130404142522.GC8986@linux.vnet.ibm.com> <515E4938.6090809@hitachi.com> <20130405150110.GA31300@redhat.com> <51628DF8.6030102@hitachi.com> <20130410145818.GA30670@redhat.com>
In-Reply-To: <20130410145818.GA30670@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/10 23:58), Oleg Nesterov wrote:
> On 04/08, Masami Hiramatsu wrote:
>>
>> (2013/04/06 0:01), Oleg Nesterov wrote:
>>>
>>> Masami, perhaps you can also answer the question I asked in 0/4
>>> marc.info/?l=linux-kernel&m=136458107403835 ?
>>>
>>> 	Off-topic question... Why uprobe_perf_func() passes "addr = ip" to
>>> 	perf_trace_buf_submit() ? This just sets perf_sample_data->addr for
>>> 	PERF_SAMPLE_ADDR, do we really need this? and we already have
>>> 	perf_sample_data->ip initialized by perf.
>>>
>>> kprobe_perf_func() and kretprobe_perf_func() do the same.
>>>
>>
>> Good catch! I guess that I might misunderstood that it was used
>> for sampling execution address. It should be replaced with (u64)0,
>> as perf_trace_##call() does.
> 
> Thanks!
> 
> How about this trivial cleanup then? If I have your ack I'll add this
> patch to other pending changes.

That is good for me :)

> And... Cough, another question ;) To simplify, lets discuss kprobe_perf_func()
> only. Suppose that a task hits the kprobe but this task/cpu doesn't have
> a counter. Can't we avoid perf_trace_buf_prepare/submit in this case?
> IOW, what do you think about the change below?

Hmm, I'm not so sure how frequently this happens. And, is this right way to
handle that case? If so, we can do same thing also on trace_events.
(perf_trace_##call in include/trace/ftrace.h)

Thank you,


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


