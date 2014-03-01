Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbaCAGpv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 01:45:51 -0500
Received: from fallback5.mail.ru ([94.100.176.59]:44243 "EHLO
	fallback5.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbaCAGpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 01:45:50 -0500
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Mark Brown <broonie@kernel.org>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH] irq: Export symbol no_action()
Date: Sat,  1 Mar 2014 10:45:16 +0400
Message-Id: <1393656316-26757-1-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.8.3.2
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will allow to use dummy IRQ handler no_action() from
drivers compiled as module. For example, dummy handler is could
be used for drivers that use ARM FIQ interrupts.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 kernel/irq/handle.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index bfec453..e8ddcbf 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -41,6 +41,7 @@ irqreturn_t no_action(int cpl, void *dev_id)
 {
 	return IRQ_NONE;
 }
+EXPORT_SYMBOL(no_action);
 
 static void warn_no_thread(unsigned int irq, struct irqaction *action)
 {
-- 
1.8.3.2

