Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751340AbaKDFln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 00:41:43 -0500
Received: from lgeamrelo04.lge.com ([156.147.1.127]:46224 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbaKDFlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 00:41:42 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: kan.liang@intel.com
Cc: acme@kernel.org, jolsa@kernel.org, linux-kernel@vger.kernel.org,
        andi@firstfloor.org
Subject: Re: [PATCH 1/1] perf tools: perf diff for different binaries
References: <1414757172-20064-1-git-send-email-kan.liang@intel.com>
Date: Tue, 04 Nov 2014 14:41:39 +0900
In-Reply-To: <1414757172-20064-1-git-send-email-kan.liang@intel.com> (kan
	liang's message of "Fri, 31 Oct 2014 05:06:12 -0700")
Message-ID: <87tx2f5xpo.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi kan,

On Fri, 31 Oct 2014 05:06:12 -0700, kan liang wrote:
> From: Kan Liang <kan.liang@intel.com>
>
> perf diff can display the differential profile between two perf.data
> files. However, the perf.data files have to come from same binaries.
>
> The patch introduced a key "symbol_name" for --sort option, so the user
> can compare the perf.data files from different binaries, even different
> kernel version. If symbol_name is set, perf diff display the
> differential profile of functions.
> It could help the user quickly locate the scaling regression caused by
> new binaries/kernels.
>
> Here is an example. I have two version of binaries. One is running on
> kernel 3.16. The other is running on kernel 3.17.
>
> Using perf record, I got two perf.data files, v1_1_6perf.data (version
> one in 3.16) and v2_1_7perf.data (version two in 3.17).
>
> If I run old perf diff with --sort dso,symbol, we cannot get any useful
> information for the user space binary. Furthermore, it failed to compare
> the kernel function. E.g. native_write_msr_safe.
>
> perf diff -s dso,symbol --compute ratio v1_1_6perf.data v2_1_7perf.data
>
>  Event 'cycles'
>
>  Baseline           Ratio  Shared Object      Symbol
>  ........  ..............  .................
> ....................................
>
>                             [kernel.kallsyms]  [k]
> __update_entity_load_avg_contrib
>                             [kernel.kallsyms]  [k] _raw_spin_lock
>                             [kernel.kallsyms]  [k] apic_timer_interrupt
>                             [kernel.kallsyms]  [k] hrtimer_interrupt
>      0.01%                  [kernel.kallsyms]  [k] native_write_msr_safe
>                             [kernel.kallsyms]  [k] native_write_msr_safe
>      0.01%                  [kernel.kallsyms]  [k] notifier_call_chain
>      0.01%                  [kernel.kallsyms]  [k] perf_event_task_tick
>      0.01%                  [kernel.kallsyms]  [k] run_posix_cpu_timers
>      0.01%                  [kernel.kallsyms]  [k] run_timer_softirq
>      0.01%                  [kernel.kallsyms]  [k] trigger_load_balance
>      0.01%                  [kernel.kallsyms]  [k] update_vsyscall
>      0.05%                  [unknown]          [.] 0x0000000000400540
>      0.04%                  [unknown]          [.] 0x0000000000400541
>      0.03%                  [unknown]          [.] 0x000000000040054b
>      0.04%                  [unknown]          [.] 0x0000000000400552
>     33.55%                  [unknown]          [.] 0x0000000000400554
>      1.22%                  [unknown]          [.] 0x000000000040055a
>      8.00%                  [unknown]          [.] 0x000000000040055e
>      0.02%                  [unknown]          [.] 0x0000000000400562
>      8.41%                  [unknown]          [.] 0x0000000000400564
>     48.13%                  [unknown]          [.] 0x000000000040056b
>      0.16%                  [unknown]          [.] 0x0000000000400570
>      0.17%                  [unknown]          [.] 0x0000000000400571
>                             [unknown]          [.] 0x0000000000400580
>                             [unknown]          [.] 0x0000000000400581
>      0.01%                  [unknown]          [.] 0x0000000000400583
>      0.01%                  [unknown]          [.] 0x0000000000400588
>                             [unknown]          [.] 0x000000000040058b
>      0.01%     1240.990221  [unknown]          [.] 0x000000000040058d
>                             [unknown]          [.] 0x0000000000400590
>      0.06%                  [unknown]          [.] 0x0000000000400591
>                             [unknown]          [.] 0x0000000000400593
>      0.04%                  [unknown]          [.] 0x0000000000400595
>      0.01%     1240.603148  [unknown]          [.] 0x0000000000400597
>                             [unknown]          [.] 0x000000000040059b
>                             [unknown]          [.] 0x000000000040059d
>                             [unknown]          [.] 0x00000000004005a1
>                             [unknown]          [.] 0x00000000004005a5
>                             [unknown]          [.] 0x00000000004005a7
>                             [unknown]          [.] 0x00000000004005a8
>                             [unknown]          [.] 0x00000000004005aa
>                             [unknown]          [.] 0x00000000004005ba
>                             [unknown]          [.] 0x00000000004005bf
>                             [unknown]          [.] 0x00000000004005c4
>                             [unknown]          [.] 0x00000000004005c9
>                             [unknown]          [.] 0x00000000004005ce
>                             [unknown]          [.] 0x00000000004005d2
>                             [unknown]          [.] 0x00000000004005d6
>                             [unknown]          [.] 0x00000000004005d8
>                             [unknown]          [.] 0x00000000004005f5
>
> With the key "symbol_name", we can easily get the differential profile
> from different binary versions and different kernel versions.
>
> ./perf diff -s dso,symbol_name --compute ratio v1_1_6perf.data v2_1_7perf.data
>
>  Event 'cycles'
>
>  Baseline           Ratio  Shared Object      Symbol Name
>  ........  ..............  .................
> ....................................
>
>                             [kernel.kallsyms]  [k]
> __update_entity_load_avg_contrib
>                             [kernel.kallsyms]  [k] _raw_spin_lock
>                             [kernel.kallsyms]  [k] apic_timer_interrupt
>                             [kernel.kallsyms]  [k] hrtimer_interrupt
>      0.01%        1.998522  [kernel.kallsyms]  [k] native_write_msr_safe
>      0.01%                  [kernel.kallsyms]  [k] notifier_call_chain
>      0.01%                  [kernel.kallsyms]  [k] perf_event_task_tick
>      0.01%                  [kernel.kallsyms]  [k] run_posix_cpu_timers
>      0.01%                  [kernel.kallsyms]  [k] run_timer_softirq
>      0.01%                  [kernel.kallsyms]  [k] trigger_load_balance
>      0.01%                  [kernel.kallsyms]  [k] update_vsyscall
>                             tchain_edit        [.] f1
>      0.14%        3.913444  tchain_edit        [.] f2
>     99.82%        1.005478  tchain_edit        [.] f3

Hmm.. I think it should be a default behavior for perf diff, otherwise
-s symbol is almost meaningless IMHO.  What about setting the
sort_sym.se_collapse in data_process() so that hists__match() can use
symbol names?

Thanks,
Namhyung
