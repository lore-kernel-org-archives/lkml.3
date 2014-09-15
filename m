Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168AbaIOXwM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:52:12 -0400
Received: from mail-oa0-f74.google.com ([209.85.219.74]:49099 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757223AbaIOXvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 19:51:40 -0400
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
Subject: [PATCH 11/24] MIPS: Malta: Move MSC01 interrupt base
Date: Mon, 15 Sep 2014 16:51:14 -0700
Message-Id: <1410825087-5497-12-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1410825087-5497-1-git-send-email-abrestic@chromium.org>
References: <1410825087-5497-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GIC on Malta boards supports a total of 47 interrupts (40 shared
and 7 local) and is assigned a base of 24.  This overlaps with the
MSC01 interrupt assignments which have a base of 64, so move the MSC01
interrupt base back a bit to give the GIC some room.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 arch/mips/include/asm/mips-boards/maltaint.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/mips/include/asm/mips-boards/maltaint.h b/arch/mips/include/asm/mips-boards/maltaint.h
index e330732..4186606 100644
--- a/arch/mips/include/asm/mips-boards/maltaint.h
+++ b/arch/mips/include/asm/mips-boards/maltaint.h
@@ -33,18 +33,18 @@
 #define MIPSCPU_INT_CORELO	MIPSCPU_INT_MB4
 
 /*
- * Interrupts 64..127 are used for Soc-it Classic interrupts
+ * Interrupts 96..127 are used for Soc-it Classic interrupts
  */
-#define MSC01C_INT_BASE		64
+#define MSC01C_INT_BASE		96
 
 /* SOC-it Classic interrupt offsets */
 #define MSC01C_INT_TMR		0
 #define MSC01C_INT_PCI		1
 
 /*
- * Interrupts 64..127 are used for Soc-it EIC interrupts
+ * Interrupts 96..127 are used for Soc-it EIC interrupts
  */
-#define MSC01E_INT_BASE		64
+#define MSC01E_INT_BASE		96
 
 /* SOC-it EIC interrupt offsets */
 #define MSC01E_INT_SW0		1
-- 
2.1.0.rc2.206.gedb03e5

