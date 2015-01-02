Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208AbbABQME (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 11:12:04 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:33263 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbbABQMA convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:13:1>);
	Fri, 2 Jan 2015 11:12:00 -0500
Message-Id: <54A6C34C02000078000C4AE4@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Fri, 02 Jan 2015 16:11:56 +0000
From: "Jan Beulich" <jbeulich@suse.com>
To: <luto@amacapital.net>, <peterz@infradead.org>
Cc: <chenggang.qcg@alibaba-inc.com>, <chenggang.qin@gmail.com>,
        <dsahern@gmail.com>, <namhyung@gmail.com>, <efault@gmx.de>,
        <eranian@google.com>, <fengguang.wu@intel.com>,
        <yanmin.zhang@intel.com>, <akpm@linux-foundation.org>,
        <arjan@linux.intel.com>, <jolsa@redhat.com>, <mingo@redhat.com>,
        <paulus@samba.org>, <chenggang.qcg@taobao.com>,
        <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?Q?Re:=20=E7=AD=94=E5=A4=8D=EF=BC=9A[PATCH]=20perf=20core?=
 =?UTF-8?Q?:=20Use=20KSTK=5FESP()=20instead=20of=20pt=5Fregs->sp=20while?=
 =?UTF-8?Q?=20output=20user=20regs?=
References: <1419315745-20767-1-git-send-email-user@chenggang-laptop>
 <c027bde0-5f4f-441f-8d45-3e7f6f702231@alibaba-inc.com>
 <CALCETrVVvbnO-7bnyPCYhPbDoEg-hqmvVbfXL9ONbQPBTJNUZg@mail.gmail.com>
 <20141230190327.GB23965@worktop.programming.kicks-ass.net>
 <CALCETrWxPBdjY0+gCmPSwjYLB0u4Z4JgGtuR-XU=qwVzoDEBpA@mail.gmail.com>
 <CALCETrUEDuWoXyN+JrB5nWfL6B5odQJU37_y=-tzXN0vxr4tOQ@mail.gmail.com>
In-Reply-To: <CALCETrUEDuWoXyN+JrB5nWfL6B5odQJU37_y=-tzXN0vxr4tOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Andy Lutomirski <luto@amacapital.net> 12/31/14 3:00 AM >>>
>On Tue, Dec 30, 2014 at 3:29 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> Given how the x86_64* entry code works, using task_pt_regs from
>> anywhere except explicitly supported contexts (including exceptions
>> that originated in userspace and a small handful of system calls) is
>> asking for trouble.  NMI context is especially bad.
>>
>> How important is this feature, and which registers matter?  It might
>> be possible to use a dwarf unwinder on the kernel call stack to get
>> most of the regs from most contexts, and it might also be possible to
>> make small changes to the entry code to make it possible to get some
>> of the registers reliably, but it's not currently possible to safely
>> use task_pt_regs *at all* from NMI context unless you've at least
>> blacklisted a handful of origin RIP values that give dangerously bogus
>> results.  (Using do_nmi's regs parameter if user_mode_vm(regs) is a
>> different story.)
>
>It's actually worse than just knowing the interrupted kernel RIP.  If
>the call chain goes usermode -> IST exception -> NMI, then
>task_pt_regs is entirely uninitialized.  Assuming all the CFI
>annotations are correct, the unwinder could still do it from the
>kernel.
>
>Note that, as far as I know, Jan Beulich is the only person who uses
>the unwinder on kernel code.  Jan, how do you do this?

Trying to guess what you mean by "this": A stack switch gets expressed by
CFI annotations just like any other frame pointer adjustments. See for example
the CFI_DEF_CFA_REGISTER use in the SAVE_ARGS_IRQ macro.

If that wasn't your question, please be more precise.

Jan

