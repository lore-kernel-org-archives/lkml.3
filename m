Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936660Ab3DICmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 22:42:22 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:5823 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934789Ab3DICmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 22:42:21 -0400
Message-ID: <51637FEE.8070507@huawei.com>
Date: Tue, 9 Apr 2013 10:41:50 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        WANG Chao <chaowang@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH 3/3] ftrace: Do not call stub functions in control loop
References: <20130408204937.649895945@goodmis.org>  <20130408210518.551272592@goodmis.org> <51637830.1010309@huawei.com> <1365473805.25498.44.camel@gandalf.local.home>
In-Reply-To: <1365473805.25498.44.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/4/9 10:16, Steven Rostedt wrote:
> On Tue, 2013-04-09 at 10:08 +0800, zhangwei(Jovi) wrote:
>> On 2013/4/9 4:49, Steven Rostedt wrote:
>>> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
>>>
>>> The function tracing control loop used by perf spits out a warning
>>> if the called function is not a control function. This is because
>>> the control function references a per cpu allocated data structure
>>> on struct ftrace_ops that is not allocated for other types of
>>> functions.
>>>
>>> commit 0a016409e42 "ftrace: Optimize the function tracer list loop"
>>>
>>> Had an optimization done to all function tracing loops to optimize
>>> for a single registered ops. Unfortunately, this allows for a slight
>>> race when tracing starts or ends, where the stub function might be
>>> called after the current registered ops is removed. In this case we
>>> get the following dump:
>>>
> 
>> Involve stable? 3.8 kernel user would need this fix.
> 
> Why? commit 0a016409e42 "ftrace: Optimize the function tracer list loop"
> was added for 3.9. 3.8 has:
> 
>         op = rcu_dereference_raw(ftrace_control_list);
>         while (op != &ftrace_list_end) {
>                 if (!ftrace_function_local_disabled(op) &&
>                     ftrace_ops_test(op, ip))
>                         op->func(ip, parent_ip, op, regs);
> 
>                 op = rcu_dereference_raw(op->next);
>         };
> 
> The stub function will never get called.
> 
> -- Steve
Hmm, You are right, I misunderstand tag info got by git describe in my local box

[root@jovi linux]# git describe 0a016409e42
trace-3.8-rc4-fix-19-g0a01640

> 
> 
> 
> 
> .
> 


