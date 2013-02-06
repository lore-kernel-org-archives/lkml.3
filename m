Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720Ab3BFWXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:23:19 -0500
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:49385 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758357Ab3BFWXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:23:15 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH] mfd: ab8500: fix compile error
Date: Wed, 6 Feb 2013 23:23:01 +0100
Message-ID: <1360189381-3259-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

When compiling the AB8500 core driver in the latest
MFD tree the following happens:

  CC      drivers/mfd/ab8500-debugfs.o
/home/elinwal/linux-next/drivers/mfd/ab8500-debugfs.c:157:3: error: 'AB8500_SYS_CTRL1_BLOCK' undeclared here (not in a function)
/home/elinwal/linux-next/drivers/mfd/ab8500-debugfs.c:157:2: error: array index in initializer not of integer type
/home/elinwal/linux-next/drivers/mfd/ab8500-debugfs.c:157:2: error: (near initialization for 'debug_ranges')
(...)

This is due to a missing include statement, so fix
it up.

Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/ab8500-debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index ba25f95..45fe3c5 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -82,6 +82,7 @@
 #include <linux/slab.h>
 
 #include <linux/mfd/abx500.h>
+#include <linux/mfd/abx500/ab8500.h>
 #include <linux/mfd/abx500/ab8500-gpadc.h>
 
 #ifdef CONFIG_DEBUG_FS
-- 
1.7.11.3

