Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105AbaFCSXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 14:23:41 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:57377 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755067AbaFCSXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 14:23:35 -0400
Date: Tue, 3 Jun 2014 20:23:29 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Arun Sharma <asharma@fb.com>, David Ahern <dsahern@gmail.com>,
        Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL 00/27] perf/core improvements and fixes
Message-ID: <20140603182329.GB5097@gmail.com>
References: <1401629498-8726-1-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401629498-8726-1-git-send-email-jolsa@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@kernel.org> wrote:

> hi Ingo,
> please consider pulling
> 
> thanks,
> jirka
> 
> 
> The following changes since commit e450f90e8c7d0bf70519223c1b848446ae63f313:
> 
>   Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf into perf/core (2014-05-22 11:37:40 +0200)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git tags/perf-core-for-mingo
> 
> for you to fetch changes up to 0506aecce999d4370b979892f88cf1118cfe8dcb:
> 
>   perf tests: Add a test case for cumulating callchains (2014-06-01 14:35:11 +0200)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes:
> 
> . Add support to accumulate hist periods (Namhyung Kim)
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> 
> ----------------------------------------------------------------
> Namhyung Kim (27):
>       perf tools: Introduce hists__inc_nr_samples()
>       perf tools: Introduce struct hist_entry_iter
>       perf hists: Add support for accumulated stat of hist entry
>       perf hists: Check if accumulated when adding a hist entry
>       perf hists: Accumulate hist entry stat based on the callchain
>       perf tools: Update cpumode for each cumulative entry
>       perf report: Cache cumulative callchains
>       perf callchain: Add callchain_cursor_snapshot()
>       perf tools: Save callchain info for each cumulative entry
>       perf ui/hist: Add support to accumulated hist stat
>       perf ui/browser: Add support to accumulated hist stat
>       perf ui/gtk: Add support to accumulated hist stat
>       perf tools: Apply percent-limit to cumulative percentage
>       perf tools: Add more hpp helper functions
>       perf report: Add --children option
>       perf report: Add report.children config option
>       perf tools: Do not auto-remove Children column if --fields given
>       perf tools: Add callback function to hist_entry_iter
>       perf top: Convert to hist_entry_iter
>       perf top: Add --children option
>       perf top: Add top.children config option
>       perf tools: Enable --children option by default
>       perf ui/stdio: Fix invalid percentage value of cumulated hist entries
>       perf ui/gtk: Fix callchain display
>       perf tools: Reset output/sort order to default
>       perf tests: Define and use symbolic names for fake symbols
>       perf tests: Add a test case for cumulating callchains
> 
>  tools/perf/Documentation/perf-report.txt |   7 +-
>  tools/perf/Documentation/perf-top.txt    |   8 +-
>  tools/perf/Makefile.perf                 |   1 +
>  tools/perf/builtin-annotate.c            |   5 +-
>  tools/perf/builtin-diff.c                |   2 +-
>  tools/perf/builtin-report.c              | 210 +++------
>  tools/perf/builtin-sched.c               |   2 +-
>  tools/perf/builtin-top.c                 |  90 ++--
>  tools/perf/tests/builtin-test.c          |   4 +
>  tools/perf/tests/hists_common.c          |  52 ++-
>  tools/perf/tests/hists_common.h          |  32 +-
>  tools/perf/tests/hists_cumulate.c        | 726 +++++++++++++++++++++++++++++++
>  tools/perf/tests/hists_filter.c          |  39 +-
>  tools/perf/tests/hists_link.c            |  36 +-
>  tools/perf/tests/hists_output.c          |  31 +-
>  tools/perf/tests/tests.h                 |   1 +
>  tools/perf/ui/browsers/hists.c           |  65 +--
>  tools/perf/ui/gtk/hists.c                |  33 +-
>  tools/perf/ui/hist.c                     | 119 +++++
>  tools/perf/ui/stdio/hist.c               |   8 +-
>  tools/perf/util/callchain.c              |  45 +-
>  tools/perf/util/callchain.h              |  11 +
>  tools/perf/util/hist.c                   | 481 +++++++++++++++++++-
>  tools/perf/util/hist.h                   |  49 ++-
>  tools/perf/util/sort.c                   |   4 +
>  tools/perf/util/sort.h                   |  18 +-
>  tools/perf/util/symbol.c                 |  11 +-
>  tools/perf/util/symbol.h                 |   1 +
>  28 files changed, 1768 insertions(+), 323 deletions(-)
>  create mode 100644 tools/perf/tests/hists_cumulate.c

Pulled, thanks a lot Jiri!

	Ingo
