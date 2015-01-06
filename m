Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626AbbAFTzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:55:47 -0500
Received: from resqmta-ch2-12v.sys.comcast.net ([69.252.207.44]:39598 "EHLO
	resqmta-ch2-12v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932648AbbAFTnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:43:51 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mmarek@suse.cz, gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        keescook@chromium.org, tranmanphong@gmail.com, mpe@ellerman.id.au,
        cov@codeaurora.org, dh.herrmann@gmail.com, hughd@google.com,
        bobby.prani@gmail.com, serge.hallyn@ubuntu.com, ebiederm@xmission.com,
        tim.bird@sonymobile.com, josh@joshtriplett.org, koct9i@gmail.com,
        masami.hiramatsu.pt@hitachi.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v4 06/20] selftests/ipc: add install target to enable test install
Date: Tue,  6 Jan 2015 12:43:20 -0700
Message-Id: <98cd1ee5ada03076ba9a6a615498e638bfe4a0ce.1420571615.git.shuahkh@osg.samsung.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1420571615.git.shuahkh@osg.samsung.com>
References: <cover.1420571615.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1420571615.git.shuahkh@osg.samsung.com>
References: <cover.1420571615.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new make target to enable installing test. This target
installs test in the kselftest install location and add to the
kselftest script to run the test. Install target can be run
only from top level kernel source directory.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 tools/testing/selftests/ipc/Makefile | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ipc/Makefile b/tools/testing/selftests/ipc/Makefile
index 74bbefd..67ea3af 100644
--- a/tools/testing/selftests/ipc/Makefile
+++ b/tools/testing/selftests/ipc/Makefile
@@ -11,6 +11,8 @@ endif
 
 CFLAGS += -I../../../../usr/include/
 
+TEST_STR = ./msgque_test || echo 'ipc msgque test: [FAIL]'
+
 all:
 ifeq ($(ARCH),x86)
 	gcc $(CFLAGS) msgque.c -o msgque_test
@@ -18,8 +20,23 @@ else
 	echo "Not an x86 target, can't build msgque selftest"
 endif
 
+install:
+ifdef INSTALL_KSFT_PATH
+ifeq ($(ARCH),x86)
+	make all
+	install ./msgque_test $(INSTALL_KSFT_PATH)
+	@echo "$(TEST_STR)" >> $(KSELFTEST)
+else
+	@echo "Not an x86 target, unable to install ipc msgque selftests"
+endif
+else
+	@echo "Run make kselftest_install in top level source directory"
+endif
+
 run_tests: all
-	./msgque_test
+ifeq ($(ARCH),x86)
+	@$(TEST_STR)
+endif
 
 clean:
 	rm -fr ./msgque_test
-- 
2.1.0

