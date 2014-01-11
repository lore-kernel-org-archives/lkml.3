Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbaAKNG1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 08:06:27 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:44262 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbaAKNF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 08:05:58 -0500
From: Leif Lindholm <leif.lindholm@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        matt.fleming@intel.com, roy.franz@linaro.org, msalter@redhat.com,
        linux@arm.linux.org.uk, grant.likely@secretlab.ca, patches@linaro.org,
        Leif Lindholm <leif.lindholm@linaro.org>
Subject: [PATCH v4 2/5] arm: add new asm macro update_sctlr
Date: Sat, 11 Jan 2014 13:05:21 +0000
Message-Id: <1389445524-30623-3-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1389445524-30623-1-git-send-email-leif.lindholm@linaro.org>
References: <1389445524-30623-1-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A new macro for setting/clearing bits in the SCTLR.

Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
Suggested-by: Will Deacon <will.deacon@arm.com>
---
 arch/arm/include/asm/assembler.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm/include/asm/assembler.h b/arch/arm/include/asm/assembler.h
index 5c22851..aba6458 100644
--- a/arch/arm/include/asm/assembler.h
+++ b/arch/arm/include/asm/assembler.h
@@ -383,4 +383,17 @@ THUMB(	orr	\reg , \reg , #PSR_T_BIT	)
 #endif
 	.endm
 
+#ifdef CONFIG_CPU_CP15
+/* Macro for setting/clearing bits in sctlr */
+	.macro update_sctlr, set:req, clear:req, tmp:req, tmp2:req
+	mrc	p15, 0, \tmp, c1, c0, 0
+	ldr	\tmp2, =\set
+	orr	\tmp, \tmp, \tmp2
+	ldr	\tmp2, =\clear
+	mvn	\tmp2, \tmp2
+	and	\tmp, \tmp, \tmp2
+	mcr	p15, 0, \tmp, c1, c0, 0
+	.endm
+#endif
+
 #endif /* __ASM_ASSEMBLER_H__ */
-- 
1.7.10.4

