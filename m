Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911AbaGAJh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 05:37:57 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33593 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757768AbaGAJfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 05:35:12 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux@maxim.org.za, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Boris Brezillon <boris@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v2 02/14] AT91: generic.h: Add include safe guards
Date: Tue,  1 Jul 2014 11:33:15 +0200
Message-Id: <1404207208-14513-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404207208-14513-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1404207208-14513-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The generic.h header file doesn't have any safe guards against multiple
inclusion. It only worked so far because all the symbols defined in it were
extern, but this is a rather fragile assumption.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-at91/generic.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/mach-at91/generic.h b/arch/arm/mach-at91/generic.h
index 631fa3b8c16d..77d4daeee66a 100644
--- a/arch/arm/mach-at91/generic.h
+++ b/arch/arm/mach-at91/generic.h
@@ -8,6 +8,9 @@
  * published by the Free Software Foundation.
  */
 
+#ifndef _AT91_GENERIC_H
+#define _AT91_GENERIC_H
+
 #include <linux/clkdev.h>
 #include <linux/of.h>
 #include <linux/reboot.h>
@@ -90,3 +93,5 @@ extern int  __init at91_gpio_of_irq_setup(struct device_node *node,
 					  struct device_node *parent);
 
 extern u32 at91_get_extern_irq(void);
+
+#endif /* _AT91_GENERIC_H */
-- 
2.0.0

