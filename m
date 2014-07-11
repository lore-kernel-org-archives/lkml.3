Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbaGKX7t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 19:59:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:23798 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbaGKX7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 19:59:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,646,1400050800"; 
   d="scan'208";a="571973893"
From: Andi Kleen <andi@firstfloor.org>
To: jolsa@redhat.com
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 10/11] perf, tools, test: Add test case for alias and JSON parsing
Date: Fri, 11 Jul 2014 16:59:24 -0700
Message-Id: <1405123165-22666-11-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405123165-22666-1-git-send-email-andi@firstfloor.org>
References: <1405123165-22666-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add a simple test case to perf test that runs perf download and parses
all the available events, including json events.

This needs adding an all event iterator to pmu.c

v2: Rename identifiers
v3: Only iterate cpu pmu to avoid bogus errors.
Move pmu iterator to extra patch
Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Makefile.perf        | 1 +
 tools/perf/tests/builtin-test.c | 4 ++++
 tools/perf/tests/tests.h        | 1 +
 3 files changed, 6 insertions(+)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 0600425..6adb37f 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -419,6 +419,7 @@ endif
 LIB_OBJS += $(OUTPUT)tests/code-reading.o
 LIB_OBJS += $(OUTPUT)tests/sample-parsing.o
 LIB_OBJS += $(OUTPUT)tests/parse-no-sample-id-all.o
+LIB_OBJS += $(OUTPUT)tests/aliases.o
 ifndef NO_DWARF_UNWIND
 ifeq ($(ARCH),$(filter $(ARCH),x86 arm))
 LIB_OBJS += $(OUTPUT)tests/dwarf-unwind.o
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 6f8b01b..bb37ac2 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -154,6 +154,10 @@ static struct test {
 		.func = test__hists_cumulate,
 	},
 	{
+		.desc = "Test parsing JSON aliases",
+		.func = test__aliases,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index ed64790..ab92ad9 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -48,6 +48,7 @@ int test__mmap_thread_lookup(void);
 int test__thread_mg_share(void);
 int test__hists_output(void);
 int test__hists_cumulate(void);
+int test__aliases(void);
 
 #if defined(__x86_64__) || defined(__i386__) || defined(__arm__)
 #ifdef HAVE_DWARF_UNWIND_SUPPORT
-- 
1.9.3

