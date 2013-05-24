Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab3EXWT3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 18:19:29 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:45011 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755764Ab3EXWT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 18:19:27 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH] ARM: at91: Fix link breakage when !CONFIG_PHY
Date: Sat, 25 May 2013 00:19:02 +0200
Message-Id: <1369433942-12386-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes:
arch/arm/mach-at91/built-in.o: In function `ksz9021rn_phy_fixup':
:(.text+0x1174): undefined reference to `mdiobus_write'
:(.text+0x1188): undefined reference to `mdiobus_write'
:(.text+0x119c): undefined reference to `mdiobus_write'
:(.text+0x11b0): undefined reference to `mdiobus_write'
arch/arm/mach-at91/built-in.o: In function `sama5_dt_device_init':
:(.init.text+0x1e34): undefined reference to
`phy_register_fixup_for_uid'

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/board-dt-sama5.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/mach-at91/board-dt-sama5.c b/arch/arm/mach-at91/board-dt-sama5.c
index 705305e..f510381 100644
--- a/arch/arm/mach-at91/board-dt-sama5.c
+++ b/arch/arm/mach-at91/board-dt-sama5.c
@@ -38,6 +38,7 @@ static void __init at91_dt_init_irq(void)
 	of_irq_init(irq_of_match);
 }
 
+#ifdef CONFIG_PHY
 static int ksz9021rn_phy_fixup(struct phy_device *phy)
 {
 	int value;
@@ -59,12 +60,15 @@ static int ksz9021rn_phy_fixup(struct phy_device *phy)
 
 	return 0;
 }
+#endif
 
 static void __init sama5_dt_device_init(void)
 {
+#ifdef CONFIG_PHY
 	if (of_machine_is_compatible("atmel,sama5d3xcm"))
 		phy_register_fixup_for_uid(PHY_ID_KSZ9021, MICREL_PHY_ID_MASK,
 			ksz9021rn_phy_fixup);
+#endif
 
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
-- 
1.8.1.2

