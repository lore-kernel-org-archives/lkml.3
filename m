Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965620AbaLLISl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 03:18:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43167 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965582AbaLLISi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 03:18:38 -0500
Date: Fri, 12 Dec 2014 00:18:20 -0800
From: tip-bot for Arjun Sreedharan <tipbot@zytor.com>
Message-ID: <tip-e4e458b45c5861808674eebfea94cee2258bb2ea@git.kernel.org>
Cc: arjun024@gmail.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        paulus@samba.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        hpa@zytor.com, mingo@kernel.org, mingo@redhat.com,
        yann.morin.1998@free.fr
Reply-To: arjun024@gmail.com, paulus@samba.org, acme@redhat.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, a.p.zijlstra@chello.nl, yann.morin.1998@free.fr,
        mingo@redhat.com
In-Reply-To: <1417866043-1877-1-git-send-email-arjun024@gmail.com>
References: <1417866043-1877-1-git-send-email-arjun024@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] calloc/xcalloc: Fix argument order
Git-Commit-ID: e4e458b45c5861808674eebfea94cee2258bb2ea
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

Commit-ID:  e4e458b45c5861808674eebfea94cee2258bb2ea
Gitweb:     http://git.kernel.org/tip/e4e458b45c5861808674eebfea94cee2258bb2ea
Author:     Arjun Sreedharan <arjun024@gmail.com>
AuthorDate: Sat, 6 Dec 2014 17:10:43 +0530
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 9 Dec 2014 10:06:29 -0300

calloc/xcalloc: Fix argument order

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
