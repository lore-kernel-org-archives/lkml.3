Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385Ab3LFJ1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 04:27:43 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:6295 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757293Ab3LFJ1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 04:27:39 -0500
X-IronPort-AV: E=Sophos;i="4.93,839,1378828800"; 
   d="scan'208";a="9205953"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: acme@ghostprotocols.net
Cc: linux-kernel@vger.kernel.org, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 1/3] perf tools: Move code to generate filename for perf-kvm to function.
Date: Fri, 6 Dec 2013 17:25:51 -0500
Message-Id: <5e09a5c47e8a495e888cbdc65a6fafb2c950f529.1386368672.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/06 17:27:25,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/06 17:27:27,
	Serialize complete at 2013/12/06 17:27:27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code in builtin-kvm.c to generate filename for perf-kvm is useful
to other command such as builtin-diff.

This patch move the related code form builtin-kvm.c to util/util.c and
wrap them in a function named get_filename_for_perf_kvm.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 tools/perf/builtin-kvm.c |  7 +------
 tools/perf/util/util.c   | 14 ++++++++++++++
 tools/perf/util/util.h   |  2 ++
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index f8bf5f2..143ad99 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1711,12 +1711,7 @@ int cmd_kvm(int argc, const char **argv, const char *prefix __maybe_unused)
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
index bae8756..4a57609 100644
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
index adb39f2..e6d8796 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -309,4 +309,6 @@ void free_srcline(char *srcline);
 
 int filename__read_int(const char *filename, int *value);
 int filename__read_str(const char *filename, char **buf, size_t *sizep);
+
+const char *get_filename_for_perf_kvm(void);
 #endif /* GIT_COMPAT_UTIL_H */
-- 
1.8.2.1

