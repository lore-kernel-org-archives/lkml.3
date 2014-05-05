Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227AbaEEMdy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:33:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932128AbaEEMdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:33:53 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 00/10] perf tools: perf.h cleanups
Date: Mon,  5 May 2014 14:33:29 +0200
Message-Id: <1399293219-8732-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
moving syscall function and arch related defines into
new header 'perf-sys.h' as requested by Peter in:
  http://lkml.kernel.org/r/20140502115201.GI30445@twins.programming.kicks-ass.net

While at it I did some clean ups in perf.h header.

Hopefully I did not brake anyone's usage of
perf.h .. let me know ;-)

Also available in here:
  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
  perf/header_1

thanks,
jirka
---
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>

Jiri Olsa (10):
      perf tools: Remove MAX_COUNTERS define from perf.h
      perf tools: Remove unlikely define from perf.h
      perf tools: Remove min define from perf.h
      perf tools: Remove asmlinkage define from perf.h
      perf tools: Remove PR_TASK_PERF_EVENTS_* from perf.h
      perf tools: Move sample data structures from perf.h
      perf tools: Move perf_call_graph_mode enum from perf.h
      perf tools: Move syscall and arch specific defines from perf.h
      perf tools: Move sys_perf_event_open function from perf.h
      perf tools: Move ACCESS_ONCE from perf.h header

 tools/perf/perf-sys.h       | 190 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/perf.h           | 250 ++++---------------------------------------------------------------------------------------------------
 tools/perf/util/callchain.h |   7 +++
 tools/perf/util/event.h     |  24 ++++++++++
 tools/perf/util/evlist.h    |   2 +
 tools/perf/util/symbol.h    |   1 +
 6 files changed, 232 insertions(+), 242 deletions(-)
 create mode 100644 tools/perf/perf-sys.h
