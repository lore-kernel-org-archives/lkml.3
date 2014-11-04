Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbaKDRSd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 12:18:33 -0500
Received: from mailout.easymail.ca ([64.68.201.169]:50515 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaKDRSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 12:18:14 -0500
X-Quarantine-ID: <zlpz4xwIXfWT>
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
Subject: [PATCH 07/20] selftests/efivarfs: add install target to enable installing test
Date: Tue,  4 Nov 2014 10:11:03 -0700
Message-Id: <3d28ab3098e26044a5ef7f60b620c7dfe66cc3fa.1415117102.git.shuahkh@osg.samsung.com>
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
 tools/testing/selftests/efivarfs/Makefile | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/efivarfs/Makefile b/tools/testing/selftests/efivarfs/Makefile
index 29e8c6b..a668728 100644
--- a/tools/testing/selftests/efivarfs/Makefile
+++ b/tools/testing/selftests/efivarfs/Makefile
@@ -3,7 +3,18 @@ CFLAGS = -Wall
 
 test_objs = open-unlink create-read
 
-all: $(test_objs)
+TEST_STR = "/bin/bash ./efivarfs.sh || echo \"efivarfs selftests: [FAIL]\""
+
+all:
+	gcc open-unlink.c -o open-unlink
+	gcc create-read.c -o create-read
+
+install: all
+	install ./efivarfs.sh $(test_objs) $(INSTALL_KSFT_PATH)
+	echo "\necho \"Start efivarfs test ....\"" >> $(KSELFTEST)
+	echo $(TEST_STR) >> $(KSELFTEST)
+	echo "echo \"End efivarfs test ....\"" >> $(KSELFTEST)
+	echo "echo \"==============================\"" >> $(KSELFTEST)
 
 run_tests: all
 	@/bin/bash ./efivarfs.sh || echo "efivarfs selftests: [FAIL]"
-- 
1.9.1

