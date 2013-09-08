Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab3IHHZo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 03:25:44 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:37571 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab3IHHZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 03:25:43 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] mfd: sm501: dbg_regs attribute must be read-only
Date: Sun,  8 Sep 2013 00:25:36 -0700
Message-Id: <1378625136-8823-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix:

sm501 sm501: SM501 At b3e00000: Version 050100a0, 8 Mb, IRQ 100
Attribute dbg_regs: write permission without 'store'
------------[ cut here ]------------
WARNING: at drivers/base/core.c:620

dbg_regs does not have a write function and must therefore be marked
as read-only.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/mfd/sm501.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/sm501.c b/drivers/mfd/sm501.c
index 33f040c..3799a3d 100644
--- a/drivers/mfd/sm501.c
+++ b/drivers/mfd/sm501.c
@@ -1232,7 +1232,7 @@ static ssize_t sm501_dbg_regs(struct device *dev,
 }
 
 
-static DEVICE_ATTR(dbg_regs, 0666, sm501_dbg_regs, NULL);
+static DEVICE_ATTR(dbg_regs, 0444, sm501_dbg_regs, NULL);
 
 /* sm501_init_reg
  *
-- 
1.7.9.7

