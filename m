Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360AbaIWVeD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 17:34:03 -0400
Received: from resqmta-ch2-09v.sys.comcast.net ([69.252.207.41]:44779 "EHLO
	resqmta-ch2-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756858AbaIWVdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 17:33:10 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        colin.king@canonical.com, dbueso@suse.de, ebiederm@xmission.com,
        serge.hallyn@ubuntu.com, thierry@linux.vnet.ibm.com,
        luto@amacapital.net
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/7] selftests/ptrace: change test to use ksft framework
Date: Tue, 23 Sep 2014 15:32:59 -0600
Message-Id: <9c141f93f09224d71feb02e907d87337e0db219b.1411506121.git.shuahkh@osg.samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1411506121.git.shuahkh@osg.samsung.com>
References: <cover.1411506121.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1411506121.git.shuahkh@osg.samsung.com>
References: <cover.1411506121.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change ptrace test to use kselftest framework to report
test results.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 tools/testing/selftests/ptrace/peeksiginfo.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/ptrace/peeksiginfo.c b/tools/testing/selftests/ptrace/peeksiginfo.c
index c34cd8a..d940bfc 100644
--- a/tools/testing/selftests/ptrace/peeksiginfo.c
+++ b/tools/testing/selftests/ptrace/peeksiginfo.c
@@ -10,6 +10,7 @@
 #include <sys/mman.h>
 
 #include "linux/ptrace.h"
+#include "../kselftest.h"
 
 static int sys_rt_sigqueueinfo(pid_t tgid, int sig, siginfo_t *uinfo)
 {
@@ -151,7 +152,7 @@ out:
 int main(int argc, char *argv[])
 {
 	siginfo_t siginfo[SIGNR];
-	int i, exit_code = 1;
+	int i;
 	sigset_t blockmask;
 	pid_t child;
 
@@ -162,7 +163,7 @@ int main(int argc, char *argv[])
 	child = fork();
 	if (child == -1) {
 		err("fork() failed: %m");
-		return 1;
+		return ksft_exit_fail();
 	} else if (child == 0) {
 		pid_t ppid = getppid();
 		while (1) {
@@ -170,7 +171,7 @@ int main(int argc, char *argv[])
 				break;
 			sleep(1);
 		}
-		return 1;
+		return ksft_exit_fail();
 	}
 
 	/* Send signals in process-wide and per-thread queues */
@@ -185,7 +186,7 @@ int main(int argc, char *argv[])
 	}
 
 	if (sys_ptrace(PTRACE_ATTACH, child, NULL, NULL) == -1)
-		return 1;
+		return ksft_exit_fail();
 
 	waitpid(child, NULL, 0);
 
@@ -207,12 +208,11 @@ int main(int argc, char *argv[])
 		goto out;
 
 	printf("PASS\n");
-	exit_code = 0;
 out:
 	if (sys_ptrace(PTRACE_KILL, child, NULL, NULL) == -1)
-		return 1;
+		return ksft_exit_fail();
 
 	waitpid(child, NULL, 0);
 
-	return exit_code;
+	return ksft_exit_pass();
 }
-- 
1.9.1

