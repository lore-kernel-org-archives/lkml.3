Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041AbaAJToK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 14:44:10 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:8481 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbaAJToI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 14:44:08 -0500
Message-ID: <52D04D6D.9010504@hp.com>
Date: Fri, 10 Jan 2014 14:43:41 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: SIGSEGV when using "perf record -g" with 3.13-rc* kernel
References: <52D011C9.7000209@hp.com> <20140110165822.GI7572@laptop.programming.kicks-ass.net> <20140110170223.GD8224@laptop.programming.kicks-ass.net> <20140110174141.GE8224@laptop.programming.kicks-ass.net> <CALCETrW2r=_Vt7+4aNKkKGeCAi8=WPULvPX3eyUEKH5nsu_CKQ@mail.gmail.com>
In-Reply-To: <CALCETrW2r=_Vt7+4aNKkKGeCAi8=WPULvPX3eyUEKH5nsu_CKQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2014 01:54 PM, Andy Lutomirski wrote:
> On Fri, Jan 10, 2014 at 9:41 AM, Peter Zijlstra<peterz@infradead.org>  wrote:
>> On Fri, Jan 10, 2014 at 06:02:23PM +0100, Peter Zijlstra wrote:
>>> On Fri, Jan 10, 2014 at 05:58:22PM +0100, Peter Zijlstra wrote:
>>>> On Fri, Jan 10, 2014 at 10:29:13AM -0500, Waiman Long wrote:
>>>>> Peter,
>>>>>
>>>>> Call Trace:
>>>>> <NMI>   [<ffffffff815710af>] dump_stack+0x49/0x62
>>>>>   [<ffffffff8104e3bc>] warn_slowpath_common+0x8c/0xc0
>>>>>   [<ffffffff8104e40a>] warn_slowpath_null+0x1a/0x20
>>>>>   [<ffffffff8105f1f1>] force_sig_info+0x131/0x140
>>>>>   [<ffffffff81042a4f>] force_sig_info_fault+0x5f/0x70
>>>>>   [<ffffffff8106d8da>] ? search_exception_tables+0x2a/0x50
>>>>>   [<ffffffff81043b3d>] ? fixup_exception+0x1d/0x70
>>>>>   [<ffffffff81042cc9>] no_context+0x159/0x1f0
>>>>>   [<ffffffff81042e8d>] __bad_area_nosemaphore+0x12d/0x230
>>>>>   [<ffffffff81042e8d>] ? __bad_area_nosemaphore+0x12d/0x230
>>>>>   [<ffffffff81042fa3>] bad_area_nosemaphore+0x13/0x20
>>>>>   [<ffffffff81578fc2>] __do_page_fault+0x362/0x480
>>>>>   [<ffffffff81578fc2>] ? __do_page_fault+0x362/0x480
>>>>>   [<ffffffff815791be>] do_page_fault+0xe/0x10
>>>>>   [<ffffffff81575962>] page_fault+0x22/0x30
>>>>>   [<ffffffff815817e4>] ? bad_to_user+0x5e/0x66b
>>>>>   [<ffffffff81285316>] copy_from_user_nmi+0x76/0x90
>>>>>   [<ffffffff81017a20>] perf_callchain_user+0xd0/0x360
>>>>>   [<ffffffff8111f64f>] perf_callchain+0x1af/0x1f0
>>>>>   [<ffffffff81117693>] perf_prepare_sample+0x2f3/0x3a0
>>>>>   [<ffffffff8111a2af>] __perf_event_overflow+0x10f/0x220
>>>>>   [<ffffffff8111ab14>] perf_event_overflow+0x14/0x20
>>>>>   [<ffffffff8101f69e>] intel_pmu_handle_irq+0x1de/0x3c0
>>>>>   [<ffffffff81008e44>] ? emulate_vsyscall+0x144/0x390
>>>>>   [<ffffffff81576e64>] perf_event_nmi_handler+0x34/0x60
>>>>>   [<ffffffff8157664a>] nmi_handle+0x8a/0x170
>>>>>   [<ffffffff81576848>] default_do_nmi+0x68/0x210
>>>>>   [<ffffffff81576a80>] do_nmi+0x90/0xe0
>>>>>   [<ffffffff81575c67>] end_repeat_nmi+0x1e/0x2e
>>>>>   [<ffffffff81008e44>] ? emulate_vsyscall+0x144/0x390
>>>>>   [<ffffffff81008e44>] ? emulate_vsyscall+0x144/0x390
>>>>>   [<ffffffff81008e44>] ? emulate_vsyscall+0x144/0x390
>>>>> <<EOE>>   [<ffffffff81042f7d>] __bad_area_nosemaphore+0x21d/0x230
>>>>>   [<ffffffff81042fa3>] bad_area_nosemaphore+0x13/0x20
>>>>>   [<ffffffff81578fc2>] __do_page_fault+0x362/0x480
>>>>>   [<ffffffff8113cfbc>] ? vm_mmap_pgoff+0xbc/0xe0
>>>>>   [<ffffffff815791be>] do_page_fault+0xe/0x10
>>>>>   [<ffffffff81575962>] page_fault+0x22/0x30
>>>>> ---[ end trace 037bf09d279751ec ]---
>>>>>
>>>>> So this is a double page faults. Looking at relevant changes in
>>>>> 3.13 kernel, I spotted the following one patch that modified the
>>>>> perf_callchain_user() function shown up in the stack trace above:
>>>>>
>>>> Hurm, that's an expected double fault, not something we should take the
>>>> process down for.
>>>>
>>>> I'll have to look at how all that works for a bit.
>> Andy, introduced all this in 4fc3490114bb ("x86-64: Set siginfo and
>> context on vsyscall emulation faults").
>>
>> It looks like your initial userspace fault hit the magic button and ends
>> up in emulate_vsyscall. Right at that point we trigger a PMI, which
>> tries to do a stack-trace. That stack-trace also stumbles into unmapped
>> memory (might be the same) and faults again.
>>
>> Now at that point, we usually just give up on the callchain and proceed
>> like normal, however because of this double fault emulate-vsyscall
>> SIGSEGV magic you loose.
>>
>> So the below might well be a valid fix.. Anybody? Andy?
> Yuck -- when I wrote that thing, I hadn't imagined that an interrupt
> (there's nothing particularly special about NMIs here, I think) would
> try to access user memory.  The fix below looks okay, but IMO it needs
> a big fat comment explaining what's going on.
>
> Is there a way to ask whether the previous entry into the kernel came
> from user space?  The valid "sig_on_uaccess_error" case happens when
> the current fault was triggered by a fault from userspace.  The
> invalid case (and any invalid case from, say, an int3 that a
> tracepoint stuck in there) would be a page fault triggered by a fault
> handler that in turn started in kernel space (in particular, in
> emulate_vsyscall).

The processes that got the SIGSEGV were all running shell scripts. I am 
not totally sure that they were running in user space when getting the 
PMIs, but are likely the case.

-Longman

