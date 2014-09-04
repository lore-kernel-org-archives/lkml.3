Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705AbaIDPH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 11:07:28 -0400
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:48095
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751298AbaIDPH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 11:07:26 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: dh.herrmann@gmail.com, akpm@linux-foundation.org, bobby.prani@gmail.com,
        hughd@google.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] selftests/memfd: fix mfd_fail_open() to pass in buf to printf
Date: Thu,  4 Sep 2014 09:07:22 -0600
Message-Id: <1409843242-6596-1-git-send-email-shuahkh@osg.samsung.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mfd_fail_open() doesn't pass in the buffer to printf resulting
in the following warning:

memfd_test.c: In function ‘mfd_fail_open’:
memfd_test.c:208:3: warning: format ‘%s’ expects a matching ‘char *’ argument [-Wformat=]
   printf("open(%s) didn't fail as expected\n");
   ^

This change fixes the problem.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 tools/testing/selftests/memfd/memfd_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/memfd/memfd_test.c b/tools/testing/selftests/memfd/memfd_test.c
index cb5001b..0b9eafb 100644
--- a/tools/testing/selftests/memfd/memfd_test.c
+++ b/tools/testing/selftests/memfd/memfd_test.c
@@ -203,7 +203,7 @@ static void mfd_fail_open(int fd, int flags, mode_t mode)
 	sprintf(buf, "/proc/self/fd/%d", fd);
 	r = open(buf, flags, mode);
 	if (r >= 0) {
-		printf("open(%s) didn't fail as expected\n");
+		printf("open(%s) didn't fail as expected\n", buf);
 		abort();
 	}
 }
-- 
1.9.1

