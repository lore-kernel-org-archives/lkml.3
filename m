Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901AbaLXHTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 02:19:21 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:40208 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbaLXHPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 02:15:40 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 26/37] perf tools: Move BUILD_ID_SIZE definition to perf.h
Date: Wed, 24 Dec 2014 16:15:22 +0900
Message-Id: <1419405333-27952-27-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The util/event.h includes util/build-id.h only for BUILD_ID_SIZE.
This is a problem when I include util/event.h from util/tool.h which
is also included by util/build-id.h since it now makes a circular
dependency resulting in incomplete type error.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/perf.h          | 1 +
 tools/perf/util/build-id.h | 2 --
 tools/perf/util/dso.h      | 1 +
 tools/perf/util/event.h    | 1 -
 4 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 37284eb47b56..56ce258314fc 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -30,6 +30,7 @@ static inline unsigned long long rdclock(void)
 }
 
 #define MAX_NR_CPUS			256
+#define BUILD_ID_SIZE			20
 
 extern const char *input_name;
 extern bool perf_host, perf_guest;
diff --git a/tools/perf/util/build-id.h b/tools/perf/util/build-id.h
index 8236319514d5..8f31545edc5b 100644
--- a/tools/perf/util/build-id.h
+++ b/tools/perf/util/build-id.h
@@ -1,8 +1,6 @@
 #ifndef PERF_BUILD_ID_H_
 #define PERF_BUILD_ID_H_ 1
 
-#define BUILD_ID_SIZE 20
-
 #include "tool.h"
 #include <linux/types.h>
 
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index ac753594a469..c18fcc0e8081 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -7,6 +7,7 @@
 #include <linux/types.h>
 #include <linux/bitops.h>
 #include "map.h"
+#include "perf.h"
 #include "build-id.h"
 
 enum dso_binary_type {
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 09b9e8d3fcf7..5f66abfa61ca 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -6,7 +6,6 @@
 
 #include "../perf.h"
 #include "map.h"
-#include "build-id.h"
 #include "perf_regs.h"
 
 struct mmap_event {
-- 
2.1.3

