Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbaLXQfd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 11:35:33 -0500
Received: from resqmta-po-03v.sys.comcast.net ([96.114.154.162]:36929 "EHLO
	resqmta-po-03v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751496AbaLXQ2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 11:28:04 -0500
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
Subject: [PATCH v3 03/20] selftests/efivarfs: add install target to enable test install
Date: Wed, 24 Dec 2014 09:27:39 -0700
Message-Id: <5ec69d133b16dfdaca04fcbd8f4193c675415f61.1419387513.git.shuahkh@osg.samsung.com>
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
 tools/testing/selftests/efivarfs/Makefile | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/efivarfs/Makefile b/tools/testing/selftests/efivarfs/Makefile
index 29e8c6b..aaf404b 100644
--- a/tools/testing/selftests/efivarfs/Makefile
+++ b/tools/testing/selftests/efivarfs/Makefile
@@ -3,10 +3,22 @@ CFLAGS = -Wall
 
 test_objs = open-unlink create-read
 
-all: $(test_objs)
+TEST_STR = /bin/bash ./efivarfs.sh || echo efivarfs selftests: [FAIL]
+
+all:
+	gcc open-unlink.c -o open-unlink
+	gcc create-read.c -o create-read
+
+install:
+ifdef INSTALL_KSFT_PATH
+	install ./efivarfs.sh $(test_objs) $(INSTALL_KSFT_PATH)
+	@echo "$(TEST_STR)" >> $(KSELFTEST)
+else
+	@echo Run make kselftest_install in top level source directory
+endif
 
 run_tests: all
-	@/bin/bash ./efivarfs.sh || echo "efivarfs selftests: [FAIL]"
+	@$(TEST_STR)
 
 clean:
 	rm -f $(test_objs)
-- 
2.1.0

