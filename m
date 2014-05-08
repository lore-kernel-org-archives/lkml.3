Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbaEHO7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:59:20 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:60766 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbaEHO7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:59:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] ata: pata_at91 only works on sam9
Date: Thu,  8 May 2014 16:56:21 +0200
Message-Id: <1399560990-1402858-10-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399560990-1402858-1-git-send-email-arnd@arndb.de>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:9Squh33gMlzzBwSQOv4TB2GLWaHNLQOFOldk3D5viSv
 mbDtgFVqaJ9noR71slTDc/FQjdqSTbNZA4FdRJUNARHRrJK33v
 X2N8eu7QHjVjAgsWFJYk2STcY9VhBVVvnSnCdkALI07mxSs/zl
 gjcdR9ICNSwu1Lhe7/vE8ywqGN3QbeSJgjksJ2Wqc7L27C6vSx
 GZJYPTFqQ04lZlNA8goleHi0JOq3q3Fb+Kb/bbTJf7Y8SF2Y/J
 VplWgYvP6EaBkY7+EbAZdV6Vgs/0KzS+PoHmFsHqXXFqDnhjuB
 6PLugnlIVBJWPFgMrPOh/WBctHXhtt/iPUzgOGxq3O44wOiP2v
 o9+z9Hdm/fpXAJhVtH23B1GzIV+eyvfgVIeWxzGU8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The smc driver used by pata_at91 is at91sam9 specific, so building
this driver on another at91 platform results in this error:

ERROR: "sam9_smc_configure" [drivers/ata/pata_at91.ko] undefined!
ERROR: "sam9_smc_write_mode" [drivers/ata/pata_at91.ko] undefined!
ERROR: "sam9_smc_read_mode" [drivers/ata/pata_at91.ko] undefined!

This patch changes the Kconfig dependency to ensure it always works.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/ata/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index a91bf47..7671dba 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -824,7 +824,7 @@ config PATA_AT32
 
 config PATA_AT91
 	tristate "PATA support for AT91SAM9260"
-	depends on ARM && ARCH_AT91
+	depends on ARM && SOC_AT91SAM9
 	help
 	  This option enables support for IDE devices on the Atmel AT91SAM9260 SoC.
 
-- 
1.8.3.2

