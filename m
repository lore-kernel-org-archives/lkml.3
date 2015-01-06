Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933019AbbAFTw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:52:59 -0500
Received: from resqmta-ch2-11v.sys.comcast.net ([69.252.207.43]:50627 "EHLO
	resqmta-ch2-11v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932703AbbAFTn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:43:59 -0500
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
Subject: [PATCH v4 15/20] selftests/sysctl: add install target to enable test install
Date: Tue,  6 Jan 2015 12:43:29 -0700
Message-Id: <cfcfa29c9030a6b8d2149b3fe834d65a9069717b.1420571615.git.shuahkh@osg.samsung.com>
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
 tools/testing/selftests/sysctl/Makefile | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/sysctl/Makefile b/tools/testing/selftests/sysctl/Makefile
index 0a92ada..9119ef1 100644
--- a/tools/testing/selftests/sysctl/Makefile
+++ b/tools/testing/selftests/sysctl/Makefile
@@ -4,12 +4,25 @@
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
+	@echo "$(NUMERIC_TEST_STR)" >> $(KSELFTEST)
+	@echo "$(STRING_TEST_STR)" >> $(KSELFTEST)
+else
+	@echo "Run make kselftest_install in top level source directory"
+endif
 
 run_tests: all test_num test_string
 
-- 
2.1.0

