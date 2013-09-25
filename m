Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab3IYRUt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 13:20:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54944 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab3IYRUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 13:20:45 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/6] perf kmem: Make it work again on non NUMA machines
Date: Wed, 25 Sep 2013 14:20:23 -0300
Message-Id: <1380129628-16808-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380129628-16808-1-git-send-email-acme@infradead.org>
References: <1380129628-16808-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

The commit '2814eb0 perf kmem: Remove die() calls' disabled 'perf kmem'
command for machines without numa support. It made the command fail if
'/sys/devices/system/node' dir wasn't found.

Skipping the numa based initialization in case the directory is not
found and continue execution.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1379003976-5839-5-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
1.8.1.4

