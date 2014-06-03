Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504AbaFCLlA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:41:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43402 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932429AbaFCLky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:40:54 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andreas Schwab <schwab@linux-m68k.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 039/138] powerpc: Add vr save/restore functions
Date: Tue,  3 Jun 2014 12:38:05 +0100
Message-Id: <1401795584-22664-40-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Schwab <schwab@linux-m68k.org>

commit 8fe9c93e7453e67b8bd09f263ec1bb0783c733fc upstream.

GCC 4.8 now generates out-of-line vr save/restore functions when
optimizing for size.  They are needed for the raid6 altivec support.

Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/lib/crtsavres.S | 186 +++++++++++++++++++++++++++++++++++++++++++
 scripts/mod/modpost.c        |   8 +-
 2 files changed, 192 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/lib/crtsavres.S b/arch/powerpc/lib/crtsavres.S
index b2c68ce139ae..a5b30c71a8d3 100644
--- a/arch/powerpc/lib/crtsavres.S
+++ b/arch/powerpc/lib/crtsavres.S
@@ -231,6 +231,87 @@ _GLOBAL(_rest32gpr_31_x)
 	mr	1,11
 	blr
 
+#ifdef CONFIG_ALTIVEC
+/* Called with r0 pointing just beyond the end of the vector save area.  */
+
+_GLOBAL(_savevr_20)
+	li	r11,-192
+	stvx	vr20,r11,r0
+_GLOBAL(_savevr_21)
+	li	r11,-176
+	stvx	vr21,r11,r0
+_GLOBAL(_savevr_22)
+	li	r11,-160
+	stvx	vr22,r11,r0
+_GLOBAL(_savevr_23)
+	li	r11,-144
+	stvx	vr23,r11,r0
+_GLOBAL(_savevr_24)
+	li	r11,-128
+	stvx	vr24,r11,r0
+_GLOBAL(_savevr_25)
+	li	r11,-112
+	stvx	vr25,r11,r0
+_GLOBAL(_savevr_26)
+	li	r11,-96
+	stvx	vr26,r11,r0
+_GLOBAL(_savevr_27)
+	li	r11,-80
+	stvx	vr27,r11,r0
+_GLOBAL(_savevr_28)
+	li	r11,-64
+	stvx	vr28,r11,r0
+_GLOBAL(_savevr_29)
+	li	r11,-48
+	stvx	vr29,r11,r0
+_GLOBAL(_savevr_30)
+	li	r11,-32
+	stvx	vr30,r11,r0
+_GLOBAL(_savevr_31)
+	li	r11,-16
+	stvx	vr31,r11,r0
+	blr
+
+_GLOBAL(_restvr_20)
+	li	r11,-192
+	lvx	vr20,r11,r0
+_GLOBAL(_restvr_21)
+	li	r11,-176
+	lvx	vr21,r11,r0
+_GLOBAL(_restvr_22)
+	li	r11,-160
+	lvx	vr22,r11,r0
+_GLOBAL(_restvr_23)
+	li	r11,-144
+	lvx	vr23,r11,r0
+_GLOBAL(_restvr_24)
+	li	r11,-128
+	lvx	vr24,r11,r0
+_GLOBAL(_restvr_25)
+	li	r11,-112
+	lvx	vr25,r11,r0
+_GLOBAL(_restvr_26)
+	li	r11,-96
+	lvx	vr26,r11,r0
+_GLOBAL(_restvr_27)
+	li	r11,-80
+	lvx	vr27,r11,r0
+_GLOBAL(_restvr_28)
+	li	r11,-64
+	lvx	vr28,r11,r0
+_GLOBAL(_restvr_29)
+	li	r11,-48
+	lvx	vr29,r11,r0
+_GLOBAL(_restvr_30)
+	li	r11,-32
+	lvx	vr30,r11,r0
+_GLOBAL(_restvr_31)
+	li	r11,-16
+	lvx	vr31,r11,r0
+	blr
+
+#endif /* CONFIG_ALTIVEC */
+
 #else /* CONFIG_PPC64 */
 
 	.section ".text.save.restore","ax",@progbits
@@ -356,6 +437,111 @@ _restgpr0_31:
 	mtlr	r0
 	blr
 
+#ifdef CONFIG_ALTIVEC
+/* Called with r0 pointing just beyond the end of the vector save area.  */
+
+.globl	_savevr_20
+_savevr_20:
+	li	r12,-192
+	stvx	vr20,r12,r0
+.globl	_savevr_21
+_savevr_21:
+	li	r12,-176
+	stvx	vr21,r12,r0
+.globl	_savevr_22
+_savevr_22:
+	li	r12,-160
+	stvx	vr22,r12,r0
+.globl	_savevr_23
+_savevr_23:
+	li	r12,-144
+	stvx	vr23,r12,r0
+.globl	_savevr_24
+_savevr_24:
+	li	r12,-128
+	stvx	vr24,r12,r0
+.globl	_savevr_25
+_savevr_25:
+	li	r12,-112
+	stvx	vr25,r12,r0
+.globl	_savevr_26
+_savevr_26:
+	li	r12,-96
+	stvx	vr26,r12,r0
+.globl	_savevr_27
+_savevr_27:
+	li	r12,-80
+	stvx	vr27,r12,r0
+.globl	_savevr_28
+_savevr_28:
+	li	r12,-64
+	stvx	vr28,r12,r0
+.globl	_savevr_29
+_savevr_29:
+	li	r12,-48
+	stvx	vr29,r12,r0
+.globl	_savevr_30
+_savevr_30:
+	li	r12,-32
+	stvx	vr30,r12,r0
+.globl	_savevr_31
+_savevr_31:
+	li	r12,-16
+	stvx	vr31,r12,r0
+	blr
+
+.globl	_restvr_20
+_restvr_20:
+	li	r12,-192
+	lvx	vr20,r12,r0
+.globl	_restvr_21
+_restvr_21:
+	li	r12,-176
+	lvx	vr21,r12,r0
+.globl	_restvr_22
+_restvr_22:
+	li	r12,-160
+	lvx	vr22,r12,r0
+.globl	_restvr_23
+_restvr_23:
+	li	r12,-144
+	lvx	vr23,r12,r0
+.globl	_restvr_24
+_restvr_24:
+	li	r12,-128
+	lvx	vr24,r12,r0
+.globl	_restvr_25
+_restvr_25:
+	li	r12,-112
+	lvx	vr25,r12,r0
+.globl	_restvr_26
+_restvr_26:
+	li	r12,-96
+	lvx	vr26,r12,r0
+.globl	_restvr_27
+_restvr_27:
+	li	r12,-80
+	lvx	vr27,r12,r0
+.globl	_restvr_28
+_restvr_28:
+	li	r12,-64
+	lvx	vr28,r12,r0
+.globl	_restvr_29
+_restvr_29:
+	li	r12,-48
+	lvx	vr29,r12,r0
+.globl	_restvr_30
+_restvr_30:
+	li	r12,-32
+	lvx	vr30,r12,r0
+.globl	_restvr_31
+_restvr_31:
+	li	r12,-16
+	lvx	vr31,r12,r0
+	blr
+
+#endif /* CONFIG_ALTIVEC */
+
 #endif /* CONFIG_PPC64 */
 
 #endif
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 62164348ecf7..d820fc64e957 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -573,12 +573,16 @@ static int ignore_undef_symbol(struct elf_info *info, const char *symname)
 		if (strncmp(symname, "_restgpr_", sizeof("_restgpr_") - 1) == 0 ||
 		    strncmp(symname, "_savegpr_", sizeof("_savegpr_") - 1) == 0 ||
 		    strncmp(symname, "_rest32gpr_", sizeof("_rest32gpr_") - 1) == 0 ||
-		    strncmp(symname, "_save32gpr_", sizeof("_save32gpr_") - 1) == 0)
+		    strncmp(symname, "_save32gpr_", sizeof("_save32gpr_") - 1) == 0 ||
+		    strncmp(symname, "_restvr_", sizeof("_restvr_") - 1) == 0 ||
+		    strncmp(symname, "_savevr_", sizeof("_savevr_") - 1) == 0)
 			return 1;
 	if (info->hdr->e_machine == EM_PPC64)
 		/* Special register function linked on all modules during final link of .ko */
 		if (strncmp(symname, "_restgpr0_", sizeof("_restgpr0_") - 1) == 0 ||
-		    strncmp(symname, "_savegpr0_", sizeof("_savegpr0_") - 1) == 0)
+		    strncmp(symname, "_savegpr0_", sizeof("_savegpr0_") - 1) == 0 ||
+		    strncmp(symname, "_restvr_", sizeof("_restvr_") - 1) == 0 ||
+		    strncmp(symname, "_savevr_", sizeof("_savevr_") - 1) == 0)
 			return 1;
 	/* Do not ignore this symbol */
 	return 0;
-- 
1.9.1

