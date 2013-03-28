Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339Ab3C1JpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 05:45:25 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:36546 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215Ab3C1JpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 05:45:24 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ARM: irq: Call irqchit_init if no init_irq function is specified
Date: Thu, 28 Mar 2013 10:41:43 +0100
Message-Id: <1364463704-13692-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364463704-13692-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1364463704-13692-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More and more sub-architectures are using only the irqchip_init
function. Make the core code call this function if no init_irq field is
provided in the machine description to remove some boilerplate code.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/kernel/irq.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kernel/irq.c b/arch/arm/kernel/irq.c
index 8e4ef4c..df6f9a1 100644
--- a/arch/arm/kernel/irq.c
+++ b/arch/arm/kernel/irq.c
@@ -26,6 +26,7 @@
 #include <linux/ioport.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
+#include <linux/irqchip.h>
 #include <linux/random.h>
 #include <linux/smp.h>
 #include <linux/init.h>
@@ -114,7 +115,10 @@ EXPORT_SYMBOL_GPL(set_irq_flags);
 
 void __init init_IRQ(void)
 {
-	machine_desc->init_irq();
+	if (machine_desc->init_irq)
+		machine_desc->init_irq();
+	else
+		irqchip_init();
 }
 
 #ifdef CONFIG_MULTI_IRQ_HANDLER
-- 
1.7.10.4

