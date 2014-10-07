Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbaJGEyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 00:54:20 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:39174 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbaJGEyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 00:54:18 -0400
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Tue, 7 Oct 2014 01:00:40 -0400 (EDT)
To: Mark Rutland <mark.rutland@arm.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: Perf lockups / stack overflows on v3.17-rc6, x86_64, arm,
 arm64
In-Reply-To: <20141006143431.GA21565@leverpostej>
Message-ID: <alpine.DEB.2.11.1410070059120.16000@vincent-weaver-1.umelst.maine.edu>
References: <20140925152825.GA6531@leverpostej> <alpine.DEB.2.11.1410050106360.9898@vincent-weaver-1.umelst.maine.edu> <20141006095931.GB24686@leverpostej> <20141006143431.GA21565@leverpostej>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Oct 2014, Mark Rutland wrote:

> So far I haven't been able to trigger the above failure on v3.17, so perhaps
> some patch has fixed that.
> 
> With the same seed (1411654897) I can trigger a hw_breakpoint warning
> relatively repeatably (logs for a couple of instances below).

I see those fairly frequently too.  Adding some breakpoint people to
the CC and maybe they can help debug it.

Vince


> ---->8----
> [ 3268.694056] ------------[ cut here ]------------
> [ 3268.694066] WARNING: CPU: 0 PID: 19671 at arch/x86/kernel/hw_breakpoint.c:119 arch_install_hw_breakpoint+0xf0/0x100()
> [ 3268.694068] Can't find any breakpoint slot
> [ 3268.694070] Modules linked in:
> [ 3268.694075] CPU: 0 PID: 19671 Comm: perf_fuzzer Not tainted 3.17.0hark-lockup2-2014-10-06 #4
> [ 3268.694077] Hardware name: LENOVO 7484A3G/LENOVO, BIOS 5CKT54AUS 09/07/2009
> [ 3268.694079]  0000000000000009 ffff88019a343c78 ffffffff8182da5c ffff88019a343cc0
> [ 3268.694084]  ffff88019a343cb0 ffffffff8104af38 ffff8801af5ec800 ffff8801a0faae00
> [ 3268.694088]  ffff8801bec16780 ffff8801bec16784 000001b8c35e3e18 ffff88019a343d10
> [ 3268.694092] Call Trace:
> [ 3268.694098]  [<ffffffff8182da5c>] dump_stack+0x45/0x56
> [ 3268.694103]  [<ffffffff8104af38>] warn_slowpath_common+0x78/0xa0
> [ 3268.694106]  [<ffffffff8104afa7>] warn_slowpath_fmt+0x47/0x50
> [ 3268.694110]  [<ffffffff8100a720>] arch_install_hw_breakpoint+0xf0/0x100
> [ 3268.694114]  [<ffffffff8111101f>] hw_breakpoint_add+0x3f/0x50
> [ 3268.694117]  [<ffffffff8110b3d4>] event_sched_in.isra.80+0x84/0x1b0
> [ 3268.694121]  [<ffffffff8110b569>] group_sched_in+0x69/0x1e0
> [ 3268.694124]  [<ffffffff8110c5cb>] ? perf_event_update_userpage+0xeb/0x160
> [ 3268.694129]  [<ffffffff8107568d>] ? sched_clock_local+0x1d/0x80
> [ 3268.694132]  [<ffffffff8110b7b2>] ctx_sched_in.isra.81+0xd2/0x1a0
> [ 3268.694136]  [<ffffffff8110b8cf>] perf_event_sched_in.isra.84+0x4f/0x70
> [ 3268.694139]  [<ffffffff8110bac3>] perf_event_context_sched_in.isra.85+0x73/0xc0
> [ 3268.694142]  [<ffffffff8110c175>] __perf_event_task_sched_in+0x185/0x1a0
> [ 3268.694147]  [<ffffffff8106c832>] finish_task_switch+0xb2/0xf0
> [ 3268.694151]  [<ffffffff818339bf>] __schedule+0x34f/0x810
> [ 3268.694154]  [<ffffffff81833ea4>] schedule+0x24/0x70
> [ 3268.694158]  [<ffffffff818395d1>] int_careful+0xd/0x14
> [ 3268.694160] ---[ end trace e1f62407a7d7e846 ]---
> ---->8----
> 
> ---->8----
> [ 4016.924076] ------------[ cut here ]------------
> [ 4016.925039] WARNING: CPU: 1 PID: 14091 at arch/x86/kernel/hw_breakpoint.c:119 arch_install_hw_breakpoint+0xf0/0x100()
> [ 4016.925039] Can't find any breakpoint slot
> [ 4016.925039] Modules linked in:
> [ 4016.925039] CPU: 1 PID: 14091 Comm: perf_fuzzer Not tainted 3.17.0hark-lockup2-2014-10-06 #4
> [ 4016.925039] Hardware name: LENOVO 7484A3G/LENOVO, BIOS 5CKT54AUS 09/07/2009
> [ 4016.925039]  0000000000000009 ffff8800cd85f9a8 ffffffff8182da5c ffff8800cd85f9f0
> [ 4016.925039]  ffff8800cd85f9e0 ffffffff8104af38 ffff8800e38bd000 ffff8801a6fb1c00
> [ 4016.925039]  ffff8801bec96780 ffff8801bec96784 0000027400d480df ffff8800cd85fa40
> [ 4016.925039] Call Trace:
> [ 4016.925039]  [<ffffffff8182da5c>] dump_stack+0x45/0x56
> [ 4016.925039]  [<ffffffff8104af38>] warn_slowpath_common+0x78/0xa0
> [ 4016.925039]  [<ffffffff8104afa7>] warn_slowpath_fmt+0x47/0x50
> [ 4016.925039]  [<ffffffff8100a720>] arch_install_hw_breakpoint+0xf0/0x100
> [ 4016.925039]  [<ffffffff8111101f>] hw_breakpoint_add+0x3f/0x50
> [ 4016.925039]  [<ffffffff8110b3d4>] event_sched_in.isra.80+0x84/0x1b0
> [ 4016.925039]  [<ffffffff8110b569>] group_sched_in+0x69/0x1e0
> [ 4016.925039]  [<ffffffff8110c5cb>] ? perf_event_update_userpage+0xeb/0x160
> [ 4016.925039]  [<ffffffff8107568d>] ? sched_clock_local+0x1d/0x80
> [ 4016.925039]  [<ffffffff8110b7b2>] ctx_sched_in.isra.81+0xd2/0x1a0
> [ 4016.925039]  [<ffffffff8110b8cf>] perf_event_sched_in.isra.84+0x4f/0x70
> [ 4016.925039]  [<ffffffff8110bac3>] perf_event_context_sched_in.isra.85+0x73/0xc0
> [ 4016.925039]  [<ffffffff8110c175>] __perf_event_task_sched_in+0x185/0x1a0
> [ 4016.925039]  [<ffffffff8106c832>] finish_task_switch+0xb2/0xf0
> [ 4016.925039]  [<ffffffff818339bf>] __schedule+0x34f/0x810
> [ 4016.925039]  [<ffffffff81833ea4>] schedule+0x24/0x70
> [ 4016.925039]  [<ffffffff81837ca9>] schedule_timeout+0x1b9/0x290
> [ 4016.925039]  [<ffffffff81835113>] ? wait_for_completion+0x23/0x100
> [ 4016.925039]  [<ffffffff8183518c>] wait_for_completion+0x9c/0x100
> [ 4016.925039]  [<ffffffff81072800>] ? wake_up_state+0x10/0x10
> [ 4016.925039]  [<ffffffff8109e7f0>] ? call_rcu_bh+0x20/0x20
> [ 4016.925039]  [<ffffffff8109c766>] wait_rcu_gp+0x46/0x50
> [ 4016.925039]  [<ffffffff8109c710>] ? ftrace_raw_output_rcu_utilization+0x50/0x50
> [ 4016.925039]  [<ffffffff8109ee93>] synchronize_sched+0x33/0x50
> [ 4016.925039]  [<ffffffff810f9fab>] perf_trace_event_unreg.isra.1+0x3b/0x90
> [ 4016.925039]  [<ffffffff810fa318>] perf_trace_destroy+0x38/0x50
> [ 4016.925039]  [<ffffffff81106d99>] tp_perf_event_destroy+0x9/0x10
> [ 4016.925039]  [<ffffffff81108523>] __free_event+0x23/0x70
> [ 4016.925039]  [<ffffffff8110f057>] SYSC_perf_event_open+0x397/0xa50
> [ 4016.925039]  [<ffffffff8110fad9>] SyS_perf_event_open+0x9/0x10
> [ 4016.925039]  [<ffffffff81839550>] tracesys+0xdd/0xe2
> [ 4016.925039] ---[ end trace a2fe478e9cb5649b ]---
> ---->8----
