Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602AbbAFTuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:50:19 -0500
Received: from resqmta-ch2-12v.sys.comcast.net ([69.252.207.44]:39684 "EHLO
	resqmta-ch2-12v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932719AbbAFToD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:44:03 -0500
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
Subject: [PATCH v4 18/20] selftests/vm: add install target to enable test install
Date: Tue,  6 Jan 2015 12:43:32 -0700
Message-Id: <30a7adbde0f926970d0fa18e825f084a63b46940.1420571615.git.shuahkh@osg.samsung.com>
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
 tools/testing/selftests/vm/Makefile | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/vm/Makefile b/tools/testing/selftests/vm/Makefile
index 4c4b1f6..3312057 100644
--- a/tools/testing/selftests/vm/Makefile
+++ b/tools/testing/selftests/vm/Makefile
@@ -4,13 +4,22 @@ CC = $(CROSS_COMPILE)gcc
 CFLAGS = -Wall
 BINARIES = hugepage-mmap hugepage-shm map_hugetlb thuge-gen hugetlbfstest
 BINARIES += transhuge-stress
+TEST_STR = /bin/sh ./run_vmtests || echo 'vmtests: [FAIL]'
 
 all: $(BINARIES)
 %: %.c
 	$(CC) $(CFLAGS) -o $@ $^
 
+install:
+ifdef INSTALL_KSFT_PATH
+	install run_vmtests $(BINARIES) $(INSTALL_KSFT_PATH)
+	@echo "$(TEST_STR)" >> $(KSELFTEST)
+else
+	@echo "Run make kselftest_install in top level source directory"
+endif
+
 run_tests: all
-	@/bin/sh ./run_vmtests || (echo "vmtests: [FAIL]"; exit 1)
+	@$(TEST_STR)
 
 clean:
 	$(RM) $(BINARIES)
-- 
2.1.0

