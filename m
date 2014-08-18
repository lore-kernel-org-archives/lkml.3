Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbaHRIZJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 04:25:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51649 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbaHRIZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 04:25:05 -0400
Date: Mon, 18 Aug 2014 01:24:47 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-fb74fbda42dc5bcbd9bae5d75bfb6755948db21d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, naota@elisp.net, namhyung@kernel.org,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        naota@elisp.net, namhyung@kernel.org, masami.hiramatsu.pt@hitachi.com,
        tglx@linutronix.de
In-Reply-To: <20140814022247.3545.4564.stgit@kbuild-fedora.novalocal>
References: <20140814022247.3545.4564.stgit@kbuild-fedora.novalocal>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf sched: Use strerror_r instead of strerror
Git-Commit-ID: fb74fbda42dc5bcbd9bae5d75bfb6755948db21d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fb74fbda42dc5bcbd9bae5d75bfb6755948db21d
Gitweb:     http://git.kernel.org/tip/fb74fbda42dc5bcbd9bae5d75bfb6755948db21d
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 14 Aug 2014 02:22:47 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Aug 2014 13:07:47 -0300

perf sched: Use strerror_r instead of strerror

Use strerror_r instead of strerror in error message for thread-safety.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Naohiro Aota <naota@elisp.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20140814022247.3545.4564.stgit@kbuild-fedora.novalocal
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-sched.c | 4 +++-
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
 
