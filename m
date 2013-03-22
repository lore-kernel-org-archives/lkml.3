Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933591Ab3CVP2C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 11:28:02 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:47597 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932548Ab3CVP2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 11:28:00 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/5] ARM: ux500: Add machine support for ccu8540
Date: Fri, 22 Mar 2013 15:27:41 +0000
Message-Id: <1363966065-2478-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inform the kernel of a new machine type, so when detected it
knows which initialisation route to travel though.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500.c |    9 +++++++++
 arch/arm/tools/mach-types          |    1 +
 2 files changed, 10 insertions(+)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index b034578..4fade16 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -740,6 +740,15 @@ MACHINE_START(U8500, "ST-Ericsson MOP500 platform")
 	.init_late	= ux500_init_late,
 MACHINE_END
 
+MACHINE_START(U8540, "ST-Ericsson U8540 Platform ccu8540")
+	.atag_offset	= 0x100,
+	.map_io		= u8500_map_io,
+	.init_irq	= ux500_init_irq,
+	.init_time	= ux500_timer_init,
+	.init_machine	= mop500_init_machine,
+	.init_late	= ux500_init_late,
+MACHINE_END
+
 MACHINE_START(U8520, "ST-Ericsson U8520 Platform HREFP520")
 	.atag_offset	= 0x100,
 	.map_io		= u8500_map_io,
diff --git a/arch/arm/tools/mach-types b/arch/arm/tools/mach-types
index 831e1fd..1c9d0be 100644
--- a/arch/arm/tools/mach-types
+++ b/arch/arm/tools/mach-types
@@ -1204,3 +1204,4 @@ baileys			MACH_BAILEYS		BAILEYS			4169
 familybox		MACH_FAMILYBOX		FAMILYBOX		4170
 ensemble_mx35		MACH_ENSEMBLE_MX35	ENSEMBLE_MX35		4171
 sc_sps_1		MACH_SC_SPS_1		SC_SPS_1		4172
+u8540			MACH_U8540		U8540			4211
-- 
1.7.10.4

