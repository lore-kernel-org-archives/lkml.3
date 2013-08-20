Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab3HTUxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 16:53:42 -0400
Received: from mout.gmx.net ([212.227.17.21]:52968 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348Ab3HTUxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 16:53:41 -0400
From: dl9pf@gmx.de
To: dl9pf@gmx.de
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [TRIVIAL] Remove braces to fix build for clang. No functional change otherwise.
Date: Tue, 20 Aug 2013 22:52:06 +0200
Message-Id: <1377031926-18436-1-git-send-email-dl9pf@gmx.de>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:cfI2LXmqH8u3xbtDBItGQfHHpm47bRa8t/Tf0wEfuNrmbS7Cgxr
 AJQkZgzTZMPwGx4V3MtiqUSPqqPoXNp+PEePQ7YDqAzXI4ap14Og6ViMZ2vGJR6MMJF+SPD
 y/022lEImxCbV2dQERO9F2QbBf6vqF+JDIyRcPR7fRXcAf7XYuGLpNyoAda9PwoK6z9Qhch
 ZddO6yFK9zxFwqtsYmepg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan-Simon Möller <dl9pf@gmx.de>

Author:  PaX Team <pageexec at freemail.hu>
ML-Post: http://lists.cs.uiuc.edu/pipermail/llvm-commits/Week-of-Mon-20120507/142707.html
URL:     http://llvm.linuxfoundation.org

Merge:   Jan-Simon Möller <dl9pf at gmx.de>

Description:
  Clang chokes on the notation "inl (%dx)" but works for "inl %dx"; GNU as accepts both forms.

Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>

CC: Arnd Bergmann <arnd@arndb.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org
---
 drivers/misc/vmw_balloon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
index cb56e27..2421835 100644
--- a/drivers/misc/vmw_balloon.c
+++ b/drivers/misc/vmw_balloon.c
@@ -133,7 +133,7 @@ MODULE_LICENSE("GPL");
 #define VMWARE_BALLOON_CMD(cmd, data, result)		\
 ({							\
 	unsigned long __stat, __dummy1, __dummy2;	\
-	__asm__ __volatile__ ("inl (%%dx)" :		\
+	__asm__ __volatile__ ("inl %%dx" :		\
 		"=a"(__stat),				\
 		"=c"(__dummy1),				\
 		"=d"(__dummy2),				\
-- 
1.8.1.4

