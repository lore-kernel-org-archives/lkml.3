Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965473AbaLKV1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 16:27:23 -0500
Received: from mail.kernel.org ([198.145.19.201]:44440 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965459AbaLKV1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 16:27:17 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 12/18] perf tests: Fix attr tests size values to cope with machine state on interrupt ABI changes
Date: Thu, 11 Dec 2014 18:26:00 -0300
Message-Id: <1418333166-15429-13-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418333166-15429-1-git-send-email-acme@kernel.org>
References: <1418333166-15429-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Following change adjusted 'struct perf_event_attr', but let
the attr test's sizes untouched:
  60e2364e60e8 perf: Add ability to sample machine state on interrupt

  [jolsa@krava perf]$ ./perf test attr -vv
  --- start ---
  test child forked, pid 9719
  running './tests/attr/test-stat-group1'
    'PERF_TEST_ATTR=/tmp/tmp4drvul ./perf stat -o /tmp/tmp4drvul/perf.data -e '{cycles,instructions}' kill >/dev/null 2>&1' ret 1
  expected size=96, got 104
  FAILED './tests/attr/test-stat-group1' - match failure

Adjusting test size values for attr test.

Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/20141209135301.GC6784@krava.brq.redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/attr/base-record | 2 +-
 tools/perf/tests/attr/base-stat   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/tests/attr/base-record b/tools/perf/tests/attr/base-record
index f710b92ccff6..d3095dafed36 100644
--- a/tools/perf/tests/attr/base-record
+++ b/tools/perf/tests/attr/base-record
@@ -5,7 +5,7 @@ group_fd=-1
 flags=0|8
 cpu=*
 type=0|1
-size=96
+size=104
 config=0
 sample_period=4000
 sample_type=263
diff --git a/tools/perf/tests/attr/base-stat b/tools/perf/tests/attr/base-stat
index dc3ada2470c0..872ed7e24c7c 100644
--- a/tools/perf/tests/attr/base-stat
+++ b/tools/perf/tests/attr/base-stat
@@ -5,7 +5,7 @@ group_fd=-1
 flags=0|8
 cpu=*
 type=0
-size=96
+size=104
 config=0
 sample_period=0
 sample_type=0
-- 
1.9.3

