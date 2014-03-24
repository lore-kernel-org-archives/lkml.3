Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbaCXTfU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 15:35:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753886AbaCXTfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 15:35:17 -0400
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net, peterz@infradead.org
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, jmario@redhat.com,
        fowles@inreach.com, eranian@google.com, andi.kleen@intel.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 0/6] perf, events: Enable mmap2 support
Date: Mon, 24 Mar 2014 15:34:30 -0400
Message-Id: <1395689676-214799-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-enable mmap2 support with some extra features.  Also include a user,
perf report.

Perf report uses a new output format for the physid work I am trying to 
do in the c2c tool.  Hopefully this format is not as ugly.

V2: This is the second iteration of the mmap2 sorting in hist_entry's to
    cleanup the output a bit

Don Zickus (6):
  events, perf: Pass protection and flags bits through mmap2 interface
  perf: Update mmap2 interface with protection and flag bits
  Revert "perf: Disable PERF_RECORD_MMAP2 support"
  perf, sort:  Add physid sorting based on mmap2 data
  perf: Update sort to handle MAP_SHARED bits
  perf, sort:  Allow unique sorting instead of combining hist_entries

 include/uapi/linux/perf_event.h |   1 +
 kernel/events/core.c            |  37 ++++-
 tools/perf/builtin-report.c     |  20 ++-
 tools/perf/util/event.c         |  59 +++++---
 tools/perf/util/event.h         |   2 +
 tools/perf/util/evsel.c         |   1 +
 tools/perf/util/hist.c          |  30 +++-
 tools/perf/util/hist.h          |   8 ++
 tools/perf/util/machine.c       |   4 +-
 tools/perf/util/map.c           |   4 +-
 tools/perf/util/map.h           |   4 +-
 tools/perf/util/sort.c          | 297 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/sort.h          |  14 ++
 13 files changed, 450 insertions(+), 31 deletions(-)

-- 
1.7.11.7

