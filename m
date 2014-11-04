Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbaKDRSp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 12:18:45 -0500
Received: from mailout.easymail.ca ([64.68.201.169]:50543 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbaKDRSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 12:18:22 -0500
X-Quarantine-ID: <YR-9Yzg1lbr4>
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
Subject: [PATCH 14/20] selftests/mqueue: add install target to enable installing test
Date: Tue,  4 Nov 2014 10:11:10 -0700
Message-Id: <05a2c2d380f841eb25d5840edccb6778541af832.1415117102.git.shuahkh@osg.samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1415117102.git.shuahkh@osg.samsung.com>
References: <cover.1415117102.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1415117102.git.shuahkh@osg.samsung.com>
References: <cover.1415117102.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new make target to enable installing test. This target
installs test in the kselftest install location and add to the
kselftest script to run the test.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 tools/testing/selftests/mqueue/Makefile | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/mqueue/Makefile b/tools/testing/selftests/mqueue/Makefile
index 8056e2e..b0b5ef7 100644
--- a/tools/testing/selftests/mqueue/Makefile
+++ b/tools/testing/selftests/mqueue/Makefile
@@ -2,6 +2,14 @@ all:
 	gcc -O2 mq_open_tests.c -o mq_open_tests -lrt
 	gcc -O2 -o mq_perf_tests mq_perf_tests.c -lrt -lpthread -lpopt
 
+install: all
+	install ./mq_open_tests $(INSTALL_KSFT_PATH)
+	install ./mq_perf_tests $(INSTALL_KSFT_PATH)
+	echo "\necho \"Start mqueue test ....\"" >> $(KSELFTEST)
+	echo "./mq_open_tests /test1 || echo \"mq_open_tests: [FAIL]\"" >> $(KSELFTEST)
+	echo "./mq_perf_tests || echo \"mq_perf_tests: [FAIL]\"" >> $(KSELFTEST)
+	echo "echo \"==============================\"" >> $(KSELFTEST)
+
 run_tests:
 	@./mq_open_tests /test1 || echo "mq_open_tests: [FAIL]"
 	@./mq_perf_tests || echo "mq_perf_tests: [FAIL]"
-- 
1.9.1

