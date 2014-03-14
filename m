Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbaCNO6O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 10:58:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754167AbaCNO6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 10:58:13 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [RFC 0/5] perf tools: Share map groups within process
Date: Fri, 14 Mar 2014 15:00:01 +0100
Message-Id: <1394805606-25883-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
this patchset moves thread's map_groups to be dynamically
allocated and shared within process threads.

The main benefit would be to be able to look up memory
map from any thread that belongs to the process.

This implementes one of the solution ideas for issue
described by Don in following thread:
http://marc.info/?l=linux-kernel&m=139403876017159&w=2

This patches still has some loose ends, just wanted to hear
opinions for this concept.

thanks,
jirka

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---
Jiri Olsa (5):
      perf tests: Add tip/pid mmap automated tests
      perf tools: Factor machine__find_thread to take tid argument
      perf tools: Allocate thread map_groups dynamicaly
      perf tools: Add machine pointer into thread struct
      perf tools: Share process map groups within process threads

 tools/perf/Makefile.perf                 |   1 +
 tools/perf/arch/x86/tests/dwarf-unwind.c |   2 +-
 tools/perf/perf.h                        |   6 ++
 tools/perf/tests/builtin-test.c          |   4 ++
 tools/perf/tests/dwarf-unwind.c          |   2 +-
 tools/perf/tests/mmap-events.c           | 188 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h                 |   1 +
 tools/perf/ui/stdio/hist.c               |   8 ++-
 tools/perf/util/event.c                  |   4 +-
 tools/perf/util/machine.c                |  21 ++++---
 tools/perf/util/machine.h                |   3 +-
 tools/perf/util/map.h                    |   3 +-
 tools/perf/util/thread.c                 |  87 ++++++++++++++++++++++++++---
 tools/perf/util/thread.h                 |  15 +++--
 14 files changed, 317 insertions(+), 28 deletions(-)
 create mode 100644 tools/perf/tests/mmap-events.c
