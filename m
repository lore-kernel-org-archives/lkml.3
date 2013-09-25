Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab3IYSbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 14:31:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41529 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab3IYSbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 14:31:13 -0400
Date: Wed, 25 Sep 2013 11:30:41 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-4921e320244e099bdf237fd10428594ce5f5b87d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
In-Reply-To: <1379003976-5839-5-git-send-email-jolsa@redhat.com>
References: <1379003976-5839-5-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf kmem:
  Make it work again on non NUMA machines
Git-Commit-ID: 4921e320244e099bdf237fd10428594ce5f5b87d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 25 Sep 2013 11:30:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4921e320244e099bdf237fd10428594ce5f5b87d
Gitweb:     http://git.kernel.org/tip/4921e320244e099bdf237fd10428594ce5f5b87d
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 12 Sep 2013 18:39:36 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 24 Sep 2013 14:13:46 -0300

perf kmem: Make it work again on non NUMA machines

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
