Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242AbaIWVdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 17:33:42 -0400
Received: from resqmta-ch2-07v.sys.comcast.net ([69.252.207.39]:52780 "EHLO
	resqmta-ch2-07v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756127AbaIWVdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 17:33:12 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        colin.king@canonical.com, dbueso@suse.de, ebiederm@xmission.com,
        serge.hallyn@ubuntu.com, thierry@linux.vnet.ibm.com,
        luto@amacapital.net
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 7/7] selftests/timers: change test to use ksft framework
Date: Tue, 23 Sep 2014 15:33:00 -0600
Message-Id: <d9a4d72ce50d6389aa8ce4d8458daf9a3ab8f090.1411506121.git.shuahkh@osg.samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1411506121.git.shuahkh@osg.samsung.com>
References: <cover.1411506121.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1411506121.git.shuahkh@osg.samsung.com>
References: <cover.1411506121.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change timers test to use kselftest framework to report
test results.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 tools/testing/selftests/timers/posix_timers.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/timers/posix_timers.c b/tools/testing/selftests/timers/posix_timers.c
index 41bd855..f87d970 100644
--- a/tools/testing/selftests/timers/posix_timers.c
+++ b/tools/testing/selftests/timers/posix_timers.c
@@ -15,6 +15,8 @@
 #include <time.h>
 #include <pthread.h>
 
+#include "../kselftest.h"
+
 #define DELAY 2
 #define USECS_PER_SEC 1000000
 
@@ -194,16 +196,16 @@ int main(int argc, char **argv)
 	printf("based timers if other threads run on the CPU...\n");
 
 	if (check_itimer(ITIMER_VIRTUAL) < 0)
-		return -1;
+		return ksft_exit_fail();
 
 	if (check_itimer(ITIMER_PROF) < 0)
-		return -1;
+		return ksft_exit_fail();
 
 	if (check_itimer(ITIMER_REAL) < 0)
-		return -1;
+		return ksft_exit_fail();
 
 	if (check_timer_create(CLOCK_THREAD_CPUTIME_ID) < 0)
-		return -1;
+		return ksft_exit_fail();
 
 	/*
 	 * It's unfortunately hard to reliably test a timer expiration
@@ -215,7 +217,7 @@ int main(int argc, char **argv)
 	 * find a better solution.
 	 */
 	if (check_timer_create(CLOCK_PROCESS_CPUTIME_ID) < 0)
-		return -1;
+		return ksft_exit_fail();
 
-	return 0;
+	return ksft_exit_pass();
 }
-- 
1.9.1

