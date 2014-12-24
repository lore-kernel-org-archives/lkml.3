Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531AbaLXQ2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 11:28:05 -0500
Received: from resqmta-po-01v.sys.comcast.net ([96.114.154.160]:56936 "EHLO
	resqmta-po-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751086AbaLXQ2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 11:28:03 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mmarek@suse.cz, gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        keescook@chromium.org, tranmanphong@gmail.com, mpe@ellerman.id.au,
        cov@codeaurora.org, dh.herrmann@gmail.com, hughd@google.com,
        bobby.prani@gmail.com, serge.hallyn@ubuntu.com, ebiederm@xmission.com,
        tim.bird@sonymobile.com, josh@joshtriplett.org, koct9i@gmail.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v3 01/20] selftests/breakpoints: add install target to enable test install
Date: Wed, 24 Dec 2014 09:27:37 -0700
Message-Id: <0a42ee9b3e243c71927d7d71c5cb6e5f5ade510e.1419387513.git.shuahkh@osg.samsung.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1419387513.git.shuahkh@osg.samsung.com>
References: <cover.1419387513.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1419387513.git.shuahkh@osg.samsung.com>
References: <cover.1419387513.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new make target to enable installing test. This target
installs test in the kselftest install location and add to the
kselftest script to run the test. Install target can be run
only from top level kernel source directory.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 tools/testing/selftests/breakpoints/Makefile | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/breakpoints/Makefile b/tools/testing/selftests/breakpoints/Makefile
index e18b42b..b5a5fe8 100644
--- a/tools/testing/selftests/breakpoints/Makefile
+++ b/tools/testing/selftests/breakpoints/Makefile
@@ -8,6 +8,7 @@ ifeq ($(ARCH),x86_64)
 	ARCH := x86
 endif
 
+TEST_STR = ./breakpoint_test || echo breakpoints selftests: [FAIL]
 
 all:
 ifeq ($(ARCH),x86)
@@ -16,8 +17,22 @@ else
 	echo "Not an x86 target, can't build breakpoints selftests"
 endif
 
-run_tests:
-	@./breakpoint_test || echo "breakpoints selftests: [FAIL]"
+install:
+ifdef INSTALL_KSFT_PATH
+ifeq ($(ARCH),x86)
+	install ./breakpoint_test $(INSTALL_KSFT_PATH)
+	@echo "$(TEST_STR)" >> $(KSELFTEST)
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
2.1.0

