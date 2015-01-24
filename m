Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366AbbAXSOx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 13:14:53 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:8390 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754083AbbAXSOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 13:14:50 -0500
Message-Id: <20150124181449.008674149@goodmis.org>
User-Agent: quilt/0.61-1
Date: Sat, 24 Jan 2015 13:13:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 4/5] tools lib api fs: Add {tracefs,debugfs}_configured() functions
References: <20150124181330.195149364@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0004-tools-lib-api-fs-Add-tracefs-debugfs-_configured-fun.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Add tracefs_configured() to return true if tracefs is configured in the
kernel (/sys/kernel/tracing exists), and debugfs_configured() if debugfs
is configured in the kernel (/sys/kernel/debug exists).

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/lib/api/fs/debugfs.c | 13 +++++++++++++
 tools/lib/api/fs/debugfs.h |  1 +
 tools/lib/api/fs/tracefs.c | 13 +++++++++++++
 tools/lib/api/fs/tracefs.h |  1 +
 4 files changed, 28 insertions(+)

diff --git a/tools/lib/api/fs/debugfs.c b/tools/lib/api/fs/debugfs.c
index 1637e5b6a5d5..a2d8e59f042b 100644
--- a/tools/lib/api/fs/debugfs.c
+++ b/tools/lib/api/fs/debugfs.c
@@ -2,8 +2,11 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <unistd.h>
 #include <stdbool.h>
 #include <sys/vfs.h>
+#include <sys/types.h>
+#include <sys/stat.h>
 #include <sys/mount.h>
 #include <linux/kernel.h>
 
@@ -24,6 +27,16 @@ static const char * const debugfs_known_mountpoints[] = {
 
 static bool debugfs_found;
 
+bool debugfs_configured(void)
+{
+	struct stat st;
+
+	if (stat(DEBUGFS_DEFAULT_PATH, &st) < 0)
+		return false;
+
+	return true;
+}
+
 /* find the path to the mounted debugfs */
 const char *debugfs_find_mountpoint(void)
 {
diff --git a/tools/lib/api/fs/debugfs.h b/tools/lib/api/fs/debugfs.h
index f19d3df9609d..a8a385008db3 100644
--- a/tools/lib/api/fs/debugfs.h
+++ b/tools/lib/api/fs/debugfs.h
@@ -20,6 +20,7 @@
 #define PERF_DEBUGFS_ENVIRONMENT "PERF_DEBUGFS_DIR"
 #endif
 
+bool debugfs_configured(void);
 const char *debugfs_find_mountpoint(void);
 int debugfs_valid_mountpoint(const char *debugfs);
 char *debugfs_mount(const char *mountpoint);
diff --git a/tools/lib/api/fs/tracefs.c b/tools/lib/api/fs/tracefs.c
index bdaf54142c5d..43cb0b24a999 100644
--- a/tools/lib/api/fs/tracefs.c
+++ b/tools/lib/api/fs/tracefs.c
@@ -2,8 +2,11 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <unistd.h>
 #include <stdbool.h>
 #include <sys/vfs.h>
+#include <sys/types.h>
+#include <sys/stat.h>
 #include <sys/mount.h>
 #include <linux/kernel.h>
 
@@ -26,6 +29,16 @@ static const char * const tracefs_known_mountpoints[] = {
 
 static bool tracefs_found;
 
+bool tracefs_configured(void)
+{
+	struct stat st;
+
+	if (stat(TRACEFS_DEFAULT_PATH, &st) < 0)
+		return false;
+
+	return true;
+}
+
 /* find the path to the mounted tracefs */
 const char *tracefs_find_mountpoint(void)
 {
diff --git a/tools/lib/api/fs/tracefs.h b/tools/lib/api/fs/tracefs.h
index 576206500e15..a25a003a9ee6 100644
--- a/tools/lib/api/fs/tracefs.h
+++ b/tools/lib/api/fs/tracefs.h
@@ -20,6 +20,7 @@
 #define PERF_TRACEFS_ENVIRONMENT "PERF_TRACEFS_DIR"
 #endif
 
+bool tracefs_configured(void);
 const char *tracefs_find_mountpoint(void);
 int tracefs_valid_mountpoint(const char *debugfs);
 char *tracefs_mount(const char *mountpoint);
-- 
2.1.4


