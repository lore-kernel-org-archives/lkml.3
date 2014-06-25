Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbaFYB7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 21:59:50 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:36858 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751890AbaFYB7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 21:59:49 -0400
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Jun 2014 21:59:49 EDT
From: Shuah Khan <shuah.kh@samsung.com>
To: gregkh@linuxfoundation.org
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] tools: Fix mqueue Makefile compile linking order
Date: Tue, 24 Jun 2014 19:53:36 -0600
Message-Id: <1403661216-2023-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Makefile compile linking order is incorrect causing the compile
to fail not finding librt symbols.

/tmp/cceTqwFh.o: In function `test_queue_fail':
mq_open_tests.c:(.text+0x6b): undefined reference to `mq_open'
mq_open_tests.c:(.text+0x80): undefined reference to `mq_getattr'
mq_open_tests.c:(.text+0xa2): undefined reference to `mq_close'
mq_open_tests.c:(.text+0xcf): undefined reference to `mq_unlink'
/tmp/cceTqwFh.o: In function `test_queue.constprop.6':
mq_open_tests.c:(.text+0x15a): undefined reference to `mq_open'
mq_open_tests.c:(.text+0x16f): undefined reference to `mq_getattr'
mq_open_tests.c:(.text+0x195): undefined reference to `mq_close'
mq_open_tests.c:(.text+0x1c2): undefined reference to `mq_unlink'
/tmp/cceTqwFh.o: In function `shutdown.part.0':
mq_open_tests.c:(.text.unlikely+0x5b): undefined reference to `mq_close'
mq_open_tests.c:(.text.unlikely+0x7a): undefined reference to `mq_unlink'
collect2: error: ld returned 1 exit status
make: *** [all] Error 1

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 tools/testing/selftests/mqueue/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mqueue/Makefile b/tools/testing/selftests/mqueue/Makefile
index 218a122..8056e2e 100644
--- a/tools/testing/selftests/mqueue/Makefile
+++ b/tools/testing/selftests/mqueue/Makefile
@@ -1,6 +1,6 @@
 all:
-	gcc -O2 -lrt mq_open_tests.c -o mq_open_tests
-	gcc -O2 -lrt -lpthread -lpopt -o mq_perf_tests mq_perf_tests.c
+	gcc -O2 mq_open_tests.c -o mq_open_tests -lrt
+	gcc -O2 -o mq_perf_tests mq_perf_tests.c -lrt -lpthread -lpopt
 
 run_tests:
 	@./mq_open_tests /test1 || echo "mq_open_tests: [FAIL]"
-- 
1.9.1

