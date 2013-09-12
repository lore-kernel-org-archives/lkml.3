Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab3ILQlf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 12:41:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892Ab3ILQj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 12:39:57 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/4] perf tools: Make kmem work for non numa machines
Date: Thu, 12 Sep 2013 18:39:36 +0200
Message-Id: <1379003976-5839-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1379003976-5839-1-git-send-email-jolsa@redhat.com>
References: <1379003976-5839-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit '2814eb0 perf kmem: Remove die() calls' disabled
kmem command for machines without numa support. It made the
command fail if '/sys/devices/system/node' dir wasn't found.

Skipping the numa based initialization in case the directory
is not found and continue execution.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index c2dff9c..9b5f077 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -101,7 +101,7 @@ static int setup_cpunode_map(void)
 
 	dir1 = opendir(PATH_SYS_NODE);
 	if (!dir1)
-		return -1;
+		return 0;
 
 	while ((dent1 = readdir(dir1)) != NULL) {
 		if (dent1->d_type != DT_DIR ||
-- 
1.7.11.7

