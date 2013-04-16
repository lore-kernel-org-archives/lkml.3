Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933610Ab3DPJGC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 05:06:02 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:57656 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859Ab3DPJF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 05:05:59 -0400
Date: Tue, 16 Apr 2013 11:05:54 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] uprobes: ret-probes + misc
Message-ID: <20130416090554.GA9569@gmail.com>
References: <20130415160416.GA17826@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130415160416.GA17826@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> Ingo, please pull from
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc uprobes/core
> 
> Mostly uretprobes. "perf probe -x file sym%return" works like kretprobes.
> TODO: longjmp() is not supported, currently we assume that the probed
> function returns, this needs another series.
> 
> Also the powerpc fixes plus a couple of cleanups/optimizations in uprobes
> and trace_uprobes.
> 
> 
> 
> Ananth N Mavinakayanahalli (3):
>       uprobes: Add trap variant helper
>       uprobes/powerpc: Teach uprobes to ignore gdb breakpoints
>       uprobes/powerpc: Remove additional trap instruction check
> 
> Anton Arapov (9):
>       uretprobes: Introduce uprobe_consumer->ret_handler()
>       uretprobes: Reserve the first slot in xol_vma for trampoline
>       uretprobes/x86: Hijack return address
>       uretprobes/powerpc: Hijack return address
>       uretprobes: Return probe entry, prepare_uretprobe()
>       uretprobes: Return probe exit, invoke handlers
>       uretprobes: Limit the depth of return probe nestedness
>       uretprobes: Remove -ENOSYS as return probes implemented
>       uretprobes: Documentation update
> 
> Oleg Nesterov (18):
>       uprobes: Use file_inode()
>       uprobes: Turn copy_opcode() into copy_from_page()
>       uprobes: Change __copy_insn() to use copy_from_page()
>       uprobes: Kill the unnecesary filp != NULL check in __copy_insn()
>       uprobes: Introduce copy_to_page()
>       uprobes: Change write_opcode() to use copy_*page()
>       uprobes/tracing: Kill the pointless task_pt_regs() calls
>       uprobes/tracing: Kill the pointless seq_print_ip_sym() call
>       uprobes/tracing: Kill the pointless local_save_flags/preempt_count calls
>       uprobes/tracing: Generalize struct uprobe_trace_entry_head
>       uprobes/tracing: Introduce uprobe_{trace,perf}_print() helpers
>       uprobes/tracing: Introduce is_ret_probe() and uretprobe_dispatcher()
>       uprobes/tracing: Make uprobe_{trace,perf}_print() uretprobe-friendly
>       uprobes/tracing: Make register_uprobe_event() paths uretprobe-friendly
>       uprobes/tracing: Make seq_printf() code uretprobe-friendly
>       uprobes/tracing: Change create_trace_uprobe() to support uretprobes
>       uprobes/tracing: Don't pass addr=ip to perf_trace_buf_submit()
>       uprobes/perf: Avoid perf_trace_buf_prepare/submit if ->perf_events is empty
> 
>  Documentation/trace/uprobetracer.txt |  114 ++++++++------
>  arch/powerpc/include/asm/uprobes.h   |    1 +
>  arch/powerpc/kernel/uprobes.c        |   29 +++-
>  arch/x86/include/asm/uprobes.h       |    1 +
>  arch/x86/kernel/uprobes.c            |   29 ++++
>  include/linux/uprobes.h              |    8 +
>  kernel/events/uprobes.c              |  300 ++++++++++++++++++++++++++++------
>  kernel/trace/trace.h                 |    5 -
>  kernel/trace/trace_uprobe.c          |  203 +++++++++++++++++-------
>  9 files changed, 526 insertions(+), 164 deletions(-)

Pulled, thanks a lot Oleg!

	Ingo
