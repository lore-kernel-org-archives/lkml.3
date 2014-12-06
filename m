Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416AbaLFLlG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 06:41:06 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:48850 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbaLFLlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 06:41:04 -0500
From: Arjun Sreedharan <arjun024@gmail.com>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] calloc/xcalloc: fix argument order
Date: Sat,  6 Dec 2014 17:10:43 +0530
Message-Id: <1417866043-1877-1-git-send-email-arjun024@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

calloc() and xcalloc() takes @nmemb first and then @size.
fix all w/ pattern "calloc\s*(\s*sizeof".

Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>
---
 scripts/kconfig/mconf.c    | 4 ++--
 tools/perf/ui/hist.c       | 4 ++--
 tools/thermal/tmon/sysfs.c | 6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index 14cea74..4dd3755 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -330,10 +330,10 @@ static void set_subtitle(void)
 	list_for_each_entry(sp, &trail, entries) {
 		if (sp->text) {
 			if (pos) {
-				pos->next = xcalloc(sizeof(*pos), 1);
+				pos->next = xcalloc(1, sizeof(*pos));
 				pos = pos->next;
 			} else {
-				subtitles = pos = xcalloc(sizeof(*pos), 1);
+				subtitles = pos = xcalloc(1, sizeof(*pos));
 			}
 			pos->text = sp->text;
 		}
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 2af1837..dc0d095 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -162,8 +162,8 @@ static int __hpp__sort(struct hist_entry *a, struct hist_entry *b,
 		return ret;
 
 	nr_members = evsel->nr_members;
-	fields_a = calloc(sizeof(*fields_a), nr_members);
-	fields_b = calloc(sizeof(*fields_b), nr_members);
+	fields_a = calloc(nr_members, sizeof(*fields_a));
+	fields_b = calloc(nr_members, sizeof(*fields_b));
 
 	if (!fields_a || !fields_b)
 		goto out;
diff --git a/tools/thermal/tmon/sysfs.c b/tools/thermal/tmon/sysfs.c
index dfe4548..1c12536 100644
--- a/tools/thermal/tmon/sysfs.c
+++ b/tools/thermal/tmon/sysfs.c
@@ -446,7 +446,7 @@ int probe_thermal_sysfs(void)
 		return -1;
 	}
 
-	ptdata.tzi = calloc(sizeof(struct tz_info), ptdata.max_tz_instance+1);
+	ptdata.tzi = calloc(ptdata.max_tz_instance+1, sizeof(struct tz_info));
 	if (!ptdata.tzi) {
 		fprintf(stderr, "Err: allocate tz_info\n");
 		return -1;
@@ -454,8 +454,8 @@ int probe_thermal_sysfs(void)
 
 	/* we still show thermal zone information if there is no cdev */
 	if (ptdata.nr_cooling_dev) {
-		ptdata.cdi = calloc(sizeof(struct cdev_info),
-				ptdata.max_cdev_instance + 1);
+		ptdata.cdi = calloc(ptdata.max_cdev_instance + 1,
+				sizeof(struct cdev_info));
 		if (!ptdata.cdi) {
 			free(ptdata.tzi);
 			fprintf(stderr, "Err: allocate cdev_info\n");
-- 
1.8.1.msysgit.1

