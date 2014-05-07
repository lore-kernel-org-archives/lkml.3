Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934039AbaEGPwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:52:53 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:32534 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933440AbaEGPwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:52:50 -0400
Message-ID: <536A56C3.2070505@oracle.com>
Date: Wed, 07 May 2014 11:52:35 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>
CC: roland@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: ptrace: gpf in syscall_trace_enter
References: <53698021.5020108@oracle.com>	<53699F7C.1040308@oracle.com>	<20140507140422.GB17419@redhat.com> <20140507114938.28e300c6@gandalf.local.home>
In-Reply-To: <20140507114938.28e300c6@gandalf.local.home>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2014 11:49 AM, Steven Rostedt wrote:
> On Wed, 7 May 2014 16:04:22 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
> 
>> On 05/06, Sasha Levin wrote:
>>>
>>> On 05/06/2014 08:36 PM, Sasha Levin wrote:
>>>> Hi all,
>>>>
>>>> While fuzzing with trinity inside a KVM tools guest running the latest -next
>>>> kernel I've stumbled on the following spew:
>>>
>>> And another similar trace:
>>
>> Again, this looks like __DO_TRACE() trying to call it_func_ptr->func().
>>
>>> [ 6897.628729] general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
>>> [ 6897.629654] Dumping ftrace buffer:
>>> [ 6897.630034]    (ftrace buffer empty)
>>> [ 6897.630034] Modules linked in:
>>> [ 6897.630034] CPU: 24 PID: 23736 Comm: trinity-c148 Tainted: G    B         3.15.0-rc4-next-20140506-sasha-00021-gc164334-dirty #447
>>> [ 6897.630034] task: ffff88002a870000 ti: ffff88000ef04000 task.ti: ffff88000ef04000
>>> [ 6897.630034] RIP: syscall_trace_leave (include/trace/events/syscalls.h:42 arch/x86/kernel/ptrace.c:1517)
> 
> Thanks for sending the objdump, but then I just realized that this dump
> doesn't have the actual RIP. It just says syscall_trace_leave, without
> even giving me the offset.
> 
> As the objdump is just of the object files and not the vmlinux, I would
> need the offset from syscall_trace_leave of the RIP.

    2803:	41 ff 14 24          	callq  *(%r12)  <=== Here
    2807:	49 83 c4 10          	add    $0x10,%r12
    280b:	49 83 3c 24 00       	cmpq   $0x0,(%r12)


Thanks,
Sasha
