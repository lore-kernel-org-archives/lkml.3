Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759319AbaIOWmD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:42:03 -0400
Received: from qmta11.westchester.pa.mail.comcast.net ([76.96.59.211]:33667
	"EHLO QMTA11.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932088AbaIOWka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:40:30 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        colin.king@canonical.com, dbueso@suse.de, ebiederm@xmission.com,
        serge.hallyn@ubuntu.com, thierry@linux.vnet.ibm.com,
        felipensp@gmail.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] selftests/mount: change mount test to use kselftest exit codes
Date: Mon, 15 Sep 2014 16:34:00 -0600
Message-Id: <1410820442-8774-6-git-send-email-shuahkh@osg.samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410820442-8774-1-git-send-email-shuahkh@osg.samsung.com>
References: <1410820442-8774-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change mount test to use kselftest exit codes in kselftest.h
to report test results.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 tools/testing/selftests/mount/unprivileged-remount-test.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mount/unprivileged-remount-test.c b/tools/testing/selftests/mount/unprivileged-remount-test.c
index 1b3ff2f..d3c703f 100644
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
+	exit(EXIT_FAIL);
 }
 
 static void write_file(char *filename, char *fmt, ...)
@@ -142,7 +144,7 @@ bool test_unpriv_remount(int mount_flags, int remount_flags, int invalid_flags)
 		if (!WIFEXITED(status)) {
 			die("child did not terminate cleanly\n");
 		}
-		return WEXITSTATUS(status) == EXIT_SUCCESS ? true : false;
+		return WEXITSTATUS(status) == EXIT_PASS ? true : false;
 	}
 
 	create_and_enter_userns();
@@ -176,7 +178,7 @@ bool test_unpriv_remount(int mount_flags, int remount_flags, int invalid_flags)
 		die("remount of /tmp with invalid flags "
 		    "succeeded unexpectedly\n");
 	}
-	exit(EXIT_SUCCESS);
+	exit(EXIT_PASS);
 }
 
 static bool test_unpriv_remount_simple(int mount_flags)
@@ -238,5 +240,5 @@ int main(int argc, char **argv)
 	{
 		die("Default atime malfunctions\n");
 	}
-	return EXIT_SUCCESS;
+	return EXIT_PASS;
 }
-- 
1.9.1

