Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab3GGN4i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 09:56:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759Ab3GGN4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 09:56:34 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Waiman Long <Waiman.Long@hp.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf tools: Fix boolean for NO_LIBPYTHON=1 NO_LIBPERL=1 build
Date: Sun,  7 Jul 2013 15:55:39 +0200
Message-Id: <1373205339-17550-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The build is broken for 'NO_LIBPYTHON=1 NO_LIBPERL=1' switches.

The reason is that without perl and python support we
dont have TRUE/FALSE macro definitions in dso and vdso
objects (added there by commit 7821317).

Using stdbool.h defines instead which seems to be more
common in perf code anyway.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Waiman Long <Waiman.Long@hp.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/dso.c  | 2 +-
 tools/perf/util/vdso.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 3d80f92..c4374f0 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -531,7 +531,7 @@ struct dso *dsos__find(struct list_head *head, const char *name, bool cmp_short)
 
 struct dso *__dsos__findnew(struct list_head *head, const char *name)
 {
-	struct dso *dso = dsos__find(head, name, FALSE);
+	struct dso *dso = dsos__find(head, name, false);
 
 	if (!dso) {
 		dso = dso__new(name);
diff --git a/tools/perf/util/vdso.c b/tools/perf/util/vdso.c
index a8fd73d..3915982 100644
--- a/tools/perf/util/vdso.c
+++ b/tools/perf/util/vdso.c
@@ -91,7 +91,7 @@ void vdso__exit(void)
 
 struct dso *vdso__dso_findnew(struct list_head *head)
 {
-	struct dso *dso = dsos__find(head, VDSO__MAP_NAME, TRUE);
+	struct dso *dso = dsos__find(head, VDSO__MAP_NAME, true);
 
 	if (!dso) {
 		char *file;
-- 
1.7.11.7

