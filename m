Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407AbaCQIF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 04:05:29 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:63787 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175AbaCQIF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 04:05:26 -0400
X-AuditID: 9c93017d-b7c89ae000006ae1-08-5326acc49965
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCHSET 0/9] perf tools: Update on filtered entries' percentage output (v7)
In-Reply-To: <1394437440-11609-1-git-send-email-namhyung@kernel.org> (Namhyung
	Kim's message of "Mon, 10 Mar 2014 16:43:51 +0900")
References: <1394437440-11609-1-git-send-email-namhyung@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
Date: Mon, 17 Mar 2014 17:05:24 +0900
Message-ID: <87r461s117.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping!

On Mon, 10 Mar 2014 16:43:51 +0900, Namhyung Kim wrote:
> Hello,
>
> I added --percentage option to perf report to control display of
> percentage of filtered entries.
>
>  usage: perf report [<options>]
>
>         --percentage <relative|absolute>
>                           how to display percentage of filtered entries
>
> "relative" means it's relative to filtered entries only so that the
> sum of shown entries will be always 100%.  "absolute" means it retains
> original value before and after the filter applied.  In patch 9/9, I
> made the "absolute" as default since it makes more sense IMHO.
>     
>       $ perf report -s comm
>       # Overhead       Command
>       # ........  ............
>       #
>           74.19%           cc1
>            7.61%           gcc
>            6.11%            as
>            4.35%            sh
>            4.14%          make
>            1.13%        fixdep
>       ...
>     
>       $ perf report -s comm -c cc1,gcc --percentage absolute
>       # Overhead       Command
>       # ........  ............
>       #
>           74.19%           cc1
>            7.61%           gcc
>     
>       $ perf report -s comm -c cc1,gcc --percentage relative
>       # Overhead       Command
>       # ........  ............
>       #
>           90.69%           cc1
>            9.31%           gcc
>     
> Note that it has zero effect if no filter was applied.
>
>  * changes in v7:
>   - rename ->nr_filtered_* to ->nr_non_filtered_* (Arnaldo)
>   - remove an unneeded alignment change (Arnaldo)
>
>  * changes in v6:
>   - fix a bug in --stdio group report
>   - reuse __hpp__fmt() function in TUI/GTK
>   - add Acked-by from Jiri
>
>  * changes in v5:
>   - fix 0 samples in relative percent output (Jiri)
>   - factor hists__total_period function (Jiri)
>   - share config parsing code with option parser (Jiri)
>
>  * changes in v4:
>   - support perf top and perf diff also  (Jiri)
>   - add HIST_FILTER__HOST/GUEST  (Jiri)
>   - retain both of filtered and total stats  (Arnaldo)
>   - add 'F' hotkey on TUI  (Jiri)
>   - rename config variable to have "hist." prefix
>
>
> You can get this on the 'perf/percentage-v7' branch in my tree
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git
>
> Any comments are welcome, thanks
> Namhyung
>
>
> Namhyung Kim (9):
>   perf tools: Pass evsel to hpp->header/width functions explicitly
>   perf tools: Count periods of filtered entries separately
>   perf hists: Add support for showing relative percentage
>   perf report: Add --percentage option
>   perf top: Add --percentage option
>   perf diff: Add --percentage option
>   perf tools: Add hist.percentage config option
>   perf ui/tui: Add 'F' hotkey to toggle percentage output
>   perf tools: Show absolute percentage by default
>
>  tools/perf/Documentation/perf-diff.txt   | 21 ++++++++--
>  tools/perf/Documentation/perf-report.txt | 24 ++++++++---
>  tools/perf/Documentation/perf-top.txt    | 18 +++++++--
>  tools/perf/builtin-diff.c                | 39 ++++++++++++------
>  tools/perf/builtin-report.c              | 24 +++++++++--
>  tools/perf/builtin-top.c                 |  2 +
>  tools/perf/ui/browsers/hists.c           | 39 ++++++++++++++----
>  tools/perf/ui/gtk/hists.c                | 14 +++----
>  tools/perf/ui/hist.c                     | 32 +++++++--------
>  tools/perf/ui/stdio/hist.c               |  5 +--
>  tools/perf/util/config.c                 |  4 ++
>  tools/perf/util/event.c                  | 22 +++++------
>  tools/perf/util/hist.c                   | 68 ++++++++++++++++++++++----------
>  tools/perf/util/hist.h                   | 25 +++++++++++-
>  tools/perf/util/symbol.h                 |  5 ++-
>  15 files changed, 242 insertions(+), 100 deletions(-)
