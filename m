Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbaKKUag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 15:30:36 -0500
Received: from mailout.easymail.ca ([64.68.201.169]:48084 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbaKKU22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 15:28:28 -0500
X-Quarantine-ID: <YHBc+Ow-08UT>
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
Subject: [PATCH v2 15/19] selftests/ptrace: add install target to enable installing test
Date: Tue, 11 Nov 2014 13:27:55 -0700
Message-Id: <5e075603a9e0ec1fe21ce07a9a94dbf15d46c557.1415735831.git.shuahkh@osg.samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1415735831.git.shuahkh@osg.samsung.com>
References: <cover.1415735831.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1415735831.git.shuahkh@osg.samsung.com>
References: <cover.1415735831.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new make target to enable installing test. This target
installs test in the kselftest install location and add to the
kselftest script to run the test. Install target can be run
only from top level source dir.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 tools/testing/selftests/ptrace/Makefile | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/ptrace/Makefile b/tools/testing/selftests/ptrace/Makefile
index 47ae2d3..9ef3c4b 100644
--- a/tools/testing/selftests/ptrace/Makefile
+++ b/tools/testing/selftests/ptrace/Makefile
@@ -1,10 +1,23 @@
 CFLAGS += -iquote../../../../include/uapi -Wall
-peeksiginfo: peeksiginfo.c
 
-all: peeksiginfo
+TEST_STR = ./peeksiginfo || echo peeksiginfo selftests: [FAIL]
+
+all:
+	gcc peeksiginfo.c -o peeksiginfo
+
+install:
+ifdef INSTALL_KSFT_PATH
+	install ./peeksiginfo $(INSTALL_KSFT_PATH)
+	@echo echo Start ptrace test .... >> $(KSELFTEST)
+	@echo "$(TEST_STR)" >> $(KSELFTEST)
+	@echo echo End ptrace test .... >> $(KSELFTEST)
+	@echo echo ============================== >> $(KSELFTEST)
+else
+	@echo Run make kselftest_install in top level source directory
+endif
 
 clean:
 	rm -f peeksiginfo
 
 run_tests: all
-	@./peeksiginfo || echo "peeksiginfo selftests: [FAIL]"
+	@$(TEST_STR)
-- 
1.9.1

