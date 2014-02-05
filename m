Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611AbaBERMv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 12:12:51 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:47100 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbaBERFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 12:05:12 -0500
From: Leif Lindholm <leif.lindholm@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-efi@vger.kernel.org
Cc: patches@linaro.org, Leif Lindholm <leif.lindholm@linaro.org>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 02/22] arm: add new asm macro update_sctlr
Date: Wed,  5 Feb 2014 17:03:53 +0000
Message-Id: <1391619853-10601-3-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1391619853-10601-1-git-send-email-leif.lindholm@linaro.org>
References: <1391619853-10601-1-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A new macro for setting/clearing bits in the SCTLR.

Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
Suggested-by: Will Deacon <will.deacon@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm/include/asm/assembler.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm/include/asm/assembler.h b/arch/arm/include/asm/assembler.h
index 5c22851..e8ca24b 100644
--- a/arch/arm/include/asm/assembler.h
+++ b/arch/arm/include/asm/assembler.h
@@ -383,4 +383,18 @@ THUMB(	orr	\reg , \reg , #PSR_T_BIT	)
 #endif
 	.endm
 
+#ifdef CONFIG_CPU_CP15
+/* Macro for setting/clearing bits in sctlr */
+	.macro	update_sctlr, tmp:req, set=, clear=
+	mrc	p15, 0, \tmp, c1, c0, 0
+	.ifnc	\set,
+	orr	\tmp, \set
+	.endif
+	.ifnc	\clear,
+	bic	\tmp, \tmp, \clear
+	.endif
+	mcr	p15, 0, \tmp, c1, c0, 0
+	.endm
+#endif
+
 #endif /* __ASM_ASSEMBLER_H__ */
-- 
1.7.10.4

