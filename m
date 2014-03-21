Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966352AbaCUBOw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:14:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36641 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933181AbaCUAD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:03:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3.13 044/149] perf trace: Decode architecture-specific signal numbers
Date: Thu, 20 Mar 2014 17:03:27 -0700
Message-Id: <20140321000438.498460764@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 02c5bb4a352a4cca56e9b5d3a2a57d61062eb2e1 upstream.

SIGSTKFLT is not defined on alpha, mips or sparc.

SIGEMT and SIGSWI are defined on some architectures and should be
decoded here if so.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Fixes: 8bad5b0abfdb ('perf trace: Beautify signal number arg in several syscalls')
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1391648441.3003.101.camel@deadeye.wl.decadent.org.uk
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/builtin-trace.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -821,7 +821,6 @@ static size_t syscall_arg__scnprintf_sig
 	P_SIGNUM(PIPE);
 	P_SIGNUM(ALRM);
 	P_SIGNUM(TERM);
-	P_SIGNUM(STKFLT);
 	P_SIGNUM(CHLD);
 	P_SIGNUM(CONT);
 	P_SIGNUM(STOP);
@@ -837,6 +836,15 @@ static size_t syscall_arg__scnprintf_sig
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
 


