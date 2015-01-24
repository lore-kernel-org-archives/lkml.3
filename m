Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbbAXSO6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 13:14:58 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:58278 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754167AbbAXSOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 13:14:50 -0500
Message-Id: <20150124181448.835464482@goodmis.org>
User-Agent: quilt/0.61-1
Date: Sat, 24 Jan 2015 13:13:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 3/5] tools lib api fs: Add DEBUGFS_DEFAULT_PATH macro
References: <20150124181330.195149364@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0003-tools-lib-api-fs-Add-DEBUGFS_DEFAULT_PATH-macro.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Instead of hard coding "/sys/kernel/debug" everywhere, create
a macro to hold where the default path exists.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/lib/api/fs/debugfs.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/lib/api/fs/debugfs.c b/tools/lib/api/fs/debugfs.c
index 76eb92c0623f..1637e5b6a5d5 100644
--- a/tools/lib/api/fs/debugfs.c
+++ b/tools/lib/api/fs/debugfs.c
@@ -10,10 +10,14 @@
 #include "debugfs.h"
 #include "findfs.h"
 
-char debugfs_mountpoint[PATH_MAX + 1] = "/sys/kernel/debug";
+#ifndef DEBUGFS_DEFAULT_PATH
+#define DEBUGFS_DEFAULT_PATH		"/sys/kernel/debug"
+#endif
+
+char debugfs_mountpoint[PATH_MAX + 1] = DEBUGFS_DEFAULT_PATH;
 
 static const char * const debugfs_known_mountpoints[] = {
-	"/sys/kernel/debug",
+	DEBUGFS_DEFAULT_PATH,
 	"/debug",
 	0,
 };
@@ -51,7 +55,7 @@ char *debugfs_mount(const char *mountpoint)
 		mountpoint = getenv(PERF_DEBUGFS_ENVIRONMENT);
 		/* if no environment variable, use default */
 		if (mountpoint == NULL)
-			mountpoint = "/sys/kernel/debug";
+			mountpoint = DEBUGFS_DEFAULT_PATH;
 	}
 
 	if (mount(NULL, mountpoint, "debugfs", 0, NULL) < 0)
-- 
2.1.4


