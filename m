Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760540Ab3DBJVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:21:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50485 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755864Ab3DBJVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:21:49 -0400
Date: Tue, 2 Apr 2013 02:21:24 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-62baca8aed636eb10f9274761aa1dcbfd48a7caa@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1363686376-29525-1-git-send-email-namhyung@kernel.org>
References: <1363686376-29525-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Get rid of redundant _FILE_OFFSET_BITS definition
Git-Commit-ID: 62baca8aed636eb10f9274761aa1dcbfd48a7caa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 02 Apr 2013 02:21:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  62baca8aed636eb10f9274761aa1dcbfd48a7caa
Gitweb:     http://git.kernel.org/tip/62baca8aed636eb10f9274761aa1dcbfd48a7caa
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 19 Mar 2013 18:46:16 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 21 Mar 2013 13:04:00 -0300

perf tools: Get rid of redundant _FILE_OFFSET_BITS definition

We define it in the Makefile so no need to duplicate it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1363686376-29525-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c        | 2 --
 tools/perf/util/header.c           | 2 --
 tools/perf/util/session.c          | 2 --
 tools/perf/util/trace-event-read.c | 2 --
 tools/perf/util/util.h             | 2 --
 5 files changed, 10 deletions(-)

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
index a9b7349..79e48c72 100644
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
