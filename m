Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884Ab3IBIig (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:38:36 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:45722 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757786Ab3IBIie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:38:34 -0400
From: Rostislav Lisovy <lisovy@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, fengguang.wu@intel.com,
        Rostislav Lisovy <lisovy@gmail.com>
Subject: [PATCH] drivers: uio: mf624_disable_interrupt() can be static
Date: Mon,  2 Sep 2013 10:38:33 +0200
Message-Id: <1378111113-28002-1-git-send-email-lisovy@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fengguang Wu <fengguang.wu@intel.com>

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Rostislav Lisovy <lisovy@gmail.com>
---
 drivers/uio/uio_mf624.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/uio/uio_mf624.c b/drivers/uio/uio_mf624.c
index a1768b2..92cf6a9 100644
--- a/drivers/uio/uio_mf624.c
+++ b/drivers/uio/uio_mf624.c
@@ -42,7 +42,7 @@
 
 enum mf624_interrupt_source {ADC, CTR4, ALL};
 
-void mf624_disable_interrupt(enum mf624_interrupt_source source,
+static void mf624_disable_interrupt(enum mf624_interrupt_source source,
 			     struct uio_info *info)
 {
 	void __iomem *INTCSR_reg = info->mem[0].internal_addr + INTCSR;
@@ -70,7 +70,7 @@ void mf624_disable_interrupt(enum mf624_interrupt_source source,
 	}
 }
 
-void mf624_enable_interrupt(enum mf624_interrupt_source source,
+static void mf624_enable_interrupt(enum mf624_interrupt_source source,
 			    struct uio_info *info)
 {
 	void __iomem *INTCSR_reg = info->mem[0].internal_addr + INTCSR;
-- 
1.7.10.4

