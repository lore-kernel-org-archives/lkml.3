Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242AbaDXPlK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 11:41:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758203AbaDXPlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 11:41:01 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@kernel.org>
Subject: [GIT PULL 00/11] perf/core improvements and fixes
Date: Thu, 24 Apr 2014 17:40:34 +0200
Message-Id: <1398354045-16505-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Ingo,
please consider pulling

thanks,
jirka


The following changes since commit a81fef347b32dea2b31275826afe1c93fa0d2d54:

  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf into perf/core (2014-04-22 20:28:23 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git tags/perf-core-for-mingo

for you to fetch changes up to c3b789527b236873557f53740ceac47747e0e1cb:

  perf hists/tui: Count callchain rows separately (2014-04-24 16:34:27 +0200)

----------------------------------------------------------------
perf/core improvements and fixes:

. Factor hists statistics counts processing which in turn also
  fixes several bugs in TUI report command (Namhyung Kim)

Signed-off-by: Jiri Olsa <jolsa@kernel.org>

----------------------------------------------------------------
Namhyung Kim (11):
      perf report: Count number of entries separately
      perf hists: Rename hists__inc_stats()
      perf hists: Move column length calculation out of hists__inc_stats()
      perf hists: Add a couple of hists stat helper functions
      perf hists: Collapse expanded callchains after filter is applied
      perf tools: Account entry stats when it's added to the output tree
      perf hists: Add missing update on filtered stats in hists__decay_entries()
      perf ui/tui: Fix off-by-one in hist_browser__update_nr_entries()
      perf ui/tui: Rename hist_browser__update_nr_entries()
      perf top/tui: Update nr_entries properly after a filter is applied
      perf hists/tui: Count callchain rows separately

 tools/perf/builtin-annotate.c  |  3 +-
 tools/perf/builtin-diff.c      | 23 ++++++-----
 tools/perf/builtin-report.c    | 64 ++++++++++++++---------------
 tools/perf/ui/browsers/hists.c | 92 +++++++++++++++++++++++++++++-------------
 tools/perf/util/hist.c         | 83 ++++++++++++++++++++++++-------------
 tools/perf/util/hist.h         |  9 ++++-
 6 files changed, 171 insertions(+), 103 deletions(-)
