Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965694AbaLLITM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 03:19:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43199 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934076AbaLLITK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 03:19:10 -0500
Date: Fri, 12 Dec 2014 00:18:35 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-75226c577c8869ae1449cf92d781edda0177f1cf@git.kernel.org>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org, ak@linux.intel.com,
        mingo@kernel.org, tglx@linutronix.de, jolsa@redhat.com, hpa@zytor.com,
        eranian@google.com, acme@redhat.com
Reply-To: mingo@kernel.org, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, acme@redhat.com, eranian@google.com,
        hpa@zytor.com, tglx@linutronix.de, jolsa@redhat.com
In-Reply-To: <20141209135301.GC6784@krava.brq.redhat.com>
References: <20141209135301.GC6784@krava.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tests:
  Fix attr tests size values to cope with machine state on interrupt ABI changes
Git-Commit-ID: 75226c577c8869ae1449cf92d781edda0177f1cf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  75226c577c8869ae1449cf92d781edda0177f1cf
Gitweb:     http://git.kernel.org/tip/75226c577c8869ae1449cf92d781edda0177f1cf
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 9 Dec 2014 14:53:01 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 9 Dec 2014 11:02:43 -0300

perf tests: Fix attr tests size values to cope with machine state on interrupt ABI changes

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
index f710b92..d3095da 100644
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
index dc3ada2..872ed7e 100644
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
