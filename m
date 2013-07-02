Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab3GBXZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 19:25:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23060 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab3GBXZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 19:25:26 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=7pBTIyHDArkA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=kWN4WHtJ9-kA:10 a=i0EeH86SAAAA:8 a=xrUKD_JN5Fumvqy-xqYA:9 a=QEXdDO2ut3YA:10 a=hPjdaMEvmhQA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1372807524.22688.78.camel@gandalf.local.home>
Subject: Re: [PATCH v3 02/12] tracing: fix irqs-off tag display in syscall
 tracing
From: Steven Rostedt <rostedt@goodmis.org>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org
Date: Tue, 02 Jul 2013 19:25:24 -0400
In-Reply-To: <1365564393-10972-3-git-send-email-jovi.zhangwei@huawei.com>
References: <1365564393-10972-1-git-send-email-jovi.zhangwei@huawei.com>
	 <1365564393-10972-3-git-send-email-jovi.zhangwei@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-10 at 11:26 +0800, zhangwei(Jovi) wrote:
> From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
> 
> Now all syscall tracing irqs-off tag is wrong,
> syscall enter entry doesn't disable irq.
> 
>  [root@jovi tracing]#echo "syscalls:sys_enter_open" > set_event
>  [root@jovi tracing]# cat trace
>  # tracer: nop
>  #
>  # entries-in-buffer/entries-written: 13/13   #P:2
>  #
>  #                              _-----=> irqs-off
>  #                             / _----=> need-resched
>  #                            | / _---=> hardirq/softirq
>  #                            || / _--=> preempt-depth
>  #                            ||| /     delay
>  #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
>  #              | |       |   ||||       |         |
>        irqbalance-513   [000] d... 56115.496766: sys_open(filename: 804e1a6, flags: 0, mode: 1b6)
>        irqbalance-513   [000] d... 56115.497008: sys_open(filename: 804e1bb, flags: 0, mode: 1b6)
>          sendmail-771   [000] d... 56115.827982: sys_open(filename: b770e6d1, flags: 0, mode: 1b6)
> 
> The reason is syscall tracing doesn't record irq_flags into buffer.
> Fix this after this patch:
> 
>  [root@jovi tracing]#echo "syscalls:sys_enter_open" > set_event
>  [root@jovi tracing]# cat trace
>  # tracer: nop
>  #
>  # entries-in-buffer/entries-written: 14/14   #P:2
>  #
>  #                              _-----=> irqs-off
>  #                             / _----=> need-resched
>  #                            | / _---=> hardirq/softirq
>  #                            || / _--=> preempt-depth
>  #                            ||| /     delay
>  #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
>  #              | |       |   ||||       |         |
>        irqbalance-514   [001] ....    46.213921: sys_open(filename: 804e1a6, flags: 0, mode: 1b6)
>        irqbalance-514   [001] ....    46.214160: sys_open(filename: 804e1bb, flags: 0, mode: 1b6)
>             <...>-920   [001] ....    47.307260: sys_open(filename: 4e82a0c5, flags: 80000, mode: 0)
> 
> Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
> ---

I'll pull this one in for 3.11 and mark for stable.

Thanks,

-- Steve


