Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbaCJVPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 17:15:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34673 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbaCJVPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 17:15:21 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, stable@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/3] perf trace: Decode architecture-specific signal numbers
Date: Mon, 10 Mar 2014 18:15:06 -0300
Message-Id: <1394486108-5974-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1394486108-5974-1-git-send-email-acme@infradead.org>
References: <1394486108-5974-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

SIGSTKFLT is not defined on alpha, mips or sparc.

SIGEMT and SIGSWI are defined on some architectures and should be
decoded here if so.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Fixes: 8bad5b0abfdb ('perf trace: Beautify signal number arg in several syscalls')
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/1391648441.3003.101.camel@deadeye.wl.decadent.org.uk
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 6aa6fb6f7bd9..f954c26de231 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -825,7 +825,6 @@ static size_t syscall_arg__scnprintf_signum(char *bf, size_t size, struct syscal
 	P_SIGNUM(PIPE);
 	P_SIGNUM(ALRM);
 	P_SIGNUM(TERM);
-	P_SIGNUM(STKFLT);
 	P_SIGNUM(CHLD);
 	P_SIGNUM(CONT);
 	P_SIGNUM(STOP);
@@ -841,6 +840,15 @@ static size_t syscall_arg__scnprintf_signum(char *bf, size_t size, struct syscal
 	P_SIGNUM(IO);
 	P_SIGNUM(PWR);
 	P_SIGNUM(SYS);
+#ifdef SIGEMT
+	P_SIGNUM(EMT);
+#endif
+#ifdef SIGSTKFLT
+	P_SIGNUM(STKFLT);
+#endif
+#ifdef SIGSWI
+	P_SIGNUM(SWI);
+#endif
 	default: break;
 	}
 
-- 
1.8.1.4

