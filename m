Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650AbbAFTnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:43:50 -0500
Received: from resqmta-ch2-05v.sys.comcast.net ([69.252.207.37]:60373 "EHLO
	resqmta-ch2-05v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932614AbbAFTnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:43:46 -0500
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
Subject: [PATCH v4 01/20] selftests/breakpoints: add install target to enable test install
Date: Tue,  6 Jan 2015 12:43:15 -0700
Message-Id: <a52b2be855825de0231e1f25cf9776af3c712fac.1420571615.git.shuahkh@osg.samsung.com>
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
 tools/testing/selftests/breakpoints/Makefile | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/breakpoints/Makefile b/tools/testing/selftests/breakpoints/Makefile
index e18b42b..c738d4c 100644
--- a/tools/testing/selftests/breakpoints/Makefile
+++ b/tools/testing/selftests/breakpoints/Makefile
@@ -8,6 +8,7 @@ ifeq ($(ARCH),x86_64)
 	ARCH := x86
 endif
 
+TEST_STR = ./breakpoint_test || echo 'breakpoints selftests: [FAIL]'
 
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
+	@echo "Not an x86 target, unable to install breakpoints selftests"
+endif
+else
+	@echo "Run make kselftest_install in top level source directory"
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

