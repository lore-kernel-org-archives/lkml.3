Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbaBTBAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 20:00:22 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:51792 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbaBTBAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 20:00:20 -0500
X-AuditID: 9c93016f-b7c65ae000004a2a-07-530553a1d62d
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCHSET 0/8] perf tools: Update on filtered entries' percentage output (v4)
In-Reply-To: <1392000446-14744-1-git-send-email-namhyung@kernel.org> (Namhyung
	Kim's message of "Mon, 10 Feb 2014 11:47:17 +0900")
References: <1392000446-14744-1-git-send-email-namhyung@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
Date: Thu, 20 Feb 2014 10:00:17 +0900
Message-ID: <87txbuwqce.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping!

On Mon, 10 Feb 2014 11:47:17 +0900, Namhyung Kim wrote:
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
> original value before and after the filter applied.  In patch 5, I
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
>  * changes in v4:
>   - support perf top and perf diff also  (Jiri)
>   - add HIST_FILTER__HOST/GUEST  (Jiri)
>   - retain both of filtered and total stats  (Arnaldo)
>   - add 'F' hotkey on TUI  (Jiri)
>   - rename config variable to have "hist." prefix
>
>
> You can get this on the 'perf/percentage-v4' branch in my tree
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git
>
> Any comments are welcome, thanks
> Namhyung
>
>
> Namhyung Kim (8):
>   perf tools: Count periods of filtered entries separately
>   perf hists: Add support for showing relative percentage
>   perf report: Add --percentage option
>   perf top: Add --percentage option
>   perf diff: Add --percentage option
>   perf tools: Add hist.percentage config option
>   perf ui/tui: Add 'F' hotkey to toggle percentage output
>   perf tools: Show absolute percentage by default
>
>  tools/perf/Documentation/perf-diff.txt   | 21 +++++++++--
>  tools/perf/Documentation/perf-report.txt | 24 +++++++++----
>  tools/perf/Documentation/perf-top.txt    | 18 ++++++++--
>  tools/perf/builtin-diff.c                | 48 +++++++++++++++++++++----
>  tools/perf/builtin-report.c              | 32 +++++++++++++++--
>  tools/perf/builtin-top.c                 | 16 +++++++++
>  tools/perf/ui/browsers/hists.c           | 61 ++++++++++++++++++++++++++------
>  tools/perf/ui/gtk/hists.c                | 27 +++++++++-----
>  tools/perf/ui/hist.c                     | 12 +++++--
>  tools/perf/util/config.c                 |  4 +++
>  tools/perf/util/event.c                  | 22 ++++++------
>  tools/perf/util/hist.c                   | 52 ++++++++++++++++-----------
>  tools/perf/util/hist.h                   | 15 ++++++++
>  tools/perf/util/symbol.h                 |  5 +--
>  14 files changed, 278 insertions(+), 79 deletions(-)
