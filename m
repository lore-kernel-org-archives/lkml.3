Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933150Ab3LIThu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 14:37:50 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54967 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760961Ab3LIThV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 14:37:21 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 14/21] perf kvm: Move code to generate filename for perf-kvm to function.
Date: Mon,  9 Dec 2013 16:37:03 -0300
Message-Id: <1386617830-18926-15-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386617830-18926-1-git-send-email-acme@infradead.org>
References: <1386617830-18926-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>

The code in builtin-kvm.c to generate filename for perf-kvm is useful to
other command such as builtin-diff.

This patch move the related code form builtin-kvm.c to util/util.c and
wrap them in a function named get_filename_for_perf_kvm.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Link: http://lkml.kernel.org/r/5e09a5c47e8a495e888cbdc65a6fafb2c950f529.1386368672.git.yangds.fnst@cn.fujitsu.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c |  7 +------
 tools/perf/util/util.c   | 14 ++++++++++++++
 tools/perf/util/util.h   |  2 ++
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index c2e5d56a291d..c6fa3cbd45a9 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1713,12 +1713,7 @@ int cmd_kvm(int argc, const char **argv, const char *prefix __maybe_unused)
 		perf_guest = 1;
 
 	if (!file_name) {
-		if (perf_host && !perf_guest)
-			file_name = strdup("perf.data.host");
-		else if (!perf_host && perf_guest)
-			file_name = strdup("perf.data.guest");
-		else
-			file_name = strdup("perf.data.kvm");
+		file_name = get_filename_for_perf_kvm();
 
 		if (!file_name) {
 			pr_err("Failed to allocate memory for filename\n");
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index bae8756a4eb1..4a57609c0b43 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -482,3 +482,17 @@ int filename__read_str(const char *filename, char **buf, size_t *sizep)
 	close(fd);
 	return err;
 }
+
+const char *get_filename_for_perf_kvm(void)
+{
+	const char *filename;
+
+	if (perf_host && !perf_guest)
+		filename = strdup("perf.data.host");
+	else if (!perf_host && perf_guest)
+		filename = strdup("perf.data.guest");
+	else
+		filename = strdup("perf.data.kvm");
+
+	return filename;
+}
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 659abf30e01b..0171213d1d4d 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -321,4 +321,6 @@ void free_srcline(char *srcline);
 
 int filename__read_int(const char *filename, int *value);
 int filename__read_str(const char *filename, char **buf, size_t *sizep);
+
+const char *get_filename_for_perf_kvm(void);
 #endif /* GIT_COMPAT_UTIL_H */
-- 
1.8.1.4

