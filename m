Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751231AbaK0SRX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 13:17:23 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:51916 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbaK0SRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 13:17:21 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: grant.likely@linaro.org, fengguang.wu@intel.com
Cc: kbuild-all@01.org, gregkh@linuxfoundation.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: [PATCH V2 1/2] m32r: Fix ioread8 definition
Date: Thu, 27 Nov 2014 10:16:32 -0800
Message-Id: <1417112193-14400-1-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should be readb(), not read().

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/m32r/include/asm/io.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/m32r/include/asm/io.h b/arch/m32r/include/asm/io.h
index 4010f1f..343ae4c 100644
--- a/arch/m32r/include/asm/io.h
+++ b/arch/m32r/include/asm/io.h
@@ -162,7 +162,7 @@ static inline void _writel(unsigned long l, unsigned long addr)
 #define __raw_writew writew
 #define __raw_writel writel
 
-#define ioread8 read
+#define ioread8 readb
 #define ioread16 readw
 #define ioread32 readl
 #define iowrite8 writeb
-- 
2.1.0

