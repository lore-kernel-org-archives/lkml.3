Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979Ab3CSJqZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 05:46:25 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:53955 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529Ab3CSJqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 05:46:24 -0400
X-AuditID: 9c930197-b7cc2ae000000eb7-ef-514833ef0d59
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf tools: Get rid of redundant _FILE_OFFSET_BITS definition
Date: Tue, 19 Mar 2013 18:46:16 +0900
Message-Id: <1363686376-29525-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

We define it in the Makefile so no need to duplicate it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-record.c        | 2 --
 tools/perf/util/header.c           | 2 --
 tools/perf/util/session.c          | 2 --
 tools/perf/util/trace-event-read.c | 2 --
 tools/perf/util/util.h             | 2 --
 5 files changed, 10 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 9f2344a2c506..78a41fdbe56c 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -5,8 +5,6 @@
  * (or a CPU, or a PID) into the perf.data output file - for
  * later analysis via perf report.
  */
-#define _FILE_OFFSET_BITS 64
-
 #include "builtin.h"
 
 #include "perf.h"
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index a9b7349f7c5f..79e48c726938 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1,5 +1,3 @@
-#define _FILE_OFFSET_BITS 64
-
 #include "util.h"
 #include <sys/types.h>
 #include <byteswap.h>
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index ab265c2cfab3..c8ba120b0dbe 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1,5 +1,3 @@
-#define _FILE_OFFSET_BITS 64
-
 #include <linux/kernel.h>
 
 #include <byteswap.h>
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index 7cb24635adf2..8c8181aa286a 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -18,8 +18,6 @@
  *
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
-#define _FILE_OFFSET_BITS 64
-
 #include <dirent.h>
 #include <stdio.h>
 #include <stdlib.h>
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 6a0781c3a573..a45710b70a55 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -1,8 +1,6 @@
 #ifndef GIT_COMPAT_UTIL_H
 #define GIT_COMPAT_UTIL_H
 
-#define _FILE_OFFSET_BITS 64
-
 #ifndef FLEX_ARRAY
 /*
  * See if our compiler is known to support flexible array members.
-- 
1.7.11.7

