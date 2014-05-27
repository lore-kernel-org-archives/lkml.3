Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbaE0Q3F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 12:29:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594AbaE0Q3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 12:29:01 -0400
From: Don Zickus <dzickus@redhat.com>
To: jolsa@redhat.com
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, namhyung@gmail.com,
        eranian@google.com, Andi Kleen <andi@firstfloor.org>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 0/7 V4] perf: Enable mmap2 and add dcacheline sorting
Date: Tue, 27 May 2014 12:28:00 -0400
Message-Id: <1401208087-181977-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches enable mmap2 support in the kernel and perf to
allow support for data cacheline sorting.

Note: I haven't been able to reproduce Jiri's perf hang yet, so I don't
have a patch for that particular problem yet.

V4: reworked setting up cacheline size (Jiri Olsa)

V3: added patch to get cacheline size at runtime
    updated some changelogs
    fix a test failure (after install libunwind-devel)
    fix header column length

V2: change cacheline to dcacheline (Namhyung Kim)
    change dcacheline alogorithm a bit
    re-order mmap2 patches (Namhyung Kim)
    provide documentation (Andi Kleen)

Don Zickus (7):
  events, perf: Pass protection and flags bits through mmap2 interface
  Revert "perf: Disable PERF_RECORD_MMAP2 support"
  perf: Update mmap2 interface with protection and flag bits
  perf report: Add mem-mode documentation to report command
  perf: Add cpumode to struct hist_entry
  perf: Add support to dynamically get cacheline size
  perf: Add dcacheline sort

 include/uapi/linux/perf_event.h          |   1 +
 kernel/events/core.c                     |  37 +++++++++--
 tools/perf/Documentation/perf-report.txt |  23 +++++++
 tools/perf/builtin-report.c              |   2 +-
 tools/perf/perf.c                        |   5 ++
 tools/perf/tests/dwarf-unwind.c          |   2 +-
 tools/perf/util/cpumap.c                 |  27 ++++++++
 tools/perf/util/cpumap.h                 |   3 +
 tools/perf/util/event.c                  |  59 +++++++++++------
 tools/perf/util/event.h                  |   2 +
 tools/perf/util/evsel.c                  |   1 +
 tools/perf/util/hist.c                   |   9 ++-
 tools/perf/util/hist.h                   |   1 +
 tools/perf/util/machine.c                |   4 +-
 tools/perf/util/map.c                    |   4 +-
 tools/perf/util/map.h                    |   4 +-
 tools/perf/util/sort.c                   | 108 +++++++++++++++++++++++++++++++
 tools/perf/util/sort.h                   |   2 +
 tools/perf/util/util.c                   |   1 +
 tools/perf/util/util.h                   |   1 +
 20 files changed, 265 insertions(+), 31 deletions(-)

-- 
1.7.11.7

