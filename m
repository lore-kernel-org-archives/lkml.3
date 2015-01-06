Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932777AbbAFTyM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:54:12 -0500
Received: from resqmta-ch2-04v.sys.comcast.net ([69.252.207.36]:49383 "EHLO
	resqmta-ch2-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932684AbbAFTn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:43:56 -0500
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
Subject: [PATCH v4 11/20] selftests/mqueue: add install target to enable test install
Date: Tue,  6 Jan 2015 12:43:25 -0700
Message-Id: <9d5b3b0d9331dc373942f62633c0a5263c40943b.1420571615.git.shuahkh@osg.samsung.com>
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
 tools/testing/selftests/mqueue/Makefile | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mqueue/Makefile b/tools/testing/selftests/mqueue/Makefile
index 8056e2e..813c9e2 100644
--- a/tools/testing/selftests/mqueue/Makefile
+++ b/tools/testing/selftests/mqueue/Makefile
@@ -1,10 +1,22 @@
+MQ_OPEN_TEST_STR = ./mq_open_tests /test1 || echo 'mq_open_tests: [FAIL]'
+MQ_PERF_TEST_STR = ./mq_perf_tests || echo 'mq_perf_tests: [FAIL]'
+
 all:
 	gcc -O2 mq_open_tests.c -o mq_open_tests -lrt
 	gcc -O2 -o mq_perf_tests mq_perf_tests.c -lrt -lpthread -lpopt
 
-run_tests:
-	@./mq_open_tests /test1 || echo "mq_open_tests: [FAIL]"
-	@./mq_perf_tests || echo "mq_perf_tests: [FAIL]"
+install:
+ifdef INSTALL_KSFT_PATH
+	install ./mq_open_tests ./mq_perf_tests $(INSTALL_KSFT_PATH)
+	@echo "$(MQ_OPEN_TEST_STR)" >> $(KSELFTEST)
+	@echo "$(MQ_PERF_TEST_STR)" >> $(KSELFTEST)
+else
+	@echo "Run make kselftest_install in top level source directory"
+endif
+
+run_tests: all
+	@$(MQ_OPEN_TEST_STR)
+	@$(MQ_PERF_TEST_STR)
 
 clean:
 	rm -f mq_open_tests mq_perf_tests
-- 
2.1.0

