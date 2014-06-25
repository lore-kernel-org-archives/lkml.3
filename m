Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921AbaFYRnt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 13:43:49 -0400
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:57644
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757815AbaFYRns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 13:43:48 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: gregkh@linuxfoundation.org, akpm@linux-foundation.org
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] tools: cpu-hotplug fix unexpected operator error
Date: Wed, 25 Jun 2014 11:43:44 -0600
Message-Id: <1403718224-8297-1-git-send-email-shuah.kh@samsung.com>
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
 tools/testing/selftests/cpu-hotplug/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cpu-hotplug/Makefile b/tools/testing/selftests/cpu-hotplug/Makefile
index ae5faf9..790c23a 100644
--- a/tools/testing/selftests/cpu-hotplug/Makefile
+++ b/tools/testing/selftests/cpu-hotplug/Makefile
@@ -1,6 +1,6 @@
 all:
 
 run_tests:
-	@/bin/sh ./on-off-test.sh || echo "cpu-hotplug selftests: [FAIL]"
+	@/bin/bash ./on-off-test.sh || echo "cpu-hotplug selftests: [FAIL]"
 
 clean:
-- 
1.9.1

