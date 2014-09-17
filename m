Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248AbaIQVZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 17:25:48 -0400
Received: from mail.kernel.org ([198.145.19.201]:58255 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757191AbaIQVZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 17:25:42 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 17/20] perf symbols: Add path to Ubuntu kernel debuginfo file
Date: Wed, 17 Sep 2014 18:24:20 -0300
Message-Id: <1410989063-14207-18-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410989063-14207-1-git-send-email-acme@kernel.org>
References: <1410989063-14207-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@samba.org>

Ubuntu places the kernel debuginfo in /usr/lib/debug/boot/vmlinux-*

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
echo Link: http://lkml.kernel.org/n/tip-`ranpwd -l 24`@git.kernel.org
Link: http://lkml.kernel.org/r/20140909091152.2698c0f7@kryten
[ Adapted it to use the perf.data file kernel version as in 0a7e6d1b6844 ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 1adb143867e3..be84f7a9838b 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1757,7 +1757,7 @@ static int vmlinux_path__init(struct perf_session_env *env)
 	char bf[PATH_MAX];
 	char *kernel_version;
 
-	vmlinux_path = malloc(sizeof(char *) * 5);
+	vmlinux_path = malloc(sizeof(char *) * 6);
 	if (vmlinux_path == NULL)
 		return -1;
 
@@ -1788,6 +1788,12 @@ static int vmlinux_path__init(struct perf_session_env *env)
 	if (vmlinux_path[vmlinux_path__nr_entries] == NULL)
 		goto out_fail;
 	++vmlinux_path__nr_entries;
+	snprintf(bf, sizeof(bf), "/usr/lib/debug/boot/vmlinux-%s",
+		 kernel_version);
+	vmlinux_path[vmlinux_path__nr_entries] = strdup(bf);
+	if (vmlinux_path[vmlinux_path__nr_entries] == NULL)
+		goto out_fail;
+        ++vmlinux_path__nr_entries;
 	snprintf(bf, sizeof(bf), "/lib/modules/%s/build/vmlinux", kernel_version);
 	vmlinux_path[vmlinux_path__nr_entries] = strdup(bf);
 	if (vmlinux_path[vmlinux_path__nr_entries] == NULL)
-- 
1.9.3

