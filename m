Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965593AbaLKV3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 16:29:17 -0500
Received: from mail.kernel.org ([198.145.19.201]:44409 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965445AbaLKV1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 16:27:13 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arjun Sreedharan <arjun024@gmail.com>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 11/18] calloc/xcalloc: Fix argument order
Date: Thu, 11 Dec 2014 18:25:59 -0300
Message-Id: <1418333166-15429-12-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418333166-15429-1-git-send-email-acme@kernel.org>
References: <1418333166-15429-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjun Sreedharan <arjun024@gmail.com>

The calloc() and xcalloc() functions takes @nmemb first and then @size.  Fix all w/
pattern "calloc\s*(\s*sizeof".

Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>
Cc: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1417866043-1877-1-git-send-email-arjun024@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 scripts/kconfig/mconf.c    | 4 ++--
 tools/perf/ui/hist.c       | 4 ++--
 tools/thermal/tmon/sysfs.c | 6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index 14cea7463a62..4dd37552abc2 100644
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
index 2af18376b077..dc0d095f318c 100644
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
index dfe454855cd2..1c12536f2081 100644
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
1.9.3

