Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbaDVIub (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 04:50:31 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:62666 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbaDVIt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 04:49:56 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCHSET 0/9] perf tools: Fixup for the --percentage change
Date: Tue, 22 Apr 2014 17:49:42 +0900
Message-Id: <1398156591-11001-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset tries to fix bugs in percentage handling which is
recently changed.  The perf top with symbol filter could cause a
segfault (NULL pointer dereference) if the filter found no entry.

In this patchset, I moved accounting of various histogram stats to be
calculated at the time it actually shown to users.  Although I tested
it on my system for a while, it needs more testing since it'll affect
behaviors of many commands/usages.

It's available at 'perf/percentage-v10' branch on my tree:

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git

Any comments, review and testing are welcomed.

Thanks,
Namhyung


Namhyung Kim (9):
  perf report: Count number of entries and samples separately
  perf hists: Introduce hists__add_nr_events()
  perf tools: Account entry stats when it's added to the output tree
  perf tools: Introduce hists__inc_dump_events()
  perf hists: Add missing update on nr_non_filtered_entries
  perf ui/tui: Fix off-by-one in hist_browser__update_nr_entries()
  perf ui/tui: Rename hist_browser__update_nr_entries()
  perf top/tui: Update nr_entries properly after a filter is applied
  perf hists/tui: Count callchain rows separately

 tools/perf/builtin-annotate.c  | 27 ++++++--------
 tools/perf/builtin-report.c    | 51 +++++++++++++-------------
 tools/perf/builtin-top.c       |  4 ---
 tools/perf/ui/browsers/hists.c | 81 ++++++++++++++++++++++++++++--------------
 tools/perf/util/hist.c         | 53 ++++++++++++++++++++-------
 tools/perf/util/hist.h         |  7 ++++
 6 files changed, 137 insertions(+), 86 deletions(-)

-- 
1.9.2

