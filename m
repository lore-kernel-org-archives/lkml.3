Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350Ab3HGJG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 05:06:29 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:52002 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757292Ab3HGJG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 05:06:28 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Akinobu Mita <mita@miraclelinux.com>
Subject: [PATCH] bitops: move BITS() macro to the bitops file
Date: Wed,  7 Aug 2013 11:06:19 +0200
Message-Id: <1375866379-27504-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This macro was invented by Mattias Nilsson for the usecase
where you want to set a sequence of bits inside a n-bit
word, while leaving the head and tail of the sequence all
zeroes. For example:

  #include <linux/bitops.h>

  u16 mask = BITS(4, 12);

Yields a mask like this:

  0001111111110000

This patch moves the construct out of the MFD PRCMU driver
and make it available for common use, after noticing in a
review or two that it would be useful for others.

Cc: Akinobu Mita <mita@miraclelinux.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/dbx500-prcmu-regs.h | 2 --
 include/linux/bitops.h          | 1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mfd/dbx500-prcmu-regs.h b/drivers/mfd/dbx500-prcmu-regs.h
index 4f6f0fa..906e75e 100644
--- a/drivers/mfd/dbx500-prcmu-regs.h
+++ b/drivers/mfd/dbx500-prcmu-regs.h
@@ -13,8 +13,6 @@
 #ifndef __DB8500_PRCMU_REGS_H
 #define __DB8500_PRCMU_REGS_H
 
-#define BITS(_start, _end) ((BIT(_end) - BIT(_start)) + BIT(_end))
-
 #define PRCM_ACLK_MGT		(0x004)
 #define PRCM_SVAMMCSPCLK_MGT	(0x008)
 #define PRCM_SIAMMDSPCLK_MGT	(0x00C)
diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index a3b6b82..1f9d78b 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -6,6 +6,7 @@
 #define BIT(nr)			(1UL << (nr))
 #define BIT_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
 #define BIT_WORD(nr)		((nr) / BITS_PER_LONG)
+#define BITS(_start, _end)	((BIT(_end) - BIT(_start)) + BIT(_end))
 #define BITS_PER_BYTE		8
 #define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
 #endif
-- 
1.8.1.4

