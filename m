Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbaKDRSv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 12:18:51 -0500
Received: from mailout.easymail.ca ([64.68.201.169]:50553 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbaKDRSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 12:18:21 -0500
X-Quarantine-ID: <dICyphc45aCm>
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
Subject: [PATCH 08/20] selftests/firmware: add install target to enable installing test
Date: Tue,  4 Nov 2014 10:11:04 -0700
Message-Id: <a2ce2a487fda9cb4ffe45bf96325b2f9ebd4c215.1415117102.git.shuahkh@osg.samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1415117102.git.shuahkh@osg.samsung.com>
References: <cover.1415117102.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1415117102.git.shuahkh@osg.samsung.com>
References: <cover.1415117102.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new make target to enable installing test. This target
installs test in the kselftest install location and add to the
kselftest script to run the test.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 tools/testing/selftests/firmware/Makefile | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/tools/testing/selftests/firmware/Makefile b/tools/testing/selftests/firmware/Makefile
index e23cce0..d5008ec 100644
--- a/tools/testing/selftests/firmware/Makefile
+++ b/tools/testing/selftests/firmware/Makefile
@@ -19,6 +19,26 @@ fw_userhelper:
                 exit 1; \
         fi
 
+install: all
+	install ./fw_filesystem.sh ./fw_userhelper.sh $(INSTALL_KSFT_PATH)
+	echo "\necho \"Start firmware filesystem test ....\"" >> $(KSELFTEST)
+	echo "if /bin/sh ./fw_filesystem.sh ; then \\" >> $(KSELFTEST)
+	echo "\techo \"fw_filesystem: ok \"; \\" >> $(KSELFTEST)
+	echo "else \\" >> $(KSELFTEST)
+	echo "\techo \"fw_filesystem: [FAIL] \"; \\" >> $(KSELFTEST)
+	echo "fi" >> $(KSELFTEST)
+	echo "echo \"End firmware filesystem test ....\"" >> $(KSELFTEST)
+	echo "echo \"--------------------\"" >> $(KSELFTEST)
+
+	echo "echo \"Start firmware userhelper test ....\"" >> $(KSELFTEST)
+	echo "if /bin/sh ./fw_userhelper.sh ; then \\" >> $(KSELFTEST)
+	echo "\techo \"fw_userhelper: ok\"; \\" >> $(KSELFTEST)
+	echo "else \\" >> $(KSELFTEST)
+	echo "\techo \"fw_userhelper: [FAIL] \"; \\" >> $(KSELFTEST)
+	echo "fi" >> $(KSELFTEST)
+	echo "echo \"End firmware userhelper test ....\"" >> $(KSELFTEST)
+	echo "echo \"==============================\"" >> $(KSELFTEST)
+
 run_tests: all fw_filesystem fw_userhelper
 
 # Nothing to clean up.
-- 
1.9.1

