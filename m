Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaBZCsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 21:48:23 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:49642 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbaBZCsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 21:48:22 -0500
Message-ID: <530D55ED.4060903@hitachi.com>
Date: Wed, 26 Feb 2014 11:48:13 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG kretprobes] kretprobe triggers General Protection Faults
References: <1332921457.30140.1393357561516.JavaMail.zimbra@efficios.com>
In-Reply-To: <1332921457.30140.1393357561516.JavaMail.zimbra@efficios.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathieu,

(2014/02/26 4:46), Mathieu Desnoyers wrote:
> Hi,
> 
> I had a bug report[1] from a user trying to add a kretprobe on the system
> call entry code path:
> 
> arch/x86/kernel/entry_64.S:
> 
> ffffffff813dffe2 <system_call_fastpath+0x16>:
>         cmpl $__NR_syscall_max,%eax
> #endif
>         ja badsys
>         movq %r10,%rcx
>         call *sys_call_table(,%rax,8)  # XXX:    rip relative
>         movq %rax,RAX-ARGOFFSET(%rsp)   <--- return address pointing here

Hm, I guess you put kretprobes on the functions on the sys_call_table,
right?

> And all hell breaks loose (various types of faults, machine reboots,
> applications exit randomly, etc.). I understand that this code path
> is not marked as unsafe against kprobes, and I tested that a kprobes
> indeed works fine there. However, kretprobes probably presumes a function
> stack layout that is just not valid for the syscall entry routine.

All the syscall entry functions caused this issue? or some
specific function(s) ?
And could you tell me the kernel version you used?

> Any thoughts on how kretprobes should handle this ?

I'll try to reproduce it in kvm environment.

Thank you!

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


