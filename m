Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523AbaLCXoa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 18:44:30 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:64192 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbaLCXo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 18:44:27 -0500
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org
Cc: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>, Zubair.Kakakhel@imgtec.com,
        geert+renesas@glider.be, peterz@infradead.org,
        paul.gortmaker@windriver.com, macro@linux-mips.org, chenhc@lemote.com,
        cl@linux.com, mingo@kernel.org, richard@nod.at, zajec5@gmail.com,
        james.hogan@imgtec.com, keescook@chromium.org, tj@kernel.org,
        alex@alex-smith.me.uk, pbonzini@redhat.com, blogic@openwrt.org,
        paul.burton@imgtec.com, qais.yousef@imgtec.com,
        linux-kernel@vger.kernel.org, markos.chandras@imgtec.com,
        dengcheng.zhu@imgtec.com, manuel.lauss@gmail.com,
        lars.persson@axis.com, David Daney <david.daney@cavium.com>
Subject: [PATCH 1/3] MIPS: Add FPU emulator counter for non-FPU instructions emulated.
Date: Wed,  3 Dec 2014 15:44:16 -0800
Message-Id: <1417650258-2811-2-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1417650258-2811-1-git-send-email-ddaney.cavm@gmail.com>
References: <1417650258-2811-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

Used in follow-on patch, the counter is called "insn_emul".

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/include/asm/fpu_emulator.h | 1 +
 arch/mips/math-emu/me-debugfs.c      | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/mips/include/asm/fpu_emulator.h b/arch/mips/include/asm/fpu_emulator.h
index 6370c82..bd5b63f 100644
--- a/arch/mips/include/asm/fpu_emulator.h
+++ b/arch/mips/include/asm/fpu_emulator.h
@@ -45,6 +45,7 @@ struct mips_fpu_emulator_stats {
 	unsigned long ieee754_zerodiv;
 	unsigned long ieee754_invalidop;
 	unsigned long ds_emul;
+	unsigned long insn_emul;
 };
 
 DECLARE_PER_CPU(struct mips_fpu_emulator_stats, fpuemustats);
diff --git a/arch/mips/math-emu/me-debugfs.c b/arch/mips/math-emu/me-debugfs.c
index f308e0f..93fc155 100644
--- a/arch/mips/math-emu/me-debugfs.c
+++ b/arch/mips/math-emu/me-debugfs.c
@@ -62,6 +62,7 @@ do {									\
 	FPU_STAT_CREATE(ieee754_zerodiv);
 	FPU_STAT_CREATE(ieee754_invalidop);
 	FPU_STAT_CREATE(ds_emul);
+	FPU_STAT_CREATE(insn_emul);
 
 	return 0;
 }
-- 
1.7.11.7

