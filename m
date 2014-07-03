Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473AbaGCOuP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:50:15 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51825 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758626AbaGCOuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 10:50:08 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux@maxim.org.za, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        dwmw2@infradead.org, dbaryshkov@gmail.com
Cc: Boris Brezillon <boris@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH RESEND 08/18] AT91: soc: Introduce register_devices callback
Date: Thu,  3 Jul 2014 16:41:23 +0200
Message-Id: <1404398493-28907-9-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404398493-28907-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1404398493-28907-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some core devices should be registered by the SoC itself rather than by every
board using this SoC. Introduce a register_devices callback that should be
called during the init_machine in order to do that.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-at91/generic.h | 2 ++
 arch/arm/mach-at91/setup.c   | 5 +++++
 arch/arm/mach-at91/soc.h     | 1 +
 3 files changed, 8 insertions(+)

diff --git a/arch/arm/mach-at91/generic.h b/arch/arm/mach-at91/generic.h
index 631fa3b8c16d..4c2c96195a50 100644
--- a/arch/arm/mach-at91/generic.h
+++ b/arch/arm/mach-at91/generic.h
@@ -37,6 +37,8 @@ extern int  __init at91_aic5_of_init(struct device_node *node,
 extern void __init at91_sysirq_mask_rtc(u32 rtc_base);
 extern void __init at91_sysirq_mask_rtt(u32 rtt_base);
 
+ /* Devices */
+extern void __init at91_register_devices(void);
 
  /* Timer */
 extern void at91rm9200_ioremap_st(u32 addr);
diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index 71003e40f01c..fe0601e0a3c0 100644
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -508,3 +508,8 @@ void __init at91_initialize(unsigned long main_clock)
 
 	pinctrl_provide_dummies();
 }
+
+void __init at91_register_devices(void)
+{
+	at91_boot_soc.register_devices();
+}
diff --git a/arch/arm/mach-at91/soc.h b/arch/arm/mach-at91/soc.h
index a1e1482c6da8..ab983f2cc7dd 100644
--- a/arch/arm/mach-at91/soc.h
+++ b/arch/arm/mach-at91/soc.h
@@ -11,6 +11,7 @@ struct at91_init_soc {
 	void (*map_io)(void);
 	void (*ioremap_registers)(void);
 	void (*register_clocks)(void);
+	void (*register_devices)(void);
 	void (*init)(void);
 };
 
-- 
2.0.1

