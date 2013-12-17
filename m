Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab3LQTso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 14:48:44 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:43678 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab3LQTin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 14:38:43 -0500
From: Sergei Ianovich <ynvich@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Sergei Ianovich <ynvich@gmail.com>, Daniel Mack <zonque@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: [PATCH v3 04/21] ARM: dts: pxa3xx: move declaration to header
Date: Tue, 17 Dec 2013 23:37:34 +0400
Message-Id: <1387309071-22382-5-git-send-email-ynvich@gmail.com>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1387309071-22382-1-git-send-email-ynvich@gmail.com>
References: <1386901645-28895-1-git-send-email-ynvich@gmail.com>
 <1387309071-22382-1-git-send-email-ynvich@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This way it will be more difficult to change the declaration in one
place, but not the other.

In addition, the change allows to use the binding for pxa-gpio on
other PXA CPUs.

Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
CC: Daniel Mack <zonque@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>
---
   v2..v3
   * no changes

   v1..v2
   * drop #ifdef in header file
   * number changed from 6 to 4 (dropped patches)

 arch/arm/mach-pxa/include/mach/irqs.h | 2 ++
 arch/arm/mach-pxa/pxa3xx.c            | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-pxa/include/mach/irqs.h b/arch/arm/mach-pxa/include/mach/irqs.h
index 48c2fd8..732315d 100644
--- a/arch/arm/mach-pxa/include/mach/irqs.h
+++ b/arch/arm/mach-pxa/include/mach/irqs.h
@@ -113,4 +113,6 @@ void ichp_handle_irq(struct pt_regs *);
 void pxa_init_irq(int irq_nr, int (*set_wake)(struct irq_data *, unsigned int));
 #endif
 
+extern void __init pxa_dt_irq_init(int (*fn)(struct irq_data *, unsigned int));
+
 #endif /* __ASM_MACH_IRQS_H */
diff --git a/arch/arm/mach-pxa/pxa3xx.c b/arch/arm/mach-pxa/pxa3xx.c
index 87011f3..2397dec 100644
--- a/arch/arm/mach-pxa/pxa3xx.c
+++ b/arch/arm/mach-pxa/pxa3xx.c
@@ -42,8 +42,6 @@
 #define PECR_IE(n)	((1 << ((n) * 2)) << 28)
 #define PECR_IS(n)	((1 << ((n) * 2)) << 29)
 
-extern void __init pxa_dt_irq_init(int (*fn)(struct irq_data *, unsigned int));
-
 static DEFINE_PXA3_CKEN(pxa3xx_ffuart, FFUART, 14857000, 1);
 static DEFINE_PXA3_CKEN(pxa3xx_btuart, BTUART, 14857000, 1);
 static DEFINE_PXA3_CKEN(pxa3xx_stuart, STUART, 14857000, 1);
-- 
1.8.4.2

