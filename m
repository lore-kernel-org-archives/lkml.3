Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbaCKKRy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:17:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34165 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907AbaCKKRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:17:15 -0400
Date: Tue, 11 Mar 2014 03:16:33 -0700
From: tip-bot for Ben Hutchings <tipbot@zytor.com>
Message-ID: <tip-02c5bb4a352a4cca56e9b5d3a2a57d61062eb2e1@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, ben@decadent.org.uk, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        ben@decadent.org.uk, tglx@linutronix.de
In-Reply-To: <1391648441.3003.101.camel@deadeye.wl.decadent.org.uk>
References: <1391648441.3003.101.camel@deadeye.wl.decadent.org.uk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf trace:
  Decode architecture-specific signal numbers
Git-Commit-ID: 02c5bb4a352a4cca56e9b5d3a2a57d61062eb2e1
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

Commit-ID:  02c5bb4a352a4cca56e9b5d3a2a57d61062eb2e1
Gitweb:     http://git.kernel.org/tip/02c5bb4a352a4cca56e9b5d3a2a57d61062eb2e1
Author:     Ben Hutchings <ben@decadent.org.uk>
AuthorDate: Thu, 6 Feb 2014 01:00:41 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 10 Mar 2014 11:10:45 -0300

perf trace: Decode architecture-specific signal numbers

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
index 6aa6fb6..f954c26 100644
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
 
