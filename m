Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965501AbaLKV1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 16:27:32 -0500
Received: from mail.kernel.org ([198.145.19.201]:44507 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965482AbaLKV13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 16:27:29 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 15/18] tools lib fs: Add sysctl__read_int helper
Date: Thu, 11 Dec 2014 18:26:03 -0300
Message-Id: <1418333166-15429-16-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418333166-15429-1-git-send-email-acme@kernel.org>
References: <1418333166-15429-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Will come in handy for tools, see next patches.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-nay9j62ztxpytt4ew1tkl4op@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/api/fs/fs.c | 13 +++++++++++++
 tools/lib/api/fs/fs.h |  1 +
 2 files changed, 14 insertions(+)

diff --git a/tools/lib/api/fs/fs.c b/tools/lib/api/fs/fs.c
index b8d0df8878d1..65d9be3f9887 100644
--- a/tools/lib/api/fs/fs.c
+++ b/tools/lib/api/fs/fs.c
@@ -184,3 +184,16 @@ int filename__read_int(const char *filename, int *value)
 	close(fd);
 	return err;
 }
+
+int sysctl__read_int(const char *sysctl, int *value)
+{
+	char path[PATH_MAX];
+	const char *procfs = procfs__mountpoint();
+
+	if (!procfs)
+		return -1;
+
+	snprintf(path, sizeof(path), "%s/sys/%s", procfs, sysctl);
+
+	return filename__read_int(path, value);
+}
diff --git a/tools/lib/api/fs/fs.h b/tools/lib/api/fs/fs.h
index 4d0aef6e7163..6caa2bbc6cec 100644
--- a/tools/lib/api/fs/fs.h
+++ b/tools/lib/api/fs/fs.h
@@ -13,4 +13,5 @@ const char *sysfs__mountpoint(void);
 const char *procfs__mountpoint(void);
 
 int filename__read_int(const char *filename, int *value);
+int sysctl__read_int(const char *sysctl, int *value);
 #endif /* __API_FS__ */
-- 
1.9.3

