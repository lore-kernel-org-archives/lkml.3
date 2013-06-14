Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab3FNPtZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 11:49:25 -0400
Received: from usindpps05.hds.com ([207.126.252.18]:49458 "EHLO
	usindpps05.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab3FNPtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 11:49:22 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "hpa@zytor.com" <hpa@zytor.com>
CC: "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@elte.hu" <mingo@elte.hu>,
        "bp@alien8.de" <bp@alien8.de>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Tomoki Sekiyama <tomoki.sekiyama@hds.com>
Subject: RE: [PATCH v15 0/4] trace,x86: irq vector tracepoint support
Thread-Topic: [PATCH v15 0/4] trace,x86: irq vector tracepoint support
Thread-Index: AQHOY8CekDHD2kZxTEi/xfe/vZV94pk1ZXag
Date: Fri, 14 Jun 2013 15:47:59 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D41B03B6CC@USINDEM103.corp.hds.com>
References: <51B2472B.9040909@hds.com>
In-Reply-To: <51B2472B.9040909@hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-06-14_05:2013-06-14,2013-06-14,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1306140130
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5EFnae7005931

Any comments?

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Seiji Aguchi
> Sent: Friday, June 07, 2013 4:49 PM
> To: linux-kernel@vger.kernel.org; rostedt@goodmis.org; hpa@zytor.com
> Cc: tglx@linutronix.de; mingo@elte.hu; bp@alien8.de; linux-edac@vger.kernel.org; tony.luck@intel.com; dle-
> develop@lists.sourceforge.net; Tomoki Sekiyama
> Subject: [PATCH v15 0/4] trace,x86: irq vector tracepoint support
> 
> Change log
>   v14 -> v15
>  - Patch 2/4
>    Introduce non-trace irq handlers with entering/exiting_irq()
>    by separating it from previous "patch v14 3/3".
> 
>  - Patch 3/4 (newly created)
>    Separate a patch renaming variables for debugging and introducing
>    load_current_idt() from previous "patch v14 3/3".
> 
>  - Patch 4/4
>    Introduce load_current_idt() to cpu_init() for i386 to handle cpu-hotplug.
> 
>  v13 -> v14
>  - Rebase to 3.10-rc4
>  - Patch 3/3
>    - Add comments above load_current_idt() in arch/x86/include/asm/desc.h.
>    - Introduce a logic selecting IDT that we currently should be using,
>      based on the current state instead of current_idt_desc_ptr.
>    - Rename some "nmi" variables to "debug".
>    - Introduce local_irq_save/restore() in load_current_idt() to avoid races
>      regardless of process/interrupt context.
> 
>  v12 -> v13
>  - Rebase to 3.10-rc3
>  - Patch 2/3
>    - Separate a patch introducing entering/exiting_irq() from patch-v12 3/3.
>  - Patch 3/3
>    - Introduce write_trace_idt_entry() to remove "ifdef CONFIG_TRACING"
>      from _set_gate().
>    - Change DEFINE_IRQ_VECTOR_EVENT to save on repeat code.
>    - Add a path of irq_vector.h to Makefile.
>    - Introduce current_idt_descr_ptr and load_current_idt() to switch
>      IDT in a generic way with handling Debug traps/NMI and cpu hotplug.
> 
>  v11 -> v12
>  - Rebase to 3.9-rc5
> 
>  v10 -> v11
>  - Rebase to 3.9-rc2
>  - Add a modification for hyperv_callback vector. (patch 2/3)
>  - Change a way to switch idt to check the table in use instead of saving/restoring it,
>    because saving/restoring functions will break if we have to add another one. (patch 2/3)
> 
>  v9 -> v10
>  - Add an explanation the reason why tracepoints has to place inside irq enter/exit handling. (patch 3/3)
> 
>  v8 -> v9
>  - Rebase to 3.8-rc6
>  - Add Steven's email address at the top of the message and
>    move my signed-off-by below Steven's one because it is
>    originally created by Steven. (patch 1/3)
>  - Introduce a irq_vector_mutex to avoid a race at registering/unregistering
>    time. (patch 2/3)
>  - Use a per_cpu data to orig_idt_descr because IDT descritor is needed to each cpu
>    and the appropriate data type is per_cpu data. It is suggested by Steven.
>    (patch 2/3)
> 
>  v7 -> v8
>  - Rebase to 3.8-rc4
>  - Add a patch 1 introducing DEFINE_EVENT_FN() macro.
>  - Rename original patches 1 and 2 to 2 and 3.
>  - Change a definition of tracepoint to use DEFINE_EVENT_FN(). (patch 2)
>  - Change alloc_intr_gate() to use do{}while(0) to avoid a warning
>    of checkpatch.pl. (patch 2)
>  - Move entering_irq()/exiting_irq() to arch/x86/include/asm/apic.h (patch 3)
> 
>  v6 -> v7
>  - Divide into two patches to make a code review easier.
>    Summery of each patch is as follows.
>     - Patch 1/2
>       - Add an irq_vector tracing infrastructure.
>       - Create idt_table for tracing. It is refactored to avoid duplicating
>         existing logic.
>       - Duplicate new irq handlers inserted tracepoints.
> 
>     - Patch 2/2
>       - Share a common logic among irq handlers to make them
>         manageable and readable.
> 
>  v5 -> v6
>  - Rebased to 3.7
> 
>  v4 -> v5
>  - Rebased to 3.6.0
> 
>  - Introduce a logic switching IDT at enabling/disabling TP time
>    so that a time penalty makes a zero when tracepoints are disabled.
>    This IDT is created only when CONFIG_TRACEPOINTS is enabled.
> 
>  - Remove arch_irq_vector_entry/exit and add followings again
>    so that we can add each tracepoint in a generic way.
>    - error_apic_vector
>    - thermal_apic_vector
>    - threshold_apic_vector
>    - spurious_apic_vector
>    - x86_platform_ipi_vector
> 
>  - Drop nmi tracepoints to begin with apic interrupts and discuss a logic switching
>    IDT first.
> 
>  - Move irq_vectors.h in the directory of arch/x86/include/asm/trace because
>    I'm not sure if a logic switching IDT is sharable with other architectures.
> 
>  v3 -> v4
>  - Add a latency measurement of each tracepoint
>  - Rebased to 3.6-rc6
> 
>  v2 -> v3
>  - Remove an invalidate_tlb_vector event because it was replaced by a call function vector
>    in a following commit.
>    http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=52aec3308db85f4e9f5c8b9f5dc4fbd0138c6fa4
> 
>  v1 -> v2
>  - Modify variable name from irq to vector.
>  - Merge arch-specific tracepoints below to an arch_irq_vector_entry/exit.
>    - error_apic_vector
>    - thermal_apic_vector
>    - threshold_apic_vector
>    - spurious_apic_vector
>    - x86_platform_ipi_vector
> 
> [Purpose of this patch]
> 
> As Vaibhav explained in the thread below, tracepoints for irq vectors are useful.
> 
> http://www.spinics.net/lists/mm-commits/msg85707.html
> 
> <snip>
> The current interrupt traces from irq_handler_entry and irq_handler_exit provide
> when an interrupt is handled.
> They provide good data about when the system has switched to kernel space and
> how it affects the currently running processes.
> 
> There are some IRQ vectors which trigger the system into kernel space, which are
> not handled in generic IRQ handlers.
> Tracing such events gives us the information about IRQ interaction with other
> system events.
> 
> The trace also tells where the system is spending its time.  We want to know which
> cores are handling interrupts and
> how they are affecting other processes in the system.  Also, the trace provides
> information about when the cores are
> idle and which interrupts are changing that state.
> <snip>
> 
> On the other hand, my usecase is tracing just local timer event and getting
>  a value of instruction pointer.
> 
> I suggested to add an argument local timer event to get instruction pointer before.
> But there is another way to get it with external module like systemtap.
> So, I don't need to add any argument to irq vector tracepoints now.
> 
> [Patch Description]
> 
> Vaibhav's patch shared a trace point ,irq_vector_entry/irq_vector_exit, in all events.
> But there is an above use case to trace specific irq_vector rather than tracing all events.
> In this case, we are concerned about overhead due to unwanted events.
> 
> This patch adds following tracepoints instead of introducing irq_vector_entry/exit.
> so that we can enable them independently.
>    - local_timer_vector
>    - reschedule_vector
>    - call_function_vector
>    - call_function_single_vector
>    - irq_work_entry_vector
>    - error_apic_vector
>    - thermal_apic_vector
>    - threshold_apic_vector
>    - spurious_apic_vector
>    - x86_platform_ipi_vector
> 
> Seiji Aguchi (3):
>   trace,x86: Introduce entering/exiting_irq()
>   x86: Rename variables for debugging
>   trace,x86: Add irq vector tracepoints
> 
> Steven Rostedt (1):
>   tracing: Add DEFINE_EVENT_FN() macro
> 
>  arch/x86/include/asm/apic.h              |   27 +++++++
>  arch/x86/include/asm/desc.h              |  119 ++++++++++++++++++++++++++++-
>  arch/x86/include/asm/entry_arch.h        |    8 +-
>  arch/x86/include/asm/hw_irq.h            |   17 ++++
>  arch/x86/include/asm/mshyperv.h          |    1 +
>  arch/x86/include/asm/trace/irq_vectors.h |  104 ++++++++++++++++++++++++++
>  arch/x86/kernel/Makefile                 |    1 +
>  arch/x86/kernel/apic/Makefile            |    1 +
>  arch/x86/kernel/apic/apic.c              |   71 +++++++++++++++---
>  arch/x86/kernel/cpu/common.c             |   20 +++---
>  arch/x86/kernel/cpu/mcheck/therm_throt.c |   24 +++++--
>  arch/x86/kernel/cpu/mcheck/threshold.c   |   24 +++++--
>  arch/x86/kernel/entry_32.S               |   12 +++-
>  arch/x86/kernel/entry_64.S               |   31 ++++++--
>  arch/x86/kernel/head_64.S                |    8 ++-
>  arch/x86/kernel/irq.c                    |   31 +++++---
>  arch/x86/kernel/irq_work.c               |   24 ++++++-
>  arch/x86/kernel/smp.c                    |   65 ++++++++++++++--
>  arch/x86/kernel/tracepoint.c             |   57 ++++++++++++++
>  arch/x86/kernel/traps.c                  |    2 +-
>  include/linux/tracepoint.h               |    2 +
>  include/trace/define_trace.h             |    5 +
>  include/trace/ftrace.h                   |    4 +
>  include/xen/events.h                     |    3 +
>  24 files changed, 589 insertions(+), 72 deletions(-)
>  create mode 100644 arch/x86/include/asm/trace/irq_vectors.h
>  create mode 100644 arch/x86/kernel/tracepoint.c
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
