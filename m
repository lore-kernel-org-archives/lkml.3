Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbaKKUff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 15:35:35 -0500
Received: from mailout.easymail.ca ([64.68.201.169]:47960 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbaKKU2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 15:28:11 -0500
X-Quarantine-ID: <yg1O7s1IltSN>
X-Amavis-Alert: BAD HEADER SECTION, Duplicate header field: "References"
X-Spam-Flag: NO
X-Spam-Score: -4.399
From: Shuah Khan <shuahkh@osg.samsung.com>
To: gregkh@linuxfoundation.org, akpm@linux-foundation.org, mmarek@suse.cz,
        davem@davemloft.net, keescook@chromium.org, tranmanphong@gmail.com,
        dh.herrmann@gmail.com, hughd@google.com, bobby.prani@gmail.com,
        ebiederm@xmission.com, serge.hallyn@ubuntu.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2 01/19] selftests/user: move test out of Makefile into a shell script
Date: Tue, 11 Nov 2014 13:27:41 -0700
Message-Id: <a9c5e0a9b1dee8e673648c962750514d86550241.1415735831.git.shuahkh@osg.samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1415735831.git.shuahkh@osg.samsung.com>
References: <cover.1415735831.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1415735831.git.shuahkh@osg.samsung.com>
References: <cover.1415735831.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently user copy test is run from the Makefile. Move it out
of the Makefile to be run from a shell script to allow the test
to be run as stand-alone test, in addition to allowing the test
run from a make target.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 tools/testing/selftests/user/Makefile          |  8 +-------
 tools/testing/selftests/user/test_user_copy.sh | 10 ++++++++++
 2 files changed, 11 insertions(+), 7 deletions(-)
 create mode 100755 tools/testing/selftests/user/test_user_copy.sh

diff --git a/tools/testing/selftests/user/Makefile b/tools/testing/selftests/user/Makefile
index 396255b..12c9d15 100644
--- a/tools/testing/selftests/user/Makefile
+++ b/tools/testing/selftests/user/Makefile
@@ -4,10 +4,4 @@
 all:
 
 run_tests: all
-	@if /sbin/modprobe test_user_copy ; then \
-		rmmod test_user_copy; \
-		echo "user_copy: ok"; \
-	else \
-		echo "user_copy: [FAIL]"; \
-		exit 1; \
-	fi
+	./test_user_copy.sh
diff --git a/tools/testing/selftests/user/test_user_copy.sh b/tools/testing/selftests/user/test_user_copy.sh
new file mode 100755
index 0000000..350107f
--- /dev/null
+++ b/tools/testing/selftests/user/test_user_copy.sh
@@ -0,0 +1,10 @@
+#!/bin/sh
+# Runs copy_to/from_user infrastructure using test_user_copy kernel module
+
+if /sbin/modprobe -q test_user_copy; then
+	/sbin/modprobe -q -r test_user_copy
+	echo "user_copy: ok"
+else
+	echo "user_copy: [FAIL]"
+	exit 1
+fi
-- 
1.9.1

