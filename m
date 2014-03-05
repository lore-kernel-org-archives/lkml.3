Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbaCEQ7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 11:59:00 -0500
Received: from fallback7.mail.ru ([94.100.176.135]:34850 "EHLO
	fallback7.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755658AbaCEQ64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 11:58:56 -0500
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH v2] irq: Export symbol no_action()
Date: Wed,  5 Mar 2014 20:58:33 +0400
Message-Id: <1394038713-23337-1-git-send-email-shc_work@mail.ru>
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
index bfec453..6354802 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -41,6 +41,7 @@ irqreturn_t no_action(int cpl, void *dev_id)
 {
 	return IRQ_NONE;
 }
+EXPORT_SYMBOL_GPL(no_action);
 
 static void warn_no_thread(unsigned int irq, struct irqaction *action)
 {
-- 
1.8.3.2

