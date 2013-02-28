Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760193Ab3B1PMH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:12:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42138 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757964Ab3B1OsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:48:05 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vinson Lee <vlee@twitter.com>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Li Zefan <lizefan@huawei.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Pekka Enberg <penberg@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 054/139] perf tools: Fix build with bison 2.3 and older.
Date: Thu, 28 Feb 2013 14:43:24 +0000
Message-Id: <1362062689-2567-55-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinson Lee <vlee@twitter.com>

commit 85df3b3769222894e9692b383c7af124b7721086 upstream.

The %name-prefix "prefix" syntax is not available on bison 2.3 and
older. Substitute with the -p "prefix" command-line option for
compatibility with older versions of bison.

This patch fixes this build error with older versions of bison.

    CC util/sysfs.o
    BISON util/pmu-bison.c
util/pmu.y:2.14-24: syntax error, unexpected string, expecting =
make: *** [util/pmu-bison.c] Error 1

Signed-off-by: Vinson Lee <vlee@twitter.com>
Tested-by: Li Zefan <lizefan@huawei.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Link: http://lkml.kernel.org/r/1360792138-29186-1-git-send-email-vlee@twitter.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 tools/perf/Makefile            | 4 ++--
 tools/perf/util/parse-events.y | 1 -
 tools/perf/util/pmu.y          | 1 -
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index e21f414..7bc7233 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -225,13 +225,13 @@ $(OUTPUT)util/parse-events-flex.c: util/parse-events.l
 	$(QUIET_FLEX)$(FLEX) --header-file=$(OUTPUT)util/parse-events-flex.h $(PARSER_DEBUG_FLEX) -t util/parse-events.l > $(OUTPUT)util/parse-events-flex.c
 
 $(OUTPUT)util/parse-events-bison.c: util/parse-events.y
-	$(QUIET_BISON)$(BISON) -v util/parse-events.y -d $(PARSER_DEBUG_BISON) -o $(OUTPUT)util/parse-events-bison.c
+	$(QUIET_BISON)$(BISON) -v util/parse-events.y -d $(PARSER_DEBUG_BISON) -o $(OUTPUT)util/parse-events-bison.c -p parse_events_
 
 $(OUTPUT)util/pmu-flex.c: util/pmu.l
 	$(QUIET_FLEX)$(FLEX) --header-file=$(OUTPUT)util/pmu-flex.h -t util/pmu.l > $(OUTPUT)util/pmu-flex.c
 
 $(OUTPUT)util/pmu-bison.c: util/pmu.y
-	$(QUIET_BISON)$(BISON) -v util/pmu.y -d -o $(OUTPUT)util/pmu-bison.c
+	$(QUIET_BISON)$(BISON) -v util/pmu.y -d -o $(OUTPUT)util/pmu-bison.c -p perf_pmu_
 
 $(OUTPUT)util/parse-events.o: $(OUTPUT)util/parse-events-flex.c $(OUTPUT)util/parse-events-bison.c
 $(OUTPUT)util/pmu.o: $(OUTPUT)util/pmu-flex.c $(OUTPUT)util/pmu-bison.c
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 362cc59..14a42b8 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -1,5 +1,4 @@
 
-%name-prefix "parse_events_"
 %parse-param {struct list_head *list_all}
 %parse-param {int *idx}
 
diff --git a/tools/perf/util/pmu.y b/tools/perf/util/pmu.y
index 20ea77e..522943f 100644
--- a/tools/perf/util/pmu.y
+++ b/tools/perf/util/pmu.y
@@ -1,5 +1,4 @@
 
-%name-prefix "perf_pmu_"
 %parse-param {struct list_head *format}
 %parse-param {char *name}
 
-- 
1.8.1.2

