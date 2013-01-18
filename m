Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab3ARVwx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 16:52:53 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:40433 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab3ARVww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 16:52:52 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] fs: timerfd.c: fix build error
Date: Fri, 18 Jan 2013 22:52:52 +0100
Message-Id: <1358545972-20947-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Invalid number of parentheses if macro COMPAT is defined

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 fs/timerfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/timerfd.c b/fs/timerfd.c
index 14ad4f3..0e606b1 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -396,7 +396,7 @@ COMPAT_SYSCALL_DEFINE4(timerfd_settime, int, ufd, int, flags,
 	ret = do_timerfd_settime(ufd, flags, &new, &old);
 	if (ret)
 		return ret;
-	if (otmr && put_compat_itimerspec(otmr, &old)
+	if (otmr && put_compat_itimerspec(otmr, &old))
 		return -EFAULT;
 	return ret;
 }
-- 
1.7.10.4

