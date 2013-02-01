Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542Ab3BAUn3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 15:43:29 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:21477 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757525Ab3BAUnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 15:43:25 -0500
Message-ID: <201302012043.r11KhNZF024371@farm-0021.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 1 Feb 2013 15:04:26 -0500
Subject: [PATCH] Export {enable,disable}_percpu_irq().
To: <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These functions are used by (for example) the tilegx onchip
network driver, and it's useful to be able to load that driver
as a module.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 kernel/irq/manage.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index e49a288..88e7bed 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1524,6 +1524,7 @@ void enable_percpu_irq(unsigned int irq, unsigned int type)
 out:
 	irq_put_desc_unlock(desc, flags);
 }
+EXPORT_SYMBOL_GPL(enable_percpu_irq);
 
 void disable_percpu_irq(unsigned int irq)
 {
@@ -1537,6 +1538,7 @@ void disable_percpu_irq(unsigned int irq)
 	irq_percpu_disable(desc, cpu);
 	irq_put_desc_unlock(desc, flags);
 }
+EXPORT_SYMBOL_GPL(disable_percpu_irq);
 
 /*
  * Internal function to unregister a percpu irqaction.
-- 
1.7.10.3

