Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416AbaIWVeE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 17:34:04 -0400
Received: from qmta07.westchester.pa.mail.comcast.net ([76.96.62.64]:48428
	"EHLO qmta07.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756846AbaIWVdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 17:33:10 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        colin.king@canonical.com, dbueso@suse.de, ebiederm@xmission.com,
        serge.hallyn@ubuntu.com, thierry@linux.vnet.ibm.com,
        luto@amacapital.net
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/7] selftests/mount: change test to use ksft framework
Date: Tue, 23 Sep 2014 15:32:58 -0600
Message-Id: <969f0780734a04763f2b54063603b93380244d0c.1411506121.git.shuahkh@osg.samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1411506121.git.shuahkh@osg.samsung.com>
References: <cover.1411506121.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1411506121.git.shuahkh@osg.samsung.com>
References: <cover.1411506121.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change mount test to use kselftest framework to report
test results.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 tools/testing/selftests/mount/unprivileged-remount-test.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mount/unprivileged-remount-test.c b/tools/testing/selftests/mount/unprivileged-remount-test.c
index 1b3ff2f..c64d442 100644
--- a/tools/testing/selftests/mount/unprivileged-remount-test.c
+++ b/tools/testing/selftests/mount/unprivileged-remount-test.c
@@ -13,6 +13,8 @@
 #include <stdbool.h>
 #include <stdarg.h>
 
+#include "../kselftest.h"
+
 #ifndef CLONE_NEWNS
 # define CLONE_NEWNS 0x00020000
 #endif
@@ -45,7 +47,7 @@ static void die(char *fmt, ...)
 	va_start(ap, fmt);
 	vfprintf(stderr, fmt, ap);
 	va_end(ap);
-	exit(EXIT_FAILURE);
+	ksft_exit_fail();
 }
 
 static void write_file(char *filename, char *fmt, ...)
@@ -176,7 +178,7 @@ bool test_unpriv_remount(int mount_flags, int remount_flags, int invalid_flags)
 		die("remount of /tmp with invalid flags "
 		    "succeeded unexpectedly\n");
 	}
-	exit(EXIT_SUCCESS);
+	return ksft_exit_pass();
 }
 
 static bool test_unpriv_remount_simple(int mount_flags)
@@ -238,5 +240,5 @@ int main(int argc, char **argv)
 	{
 		die("Default atime malfunctions\n");
 	}
-	return EXIT_SUCCESS;
+	return ksft_exit_pass();
 }
-- 
1.9.1

