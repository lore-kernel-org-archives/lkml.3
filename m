Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933051AbbAFTxk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:53:40 -0500
Received: from resqmta-ch2-12v.sys.comcast.net ([69.252.207.44]:39656 "EHLO
	resqmta-ch2-12v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932695AbbAFTn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:43:57 -0500
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
Subject: [PATCH v4 13/20] selftests/ptrace: add install target to enable test install
Date: Tue,  6 Jan 2015 12:43:27 -0700
Message-Id: <e6e0602db98043998a0059355e4500d0c559953a.1420571615.git.shuahkh@osg.samsung.com>
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
 tools/testing/selftests/ptrace/Makefile | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/ptrace/Makefile b/tools/testing/selftests/ptrace/Makefile
index 47ae2d3..6fc352c 100644
--- a/tools/testing/selftests/ptrace/Makefile
+++ b/tools/testing/selftests/ptrace/Makefile
@@ -1,10 +1,20 @@
 CFLAGS += -iquote../../../../include/uapi -Wall
-peeksiginfo: peeksiginfo.c
 
-all: peeksiginfo
+TEST_STR = ./peeksiginfo || echo 'peeksiginfo selftests: [FAIL]'
+
+all:
+	gcc peeksiginfo.c -o peeksiginfo
+
+install:
+ifdef INSTALL_KSFT_PATH
+	install ./peeksiginfo $(INSTALL_KSFT_PATH)
+	@echo "$(TEST_STR)" >> $(KSELFTEST)
+else
+	@echo "Run make kselftest_install in top level source directory"
+endif
 
 clean:
 	rm -f peeksiginfo
 
 run_tests: all
-	@./peeksiginfo || echo "peeksiginfo selftests: [FAIL]"
+	@$(TEST_STR)
-- 
2.1.0

