Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419AbbAGSgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 13:36:09 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:38687 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbbAGSgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 13:36:07 -0500
From: Andrey Skvortsov <andrej.skvortzov@gmail.com>
X-Google-Original-From: Andrey Skvortsov <Andrej.Skvortzov@gmail.com>
To: Shuah Khan <shuahkh@osg.samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <koct9i@gmail.com>, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Andrey Skvortsov <andrej.skvortzov@gmail.com>
Subject: [PATCH] selftests/vm: fix link error for transhuge-stress test
Date: Wed,  7 Jan 2015 21:35:54 +0300
Message-Id: <1420655754-10076-1-git-send-email-Andrej.Skvortzov@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add -lrt to fix undefined reference to `clock_gettime'

Signed-off-by: Andrey Skvortsov <andrej.skvortzov@gmail.com>
---
 tools/testing/selftests/vm/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/vm/Makefile b/tools/testing/selftests/vm/Makefile
index 4c4b1f6..077828c 100644
--- a/tools/testing/selftests/vm/Makefile
+++ b/tools/testing/selftests/vm/Makefile
@@ -7,7 +7,7 @@ BINARIES += transhuge-stress
 
 all: $(BINARIES)
 %: %.c
-	$(CC) $(CFLAGS) -o $@ $^
+	$(CC) $(CFLAGS) -o $@ $^ -lrt
 
 run_tests: all
 	@/bin/sh ./run_vmtests || (echo "vmtests: [FAIL]"; exit 1)
-- 
1.7.9.5

