Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448Ab3C1RNM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 13:13:12 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:47726
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756607Ab3C1RCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 13:02:49 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/36] perf tools: Get rid of redundant _FILE_OFFSET_BITS definition
Date: Thu, 28 Mar 2013 14:02:01 -0300
Message-Id: <1364490156-32064-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1364490156-32064-1-git-send-email-acme@infradead.org>
References: <1364490156-32064-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

We define it in the Makefile so no need to duplicate it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1363686376-29525-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c        |    2 --
 tools/perf/util/header.c           |    2 --
 tools/perf/util/session.c          |    2 --
 tools/perf/util/trace-event-read.c |    2 --
 tools/perf/util/util.h             |    2 --
 5 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 9f2344a..78a41fd 100644
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
index a9b7349..79e48c7 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1,5 +1,3 @@
-#define _FILE_OFFSET_BITS 64
-
 #include "util.h"
 #include <sys/types.h>
 #include <byteswap.h>
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index ab265c2..c8ba120 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1,5 +1,3 @@
-#define _FILE_OFFSET_BITS 64
-
 #include <linux/kernel.h>
 
 #include <byteswap.h>
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index 7cb2463..8c8181a 100644
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
index 6a0781c..a45710b 100644
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
1.7.1

