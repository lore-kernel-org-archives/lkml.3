Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603AbaKDRVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 12:21:49 -0500
Received: from mailout.easymail.ca ([64.68.201.169]:50542 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbaKDRSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 12:18:21 -0500
X-Quarantine-ID: <5ZXNCFBex1Aj>
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
Subject: [PATCH 13/20] selftests/mount: add install target to enable installing test
Date: Tue,  4 Nov 2014 10:11:09 -0700
Message-Id: <313d51c298bb13b7cd9187555ee8a70ee966e397.1415117102.git.shuahkh@osg.samsung.com>
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
 tools/testing/selftests/mount/Makefile | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/selftests/mount/Makefile b/tools/testing/selftests/mount/Makefile
index 337d853..3bcb112 100644
--- a/tools/testing/selftests/mount/Makefile
+++ b/tools/testing/selftests/mount/Makefile
@@ -9,6 +9,13 @@ unprivileged-remount-test: unprivileged-remount-test.c
 test_unprivileged_remount: unprivileged-remount-test
 	@if [ -f /proc/self/uid_map ] ; then ./unprivileged-remount-test ; fi
 
+install: all
+	install ./unprivileged-remount-test $(INSTALL_KSFT_PATH)
+	echo "\necho \"Start mount test ....\"" >> $(KSELFTEST)
+	echo "if [ -f /proc/self/uid_map ] ; then ./unprivileged-remount-test ; fi" >> $(KSELFTEST)
+	echo "echo \"End mount test ....\"" >> $(KSELFTEST)
+	echo "echo \"==============================\"" >> $(KSELFTEST)
+
 run_tests: all test_unprivileged_remount
 
 clean:
-- 
1.9.1

