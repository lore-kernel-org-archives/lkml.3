Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab3LKLGI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:06:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60233 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab3LKLGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:06:04 -0500
Date: Wed, 11 Dec 2013 03:05:37 -0800
From: tip-bot for Dongsheng Yang <tipbot@zytor.com>
Message-ID: <tip-e1a2b174dbbe08dce12bde9f05f64dbbae652bed@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
In-Reply-To: <5e09a5c47e8a495e888cbdc65a6fafb2c950f529.1386368672.git.yangds.fnst@cn.fujitsu.com>
References: <5e09a5c47e8a495e888cbdc65a6fafb2c950f529.1386368672.git.yangds.fnst@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kvm:
  Move code to generate filename for perf-kvm to function.
Git-Commit-ID: e1a2b174dbbe08dce12bde9f05f64dbbae652bed
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 11 Dec 2013 03:05:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e1a2b174dbbe08dce12bde9f05f64dbbae652bed
Gitweb:     http://git.kernel.org/tip/e1a2b174dbbe08dce12bde9f05f64dbbae652bed
Author:     Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
AuthorDate: Fri, 6 Dec 2013 17:25:51 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 9 Dec 2013 15:23:56 -0300

perf kvm: Move code to generate filename for perf-kvm to function.

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
index c2e5d56..c6fa3cb 100644
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
index 659abf3..0171213 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -321,4 +321,6 @@ void free_srcline(char *srcline);
 
 int filename__read_int(const char *filename, int *value);
 int filename__read_str(const char *filename, char **buf, size_t *sizep);
+
+const char *get_filename_for_perf_kvm(void);
 #endif /* GIT_COMPAT_UTIL_H */
