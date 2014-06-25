Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388AbaFYVbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 17:31:42 -0400
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:36784
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753932AbaFYVbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 17:31:41 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: gregkh@linuxfoundation.org, akpm@linux-foundation.org
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] tools: memory-hotplug fix unexpected operator error
Date: Wed, 25 Jun 2014 15:31:37 -0600
Message-Id: <1403731897-11992-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on-off-test is a bash script and invoked from /bin/sh
This results in the following error:

./on-off-test.sh: 9: [: !=: unexpected operator

Changed Makefile to use bash instead.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 tools/testing/selftests/memory-hotplug/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/memory-hotplug/Makefile b/tools/testing/selftests/memory-hotplug/Makefile
index 350bfed..058c76f 100644
--- a/tools/testing/selftests/memory-hotplug/Makefile
+++ b/tools/testing/selftests/memory-hotplug/Makefile
@@ -1,6 +1,6 @@
 all:
 
 run_tests:
-	@/bin/sh ./on-off-test.sh || echo "memory-hotplug selftests: [FAIL]"
+	@/bin/bash ./on-off-test.sh || echo "memory-hotplug selftests: [FAIL]"
 
 clean:
-- 
1.9.1

