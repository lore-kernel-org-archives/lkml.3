Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759180AbaIOXwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:52:24 -0400
Received: from mail-oi0-f73.google.com ([209.85.218.73]:61238 "EHLO
	mail-oi0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757227AbaIOXvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 19:51:41 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Jeffrey Deans <jeffrey.deans@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>,
        Qais Yousef <qais.yousef@imgtec.com>, Jonas Gorski <jogo@openwrt.org>,
        John Crispin <blogic@openwrt.org>, David Daney <ddaney.cavm@gmail.com>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH 12/24] MIPS: Move MIPS_GIC_IRQ_BASE into platform irq.h
Date: Mon, 15 Sep 2014 16:51:15 -0700
Message-Id: <1410825087-5497-13-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1410825087-5497-1-git-send-email-abrestic@chromium.org>
References: <1410825087-5497-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define a generic MIPS_GIC_IRQ_BASE which should be suitable for all
current boards in <mach-generic/irq.h>.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 arch/mips/include/asm/mach-generic/irq.h     | 6 ++++++
 arch/mips/include/asm/mips-boards/maltaint.h | 2 --
 arch/mips/include/asm/mips-boards/sead3int.h | 2 --
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/mips/include/asm/mach-generic/irq.h b/arch/mips/include/asm/mach-generic/irq.h
index 139cd20..050e18b 100644
--- a/arch/mips/include/asm/mach-generic/irq.h
+++ b/arch/mips/include/asm/mach-generic/irq.h
@@ -36,4 +36,10 @@
 
 #endif /* CONFIG_IRQ_CPU */
 
+#ifdef CONFIG_MIPS_GIC
+#ifndef MIPS_GIC_IRQ_BASE
+#define MIPS_GIC_IRQ_BASE (MIPS_CPU_IRQ_BASE + 8)
+#endif
+#endif /* CONFIG_MIPS_GIC */
+
 #endif /* __ASM_MACH_GENERIC_IRQ_H */
diff --git a/arch/mips/include/asm/mips-boards/maltaint.h b/arch/mips/include/asm/mips-boards/maltaint.h
index 4186606..d741628 100644
--- a/arch/mips/include/asm/mips-boards/maltaint.h
+++ b/arch/mips/include/asm/mips-boards/maltaint.h
@@ -10,8 +10,6 @@
 #ifndef _MIPS_MALTAINT_H
 #define _MIPS_MALTAINT_H
 
-#define MIPS_GIC_IRQ_BASE	(MIPS_CPU_IRQ_BASE + 8)
-
 /*
  * Interrupts 0..15 are used for Malta ISA compatible interrupts
  */
diff --git a/arch/mips/include/asm/mips-boards/sead3int.h b/arch/mips/include/asm/mips-boards/sead3int.h
index 2320331..11ebec9 100644
--- a/arch/mips/include/asm/mips-boards/sead3int.h
+++ b/arch/mips/include/asm/mips-boards/sead3int.h
@@ -14,6 +14,4 @@
 #define GIC_BASE_ADDR		0x1b1c0000
 #define GIC_ADDRSPACE_SZ	(128 * 1024)
 
-#define MIPS_GIC_IRQ_BASE	(MIPS_CPU_IRQ_BASE + 8)
-
 #endif /* !(_MIPS_SEAD3INT_H) */
-- 
2.1.0.rc2.206.gedb03e5

