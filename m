Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751AbaJBHYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 03:24:25 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:53786 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaJBHYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 03:24:24 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] memstick: r592: Fix build warnings for !PM_SLEEP
Date: Thu,  2 Oct 2014 09:24:21 +0200
Message-Id: <1412234661-21909-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

When PM_SLEEP is not enabled, the r592_clear_interrupts() function is
never used. If so, don't build it to prevent a compiler warning.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/memstick/host/r592.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/memstick/host/r592.c b/drivers/memstick/host/r592.c
index 31727bf285d0..e2a4f5f415b2 100644
--- a/drivers/memstick/host/r592.c
+++ b/drivers/memstick/host/r592.c
@@ -188,6 +188,7 @@ static void r592_host_reset(struct r592_device *dev)
 	r592_set_mode(dev, dev->parallel_mode);
 }
 
+#ifdef CONFIG_PM_SLEEP
 /* Disable all hardware interrupts */
 static void r592_clear_interrupts(struct r592_device *dev)
 {
@@ -195,6 +196,7 @@ static void r592_clear_interrupts(struct r592_device *dev)
 	r592_clear_reg_mask(dev, R592_REG_MSC, IRQ_ALL_ACK_MASK);
 	r592_clear_reg_mask(dev, R592_REG_MSC, IRQ_ALL_EN_MASK);
 }
+#endif
 
 /* Tests if there is an CRC error */
 static int r592_test_io_error(struct r592_device *dev)
-- 
2.1.0

