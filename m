Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbaKKUeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 15:34:37 -0500
Received: from mailout.easymail.ca ([64.68.201.169]:48003 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbaKKU2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 15:28:18 -0500
X-Quarantine-ID: <w-GadEsoxg26>
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
Subject: [PATCH v2 04/19] selftests/breakpoints: add install target to enable installing test
Date: Tue, 11 Nov 2014 13:27:44 -0700
Message-Id: <37441d357f68dc157701a5606a9c953cea671500.1415735831.git.shuahkh@osg.samsung.com>
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
 tools/testing/selftests/breakpoints/Makefile | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/breakpoints/Makefile b/tools/testing/selftests/breakpoints/Makefile
index e18b42b..9a70aeb 100644
--- a/tools/testing/selftests/breakpoints/Makefile
+++ b/tools/testing/selftests/breakpoints/Makefile
@@ -8,6 +8,7 @@ ifeq ($(ARCH),x86_64)
 	ARCH := x86
 endif
 
+TEST_STR = ./breakpoint_test || echo breakpoints selftests: [FAIL]
 
 all:
 ifeq ($(ARCH),x86)
@@ -16,8 +17,25 @@ else
 	echo "Not an x86 target, can't build breakpoints selftests"
 endif
 
-run_tests:
-	@./breakpoint_test || echo "breakpoints selftests: [FAIL]"
+install:
+ifdef INSTALL_KSFT_PATH
+ifeq ($(ARCH),x86)
+	install ./breakpoint_test $(INSTALL_KSFT_PATH)
+	@echo echo Start breakpoints test .... >> $(KSELFTEST)
+	@echo "$(TEST_STR)" >> $(KSELFTEST)
+	@echo echo End breakpoints test .... >> $(KSELFTEST)
+	@echo echo ============================== >> $(KSELFTEST)
+else
+	@echo Not an x86 target, unable to install breakpoints selftests
+endif
+else
+	@echo Run make kselftest_install in top level source directory
+endif
+
+run_tests: all
+ifeq ($(ARCH),x86)
+	@$(TEST_STR)
+endif
 
 clean:
 	rm -fr breakpoint_test
-- 
1.9.1

