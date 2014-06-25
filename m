Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbaFYALf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 20:11:35 -0400
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:55983 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753530AbaFYALd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 20:11:33 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: gregkh@linuxfoundation.org
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] tools: fix kcmp_test compile warnings
Date: Tue, 24 Jun 2014 18:11:26 -0600
Message-Id: <1403655086-32085-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kcmp_test.c: In function ‘main’:
kcmp_test.c:85:5: warning: format ‘%li’ expects argument of type ‘long int’, but argument 2 has type ‘int’ [-Wformat=]
     ret, strerror(errno));
     ^

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 tools/testing/selftests/kcmp/kcmp_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kcmp/kcmp_test.c b/tools/testing/selftests/kcmp/kcmp_test.c
index fa4f1b3..dbba408 100644
--- a/tools/testing/selftests/kcmp/kcmp_test.c
+++ b/tools/testing/selftests/kcmp/kcmp_test.c
@@ -81,7 +81,7 @@ int main(int argc, char **argv)
 		/* Compare with self */
 		ret = sys_kcmp(pid1, pid1, KCMP_VM, 0, 0);
 		if (ret) {
-			printf("FAIL: 0 expected but %li returned (%s)\n",
+			printf("FAIL: 0 expected but %d returned (%s)\n",
 				ret, strerror(errno));
 			ret = -1;
 		} else
-- 
1.9.1

