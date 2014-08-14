Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbaHNCWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 22:22:53 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:52014 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350AbaHNCWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 22:22:51 -0400
X-AuditID: 85900ec0-d1d29b9000001514-ba-53ec1d789dc1
Subject: [PATCH 09/13] perf sched: Use strerror_r instead of strerror
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Naohiro Aota <naota@elisp.net>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung@kernel.org>
Date: Thu, 14 Aug 2014 02:22:47 +0000
Message-ID: <20140814022247.3545.4564.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20140814022228.3545.90481.stgit@kbuild-fedora.novalocal>
References: <20140814022228.3545.90481.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use strerror_r instead of strerror in error message
for thread-safety.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 tools/perf/builtin-sched.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index f5874a2..9c9287f 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -428,6 +428,7 @@ static u64 get_cpu_usage_nsec_parent(void)
 static int self_open_counters(void)
 {
 	struct perf_event_attr attr;
+	char sbuf[STRERR_BUFSIZE];
 	int fd;
 
 	memset(&attr, 0, sizeof(attr));
@@ -440,7 +441,8 @@ static int self_open_counters(void)
 
 	if (fd < 0)
 		pr_err("Error: sys_perf_event_open() syscall returned "
-		       "with %d (%s)\n", fd, strerror(errno));
+		       "with %d (%s)\n", fd,
+		       strerror_r(errno, sbuf, sizeof(sbuf)));
 	return fd;
 }
 

