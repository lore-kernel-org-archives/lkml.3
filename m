Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608AbaBYWSu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 17:18:50 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:53172 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbaBYWSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 17:18:48 -0500
X-IronPort-AV: E=Sophos;i="4.97,542,1389772800"; 
   d="scan'208";a="16790700"
From: Markus Mayer <markus.mayer@linaro.org>
To: Matt Porter <matt.porter@linaro.org>, Christian Daudt <bcm@fixthebug.org>
CC: ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] ARM: bcm281xx: Rename board_init() function
Date: Tue, 25 Feb 2014 14:17:46 -0800
Message-ID: <1393366666-28625-5-git-send-email-markus.mayer@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393366666-28625-1-git-send-email-markus.mayer@linaro.org>
References: <1393366666-28625-1-git-send-email-markus.mayer@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename board_init() to bcm281xx_init(), so the name reflects the board
specific nature of this function.

Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
---
 arch/arm/mach-bcm/board_bcm281xx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-bcm/board_bcm281xx.c b/arch/arm/mach-bcm/board_bcm281xx.c
index fe00ff3..8fee05b 100644
--- a/arch/arm/mach-bcm/board_bcm281xx.c
+++ b/arch/arm/mach-bcm/board_bcm281xx.c
@@ -56,7 +56,7 @@ static void bcm281xx_restart(enum reboot_mode mode, const char *cmd)
 	while (1);
 }
 
-static void __init board_init(void)
+static void __init bcm281xx_init(void)
 {
 	of_platform_populate(NULL, of_default_bus_match_table, NULL,
 		&platform_bus);
@@ -66,7 +66,7 @@ static void __init board_init(void)
 static const char * const bcm11351_dt_compat[] = { "brcm,bcm11351", NULL, };
 
 DT_MACHINE_START(BCM11351_DT, "BCM281xx Broadcom Application Processor")
-	.init_machine = board_init,
+	.init_machine = bcm281xx_init,
 	.restart = bcm281xx_restart,
 	.dt_compat = bcm11351_dt_compat,
 MACHINE_END
-- 
1.7.9.5

