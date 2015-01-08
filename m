Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbbAHOml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 09:42:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686AbbAHOmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 09:42:40 -0500
Date: Thu, 8 Jan 2015 15:42:27 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Kan Liang <kan.liang@intel.com>
Subject: Re: [PATCHSET 0/7] perf diff: Fix and improve output ordering (v2)
Message-ID: <20150108144227.GC16094@krava.brq.redhat.com>
References: <1420677949-6719-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420677949-6719-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 09:45:41AM +0900, Namhyung Kim wrote:
> Hello,
> 
> This patchset improves perf diff output to sort by baseline and then
> next columns in turn.  And fix -o/--order option behavior too.
> 
>  * changes in v2)
>   - pass fmt arg to ->cmp, ->collapse, ->sort callbacks (Jiri)
>   - add Acked-by from Jiri
> 
> The patch 1-3 are resend.  The patch 4-5 are preparation and the patch
> 6-7 are the main change.

for the new stuff ^^^ :

Acked-by: Jiri Olsa <jolsa@kernel.org>

thanks,
jirka

> 
> 
> Before:
> 
>   # Baseline/0  Delta/1  Delta/2  Shared Object      Symbol
>   # ..........  .......  .......  .................  ..........................................
>   #
>         32.75%   +0.28%   -0.83%  libc-2.20.so       [.] malloc
>         31.50%   -0.74%   -0.23%  libc-2.20.so       [.] _int_free
>         22.98%   +0.51%   +0.52%  libc-2.20.so       [.] _int_malloc
>          5.70%   +0.28%   +0.30%  libc-2.20.so       [.] free
>          4.38%   -0.21%   +0.25%  a.out              [.] main
>          1.32%   -0.15%   +0.05%  a.out              [.] free@plt
>          1.31%   +0.03%   -0.06%  a.out              [.] malloc@plt
>          0.01%   -0.01%   -0.01%  [kernel.kallsyms]  [k] native_write_msr_safe
>          0.01%                    [kernel.kallsyms]  [k] scheduler_tick
>          0.01%            -0.00%  [kernel.kallsyms]  [k] native_read_msr_safe
>                           +0.01%  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
>                  +0.01%   +0.01%  [kernel.kallsyms]  [k] apic_timer_interrupt
>                           +0.01%  [kernel.kallsyms]  [k] intel_pstate_timer_func
>                  +0.01%           [kernel.kallsyms]  [k] perf_adjust_freq_unthr_context.part.82
>                  +0.01%           [kernel.kallsyms]  [k] read_tsc
>                           +0.01%  [kernel.kallsyms]  [k] timekeeping_update.constprop.8
>     
> After:
> 
>   # Baseline/0  Delta/1  Delta/2  Shared Object      Symbol
>   # ..........  .......  .......  .................  ..........................................
>   #
>         32.75%   +0.28%   -0.83%  libc-2.20.so       [.] malloc
>         31.50%   -0.74%   -0.23%  libc-2.20.so       [.] _int_free
>         22.98%   +0.51%   +0.52%  libc-2.20.so       [.] _int_malloc
>          5.70%   +0.28%   +0.30%  libc-2.20.so       [.] free
>          4.38%   -0.21%   +0.25%  a.out              [.] main
>          1.32%   -0.15%   +0.05%  a.out              [.] free@plt
>          1.31%   +0.03%   -0.06%  a.out              [.] malloc@plt
>          0.01%   -0.01%   -0.01%  [kernel.kallsyms]  [k] native_write_msr_safe
>          0.01%                    [kernel.kallsyms]  [k] scheduler_tick
>          0.01%            -0.00%  [kernel.kallsyms]  [k] native_read_msr_safe
>                  +0.01%   +0.01%  [kernel.kallsyms]  [k] apic_timer_interrupt
>                  +0.01%           [kernel.kallsyms]  [k] read_tsc
>                  +0.01%           [kernel.kallsyms]  [k] perf_adjust_freq_unthr_context.part.82
>                           +0.01%  [kernel.kallsyms]  [k] intel_pstate_timer_func
>                           +0.01%  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
>                           +0.01%  [kernel.kallsyms]  [k] timekeeping_update.constprop.8
> 
> 
> You can get this from 'perf/diff-sort-v2' branch on my tree:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git
> 
> 
> Any comments are welcome, thanks
> Namhyung
> 
> 
> Namhyung Kim (7):
>   perf diff: Fix to sort by baseline field by default
>   perf diff: Get rid of hists__compute_resort()
>   perf diff: Print diff result more precisely
>   perf diff: Introduce fmt_to_data_file() helper
>   perf tools: Pass struct perf_hpp_fmt to its callbacks
>   perf diff: Fix output ordering to honor next column
>   perf diff: Fix -o/--order option behavior
> 
>  tools/perf/builtin-diff.c | 252 +++++++++++++++++++++++++++++++++-------------
>  tools/perf/ui/hist.c      |  12 ++-
>  tools/perf/util/hist.c    |   6 +-
>  tools/perf/util/hist.h    |   9 +-
>  tools/perf/util/sort.c    |  37 ++++++-
>  5 files changed, 232 insertions(+), 84 deletions(-)
> 
> -- 
> 2.1.3
> 
