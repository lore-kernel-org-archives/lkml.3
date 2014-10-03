Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744AbaJCPgy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 11:36:54 -0400
Received: from resqmta-ch2-11v.sys.comcast.net ([69.252.207.43]:38304 "EHLO
	resqmta-ch2-11v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753459AbaJCPgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 11:36:38 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        colin.king@canonical.com, dbueso@suse.de, luto@amacapital.net
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/5] selftests/breakpoints: change test to use ksft framework
Date: Fri,  3 Oct 2014 09:36:17 -0600
Message-Id: <6e6772fee69e0c71feaf1a48b3f1ebcfc89be966.1412349412.git.shuahkh@osg.samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1412349412.git.shuahkh@osg.samsung.com>
References: <cover.1412349412.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1412349412.git.shuahkh@osg.samsung.com>
References: <cover.1412349412.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change breakpoints test to use kselftest framework to report
test results.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 tools/testing/selftests/breakpoints/breakpoint_test.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/breakpoints/breakpoint_test.c b/tools/testing/selftests/breakpoints/breakpoint_test.c
index a0743f3..120895a 100644
--- a/tools/testing/selftests/breakpoints/breakpoint_test.c
+++ b/tools/testing/selftests/breakpoints/breakpoint_test.c
@@ -17,6 +17,8 @@
 #include <sys/types.h>
 #include <sys/wait.h>
 
+#include "../kselftest.h"
+
 
 /* Breakpoint access modes */
 enum {
@@ -42,7 +44,7 @@ static void set_breakpoint_addr(void *addr, int n)
 		     offsetof(struct user, u_debugreg[n]), addr);
 	if (ret) {
 		perror("Can't set breakpoint addr\n");
-		exit(-1);
+		ksft_exit_fail();
 	}
 }
 
@@ -105,7 +107,7 @@ static void toggle_breakpoint(int n, int type, int len,
 		     offsetof(struct user, u_debugreg[7]), dr7);
 	if (ret) {
 		perror("Can't set dr7");
-		exit(-1);
+		ksft_exit_fail();
 	}
 }
 
@@ -275,7 +277,7 @@ static void check_success(const char *msg)
 			msg2 = "Ok";
 		if (ptrace(PTRACE_POKEDATA, child_pid, &trapped, 1)) {
 			perror("Can't poke\n");
-			exit(-1);
+			ksft_exit_fail();
 		}
 	}
 
@@ -390,5 +392,5 @@ int main(int argc, char **argv)
 
 	wait(NULL);
 
-	return 0;
+	return ksft_exit_pass();
 }
-- 
1.9.1

