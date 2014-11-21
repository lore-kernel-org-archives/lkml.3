Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138AbaKUJbp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 04:31:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbaKUJbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 04:31:43 -0500
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@kernel.org>
Subject: [RFC 00/11] perf tools: Factor stat reading and CQM changes
Date: Fri, 21 Nov 2014 10:31:04 +0100
Message-Id: <1416562275-12404-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
this patchset factors Matt's userspace part of CQM patches:
http://marc.info/?l=linux-kernel&m=141156746730336&w=2

I needed to put counters reading into single place, which in
the end turned out to be simplification of the stat command
reading side.

any comments are welcome,
jirka


Cc: Andi Kleen <ak@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
Jiri Olsa (10):
      perf tools: Introduce perf_evsel__compute_deltas function
      perf tools: Introduce perf_counts_values__scale function
      perf tools: Introduce perf_evsel__read_cb function
      perf stat: Use perf_evsel__read_cb in read_counter
      perf stat: Make read_counter work over the thread dimension
      perf stat: Use read_counter in read_counter_aggr
      perf tools: Remove perf_evsel__read interface
      perf tools: Add snapshot format file parsing
      perf stat: Add support for per-pkg counters
      perf stat: Add support for snapshot counters

Matt Fleming (1):
      perf tools: Add per-pkg format file parsing

 tools/perf/builtin-stat.c      | 105 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------
 tools/perf/util/evsel.c        | 100 +++++++++++++++++++++++++++------------------------------------------
 tools/perf/util/evsel.h        |  45 +++++++++++--------------------
 tools/perf/util/parse-events.c |   2 ++
 tools/perf/util/pmu.c          |  74 +++++++++++++++++++++++++++++++++++++++++++--------
 tools/perf/util/pmu.h          |   4 +++
 6 files changed, 220 insertions(+), 110 deletions(-)
