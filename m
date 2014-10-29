Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933109AbaJ2M4d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 08:56:33 -0400
Received: from mail.kernel.org ([198.145.19.201]:36789 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932773AbaJ2M4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 08:56:31 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Arun Sharma <asharma@fb.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hemant Kumar <hemant@linux.vnet.ibm.com>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@kernel.org>,
        Li Zefan <lizefan@huawei.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Wang Nan <wangnan0@huawei.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/10] perf/urgent fixes
Date: Wed, 29 Oct 2014 10:56:07 -0200
Message-Id: <1414587377-25077-1-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit 1776b10627e486dd431fe72d8d47e5a865cf65d1:

  perf/x86/intel: Revert incomplete and undocumented Broadwell client support (2014-10-29 11:07:58 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-urgent-for-mingo

for you to fetch changes up to 4cdcc33db2f0455f297b4e14e434ba311ec5ca06:

  perf probe: Trivial typo fix for --demangle (2014-10-29 10:30:18 -0200)

----------------------------------------------------------------
perf/urgent fixes:

User visible:

* Fix report -F (abort, in_tx, mispredict, etc) segfaults for sample.data files
  without branch info (Jiri Olsa)

* Add patch that should have went in a previous patchkit to use global cache
  provided by libunwind (Namhyung Kim)

* Make CPUINFO_PROC an array to support different kernels, problem
  detected when the information reported via /proc/cpuinfo changed on ARM (Wang Nan)

* 'perf probe' --demangle typo fix and a new --quiet option (Masami Hiramatsu)

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Jiri Olsa (7):
      perf tools: Fix report -F abort for data without branch info
      perf tools: Fix report -F in_tx for data without branch info
      perf tools: Fix report -F mispredict for data without branch info
      perf tools: Fix report -F symbol_to for data without branch info
      perf tools: Fix report -F symbol_from for data without branch info
      perf tools: Fix report -F dso_to for data without branch info
      perf tools: Fix report -F dso_from for data without branch info

Masami Hiramatsu (1):
      perf probe: Trivial typo fix for --demangle

Namhyung Kim (1):
      perf callchain: Use global caching provided by libunwind

Wang Nan (1):
      perf tools: Make CPUINFO_PROC an array to support different kernel versions

 tools/perf/builtin-probe.c         |   2 +-
 tools/perf/perf-sys.h              |  30 +++++------
 tools/perf/util/header.c           |  27 +++++++---
 tools/perf/util/sort.c             | 102 +++++++++++++++++++++++++++----------
 tools/perf/util/thread.c           |   3 ++
 tools/perf/util/unwind-libunwind.c |  12 +++++
 tools/perf/util/unwind.h           |   3 ++
 7 files changed, 131 insertions(+), 48 deletions(-)
