Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab3EPQQg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 12:16:36 -0400
Received: from relay2.sgi.com ([192.48.179.30]:58835 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750969Ab3EPQPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 12:15:15 -0400
From: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robin Holt <holt@sgi.com>, Russell King <rmk+kernel@arm.linux.org.uk>,
        Russ Anderson <rja@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Arm Mailing List <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH -v11 resend 08/11] arm, Remove unused restart_mode fields from some arm subarchs
Date: Thu, 16 May 2013 11:14:47 -0500
Message-Id: <1368720890-57711-9-git-send-email-holt@sgi.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1368720890-57711-1-git-send-email-holt@sgi.com>
References: <1368720890-57711-1-git-send-email-holt@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These restart_mode fields are not used at all.  Remove them to make
moving the reboot= cmdline options to the general kernel easier.

Signed-off-by: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Russ Anderson <rja@sgi.com>
Cc: Robin Holt <holt@sgi.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: the arch/x86 maintainers <x86@kernel.org>
Cc: Arm Mailing List <linux-arm-kernel@lists.infradead.org>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/arm/mach-ebsa110/core.c | 1 -
 arch/arm/mach-pxa/mioa701.c  | 1 -
 arch/arm/mach-pxa/spitz.c    | 3 ---
 arch/arm/mach-pxa/tosa.c     | 1 -
 4 files changed, 6 deletions(-)

diff --git a/arch/arm/mach-ebsa110/core.c b/arch/arm/mach-ebsa110/core.c
index b13cc74..69a9d5d 100644
--- a/arch/arm/mach-ebsa110/core.c
+++ b/arch/arm/mach-ebsa110/core.c
@@ -321,7 +321,6 @@ MACHINE_START(EBSA110, "EBSA110")
 	.atag_offset	= 0x400,
 	.reserve_lp0	= 1,
 	.reserve_lp2	= 1,
-	.restart_mode	= 's',
 	.map_io		= ebsa110_map_io,
 	.init_early	= ebsa110_init_early,
 	.init_irq	= ebsa110_init_irq,
diff --git a/arch/arm/mach-pxa/mioa701.c b/arch/arm/mach-pxa/mioa701.c
index f8979b9..dbea67a 100644
--- a/arch/arm/mach-pxa/mioa701.c
+++ b/arch/arm/mach-pxa/mioa701.c
@@ -756,7 +756,6 @@ static void mioa701_machine_exit(void)
 
 MACHINE_START(MIOA701, "MIO A701")
 	.atag_offset	= 0x100,
-	.restart_mode	= 's',
 	.map_io		= &pxa27x_map_io,
 	.nr_irqs	= PXA_NR_IRQS,
 	.init_irq	= &pxa27x_init_irq,
diff --git a/arch/arm/mach-pxa/spitz.c b/arch/arm/mach-pxa/spitz.c
index 362726c..c3c0042 100644
--- a/arch/arm/mach-pxa/spitz.c
+++ b/arch/arm/mach-pxa/spitz.c
@@ -979,7 +979,6 @@ static void __init spitz_fixup(struct tag *tags, char **cmdline,
 
 #ifdef CONFIG_MACH_SPITZ
 MACHINE_START(SPITZ, "SHARP Spitz")
-	.restart_mode	= 'g',
 	.fixup		= spitz_fixup,
 	.map_io		= pxa27x_map_io,
 	.nr_irqs	= PXA_NR_IRQS,
@@ -993,7 +992,6 @@ MACHINE_END
 
 #ifdef CONFIG_MACH_BORZOI
 MACHINE_START(BORZOI, "SHARP Borzoi")
-	.restart_mode	= 'g',
 	.fixup		= spitz_fixup,
 	.map_io		= pxa27x_map_io,
 	.nr_irqs	= PXA_NR_IRQS,
@@ -1007,7 +1005,6 @@ MACHINE_END
 
 #ifdef CONFIG_MACH_AKITA
 MACHINE_START(AKITA, "SHARP Akita")
-	.restart_mode	= 'g',
 	.fixup		= spitz_fixup,
 	.map_io		= pxa27x_map_io,
 	.nr_irqs	= PXA_NR_IRQS,
diff --git a/arch/arm/mach-pxa/tosa.c b/arch/arm/mach-pxa/tosa.c
index 3d91d2e..a41992f 100644
--- a/arch/arm/mach-pxa/tosa.c
+++ b/arch/arm/mach-pxa/tosa.c
@@ -969,7 +969,6 @@ static void __init fixup_tosa(struct tag *tags, char **cmdline,
 }
 
 MACHINE_START(TOSA, "SHARP Tosa")
-	.restart_mode	= 'g',
 	.fixup          = fixup_tosa,
 	.map_io         = pxa25x_map_io,
 	.nr_irqs	= TOSA_NR_IRQS,
-- 
1.8.2.1

