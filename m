Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757818AbaGAJfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 05:35:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33567 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757762AbaGAJfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 05:35:06 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux@maxim.org.za, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Boris Brezillon <boris@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v2 11/14] AT91: soc: Add init_time callback
Date: Tue,  1 Jul 2014 11:33:24 +0200
Message-Id: <1404207208-14513-12-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404207208-14513-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1404207208-14513-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce an init_time callback to the at91_init_soc structure to be able to
tweak the init_time machine callback on a per-soc basis, instead of having to
rely on a global one.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-at91/generic.h | 1 +
 arch/arm/mach-at91/setup.c   | 5 +++++
 arch/arm/mach-at91/soc.h     | 1 +
 3 files changed, 7 insertions(+)

diff --git a/arch/arm/mach-at91/generic.h b/arch/arm/mach-at91/generic.h
index 77d4daeee66a..eb5512c3d717 100644
--- a/arch/arm/mach-at91/generic.h
+++ b/arch/arm/mach-at91/generic.h
@@ -42,6 +42,7 @@ extern void __init at91_sysirq_mask_rtt(u32 rtt_base);
 
 
  /* Timer */
+extern void __init at91_init_time(void);
 extern void at91rm9200_ioremap_st(u32 addr);
 extern void at91rm9200_timer_init(void);
 extern void at91sam926x_ioremap_pit(u32 addr);
diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index f7a07a58ebb6..f8bd8d2c8205 100644
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -533,3 +533,8 @@ void __init at91_initialize(unsigned long main_clock)
 
 	pinctrl_provide_dummies();
 }
+
+void __init at91_init_time(void)
+{
+	at91_boot_soc.init_time();
+}
diff --git a/arch/arm/mach-at91/soc.h b/arch/arm/mach-at91/soc.h
index a1e1482c6da8..57b9dda6eb83 100644
--- a/arch/arm/mach-at91/soc.h
+++ b/arch/arm/mach-at91/soc.h
@@ -12,6 +12,7 @@ struct at91_init_soc {
 	void (*ioremap_registers)(void);
 	void (*register_clocks)(void);
 	void (*init)(void);
+	void (*init_time)(void);
 };
 
 extern struct at91_init_soc at91_boot_soc;
-- 
2.0.0

