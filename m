Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490AbbAFTzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:55:16 -0500
Received: from resqmta-ch2-02v.sys.comcast.net ([69.252.207.34]:49200 "EHLO
	resqmta-ch2-02v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932646AbbAFTnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:43:53 -0500
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
Subject: [PATCH v4 07/20] selftests/kcmp: add install target to enable test install
Date: Tue,  6 Jan 2015 12:43:21 -0700
Message-Id: <0ef6535b2984b1aa16144dbd06b0779d40bb2dc4.1420571615.git.shuahkh@osg.samsung.com>
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
 tools/testing/selftests/kcmp/Makefile | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kcmp/Makefile b/tools/testing/selftests/kcmp/Makefile
index ff0eefd..46267c1 100644
--- a/tools/testing/selftests/kcmp/Makefile
+++ b/tools/testing/selftests/kcmp/Makefile
@@ -1,10 +1,21 @@
 CC := $(CROSS_COMPILE)$(CC)
 CFLAGS += -I../../../../usr/include/
 
+TEST_STR = ./kcmp_test || echo 'kcmp_test: [FAIL]'
+
 all: kcmp_test
 
+install:
+ifdef INSTALL_KSFT_PATH
+	install ./kcmp_test $(INSTALL_KSFT_PATH)
+	@echo "$(TEST_STR)" >> $(KSELFTEST)
+	@echo rm -f kcmp-test-file >> $(KSELFTEST)
+else
+	@echo "Run make kselftest_install in top level source directory"
+endif
+
 run_tests: all
-	@./kcmp_test || echo "kcmp_test: [FAIL]"
+	@$(TEST_STR)
 
 clean:
 	$(RM) kcmp_test kcmp-test-file
-- 
2.1.0

