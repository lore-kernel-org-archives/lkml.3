Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445AbaKKUai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 15:30:38 -0500
Received: from mailout.easymail.ca ([64.68.201.169]:48097 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbaKKU22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 15:28:28 -0500
X-Quarantine-ID: <kqKDghyxRXWq>
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
Subject: [PATCH v2 16/19] selftests/sysctl: add install target to enable installing test
Date: Tue, 11 Nov 2014 13:27:56 -0700
Message-Id: <d9d5e5733e0720efbf77552fa2caf1880a3e3cf5.1415735831.git.shuahkh@osg.samsung.com>
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
 tools/testing/selftests/sysctl/Makefile | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/sysctl/Makefile b/tools/testing/selftests/sysctl/Makefile
index 0a92ada..34cca1b 100644
--- a/tools/testing/selftests/sysctl/Makefile
+++ b/tools/testing/selftests/sysctl/Makefile
@@ -4,12 +4,31 @@
 # No binaries, but make sure arg-less "make" doesn't trigger "run_tests".
 all:
 
+INSTALL_PROGS = common_tests run_numerictests run_stringtests
+NUMERIC_TEST_STR = /bin/sh ./run_numerictests
+STRING_TEST_STR = /bin/sh ./run_stringtests
+
 # Allow specific tests to be selected.
 test_num:
-	@/bin/sh ./run_numerictests
+	@$(NUMERIC_TEST_STR)
 
 test_string:
-	@/bin/sh ./run_stringtests
+	@$(STRING_TEST_STR)
+
+install: all
+ifdef INSTALL_KSFT_PATH
+	install $(INSTALL_PROGS) $(INSTALL_KSFT_PATH)
+	@echo echo Start sysctl numeric tests .... >> $(KSELFTEST)
+	@echo "$(NUMERIC_TEST_STR)" >> $(KSELFTEST)
+	@echo echo End sysctl numeric tests .... >> $(KSELFTEST)
+	@echo echo -------------------- >> $(KSELFTEST)
+	@echo echo Start sysctl string tests .... >> $(KSELFTEST)
+	@echo "$(STRING_TEST_STR)" >> $(KSELFTEST)
+	@echo echo End sysctl string test .... >> $(KSELFTEST)
+	@echo echo ============================== >> $(KSELFTEST)
+else
+	@echo Run make kselftest_install in top level source directory
+endif
 
 run_tests: all test_num test_string
 
-- 
1.9.1

