Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572Ab3HMLzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 07:55:09 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:40060 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757074Ab3HMLzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 07:55:07 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com, dsahern@gmail.com
Subject: [PATCH v1 0/2] perf: add new PERF_RECORD_MMAP2 record type
Date: Tue, 13 Aug 2013 13:55:55 +0200
Message-Id: <1376394957-31691-1-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series introduces a new record type for mmaps. This
new record is called PERF_RECORD_MMAP2. It provides more information
than the existing PERF_RECORD_MMAP. For each file-backed or
shared memory segment mapping, the device major, minor and the
inode numbers are recorded. This triplet may be used to
disambiguate virtual file-backed mappings between processes.

The triplet could not be fitted into the existing PERF_RECORD_MMAP
record without breaking backward compatibility. This is why we
introduce this new record type.

To activate this new record type, the mmap2 bit must be set
in perf_event_attr struct. It supersedes the mmap bit, but is
distinct from mmap_data. For mmap2 data records, both mmap2 and
mmap_data must be set. For code, only mmap2 must be set.

The series also provides the perf tool support for this new
MMAP2 record type. Perf record activates this mode by default.
The maj, min, ino are not yet exploited by perf report but
will be in subsequent perf tools.

Patch is relative to tip.git

Signed-off-by: Stephane Eranian <eranian@google.com>
---

Stephane Eranian (2):
  perf: add attr->mmap2 attribute to an event
  perf tools: add attr->mmap2 support

 include/uapi/linux/perf_event.h |   22 +++++++++++++++-
 kernel/events/core.c            |   41 ++++++++++++++++++++++++++---
 tools/perf/builtin-annotate.c   |    1 +
 tools/perf/builtin-inject.c     |   15 +++++++++++
 tools/perf/builtin-mem.c        |    1 +
 tools/perf/builtin-report.c     |    1 +
 tools/perf/builtin-script.c     |    1 +
 tools/perf/util/build-id.c      |    1 +
 tools/perf/util/event.c         |   55 ++++++++++++++++++++++++++++++---------
 tools/perf/util/event.h         |   18 +++++++++++++
 tools/perf/util/evsel.c         |    5 ++--
 tools/perf/util/header.c        |    3 +++
 tools/perf/util/machine.c       |   51 +++++++++++++++++++++++++++++++++++-
 tools/perf/util/machine.h       |    1 +
 tools/perf/util/map.c           |    7 ++++-
 tools/perf/util/map.h           |    6 +++--
 tools/perf/util/session.c       |   25 +++++++++++++++++-
 tools/perf/util/tool.h          |    1 +
 18 files changed, 231 insertions(+), 24 deletions(-)

-- 
1.7.9.5

