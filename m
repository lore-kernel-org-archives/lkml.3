Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932913AbaLAXJh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 18:09:37 -0500
Received: from mail.kernel.org ([198.145.19.201]:46610 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932553AbaLAXJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 18:09:33 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/9] perf/core improvements
Date: Mon,  1 Dec 2014 20:09:15 -0300
Message-Id: <1417475364-27371-1-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling, on top of one previous pull request.

- Arnaldo


The following changes since commit 1d9e446b91e182055d874fbb30150aad479a4981:

  perf tools: Add snapshot format file parsing (2014-11-24 18:03:51 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-core-for-mingo-2

for you to fetch changes up to 09a6a1b07e5a579ef770d9728f5b158408c73c23:

  perf report: In branch stack mode use address history sorting (2014-12-01 20:00:31 -0300)

----------------------------------------------------------------
perf/core improvements:

User visible:

o Support handling complete branch stacks as histograms (Andi Kleen)

Infrastructure:

o Prep work for supporting per-pkg and snapshot counters in 'perf stat' (Jiri Olsa)

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Andi Kleen (3):
      perf callchain: Support handling complete branch stacks as histograms
      perf report: Add --branch-history option
      perf report: In branch stack mode use address history sorting

Jiri Olsa (6):
      perf stat: Use perf_evsel__read_cb in read_counter
      perf stat: Make read_counter work over the thread dimension
      perf stat: Use read_counter in read_counter_aggr
      perf tools: Remove perf_evsel__read interface
      perf stat: Add support for per-pkg counters
      perf stat: Add support for snapshot counters

 tools/perf/Documentation/perf-report.txt |  12 ++-
 tools/perf/builtin-report.c              |  31 ++++++--
 tools/perf/builtin-stat.c                | 105 +++++++++++++++++++++++---
 tools/perf/util/callchain.c              |   4 +
 tools/perf/util/callchain.h              |   1 +
 tools/perf/util/evsel.c                  |  34 ---------
 tools/perf/util/evsel.h                  |  30 +-------
 tools/perf/util/machine.c                | 126 ++++++++++++++++++++++++++++---
 tools/perf/util/symbol.h                 |   3 +-
 9 files changed, 257 insertions(+), 89 deletions(-)
