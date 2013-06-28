Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751150Ab3F1ERj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 00:17:39 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:40613 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab3F1ERi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 00:17:38 -0400
Message-ID: <51CD0E5D.3050605@hitachi.com>
Date: Fri, 28 Jun 2013 13:17:33 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 v3] tracing/uprobes: Support ftrace_event_file base
 multibuffer
References: <51C90ECC.9030303@huawei.com> <20130627121231.GB8362@linux.vnet.ibm.com> <20130627162720.GA18961@redhat.com>
In-Reply-To: <20130627162720.GA18961@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/06/28 1:27), Oleg Nesterov wrote:
> On 06/27, Srikar Dronamraju wrote:
>>
>> * zhangwei(Jovi) <jovi.zhangwei@huawei.com> [2013-06-25 11:30:20]:
>>> +	if (!enabled) {
>>> +		tu->consumer.filter = filter;
>>> +		ret = uprobe_register(tu->inode, tu->offset, &tu->consumer);
>>> +		if (ret)
>>> +			tu->flags &= file ? ~TP_FLAG_TRACE : ~TP_FLAG_PROFILE;
>>
>> Dont we need to free link here? or where does the link that got
>> allocated freed?
> 
> Agreed...
> 
> Masami, it seems that (just in case, with or without "Turn trace_probe->files
> into list_head" I sent) trace_kpobes needs the similar fix too? Plus it should
> clear TP_FLAG_* if enable_k.*probe() fails.

Oops, right! this problem also happens on the latest kernel. I must fix that
before introducing list_head...

> Or enable_trace_probe() assumes that enable_kprobe() must succeed? In this
> case probably WARN_ON(ret) makes sense.

In the case of probing a module function, the event can be gone when the
module is unloaded. At that time, enable_trace_probe must fails.

BTW, Steven, could you control the traffic of recent tracing works? :)
There are several works on the ftrace we made, but each of them
sometimes conflicting. We'd better make a merge plan or a working
branch on your tracing tree which allows us to work together on it.

Thank you!

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


