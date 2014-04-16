Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbaDPRQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 13:16:59 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:34282 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238AbaDPROY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 13:14:24 -0400
From: Sergei Ianovich <ynvich@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Sergei Ianovich <ynvich@gmail.com>, Daniel Mack <zonque@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH v4 04/21] ARM: dts: pxa3xx: move declaration to header
Date: Wed, 16 Apr 2014 21:13:14 +0400
Message-Id: <1397668411-27162-5-git-send-email-ynvich@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1397668411-27162-1-git-send-email-ynvich@gmail.com>
References: <1387309071-22382-1-git-send-email-ynvich@gmail.com>
 <1397668411-27162-1-git-send-email-ynvich@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This way it will be more difficult to change the declaration in one
place, but not the other.

In addition, the change allows to use the binding for pxa-gpio on
other PXA CPUs.

Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
CC: Daniel Mack <zonque@gmail.com>
CC: Haojian Zhuang <haojian.zhuang@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>
---
   v3..v4
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

