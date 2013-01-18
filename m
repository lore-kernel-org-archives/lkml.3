Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab3ARUki (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 15:40:38 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:53814 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761Ab3ARUkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 15:40:37 -0500
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH] debugfs: regset32: make struct debugfs_reg32 pointer const
Date: Fri, 18 Jan 2013 22:40:32 +0200
Message-ID: <1358541632-7535-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

no user of that should ever change that pointer,
so let's mark it const to prevent that from
happening.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 include/linux/debugfs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index 66c434f..63f2465 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -33,7 +33,7 @@ struct debugfs_reg32 {
 };
 
 struct debugfs_regset32 {
-	struct debugfs_reg32 *regs;
+	const struct debugfs_reg32 *regs;
 	int nregs;
 	void __iomem *base;
 };
-- 
1.8.1.rc1.5.g7e0651a

