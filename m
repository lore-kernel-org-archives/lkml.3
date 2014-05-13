Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbaEMQuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 12:50:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380AbaEMQtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 12:49:24 -0400
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net, peterz@infradead.org
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, namhyung@gmail.com,
        eranian@google.com, Andi Kleen <andi@firstfloor.org>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 0/6 V2] perf: Enable mmap2 and add dcacheline sorting
Date: Tue, 13 May 2014 12:48:11 -0400
Message-Id: <1399999697-65875-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches enable mmap2 support in the kernel and perf to
allow support for data cacheline sorting.

V2: change cacheline to dcacheline (Namhyung Kim)
    change dcacheline alogorithm a bit
    re-order mmap2 patches (Namhyung Kim)
    provide documentation (Andi Kleen)
 
Don Zickus (6):
  events, perf: Pass protection and flags bits through mmap2 interface
  Revert "perf: Disable PERF_RECORD_MMAP2 support"
  perf: Update mmap2 interface with protection and flag bits
  perf report: Add mem-mode documentation to report command
  perf: Add cpumode to struct hist_entry
  perf: Add dcacheline sort

 include/uapi/linux/perf_event.h          |   1 +
 kernel/events/core.c                     |  37 +++++++++--
 tools/perf/Documentation/perf-report.txt |  23 +++++++
 tools/perf/builtin-report.c              |   2 +-
 tools/perf/util/event.c                  |  59 +++++++++++------
 tools/perf/util/event.h                  |   2 +
 tools/perf/util/evsel.c                  |   1 +
 tools/perf/util/hist.c                   |   7 ++-
 tools/perf/util/hist.h                   |   1 +
 tools/perf/util/machine.c                |   4 +-
 tools/perf/util/map.c                    |   4 +-
 tools/perf/util/map.h                    |   4 +-
 tools/perf/util/sort.c                   | 105 +++++++++++++++++++++++++++++++
 tools/perf/util/sort.h                   |   2 +
 14 files changed, 222 insertions(+), 30 deletions(-)

-- 
1.7.11.7

