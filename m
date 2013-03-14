Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab3CNV4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 17:56:53 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:54324 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173Ab3CNV4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 17:56:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Axel Lin <axel.lin@ingics.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/3] mfd: Make AB8500_CORE select POWER_SUPPLY to fix build error
Date: Thu, 14 Mar 2013 22:56:39 +0100
Message-Id: <1363298204-8014-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363298204-8014-1-git-send-email-arnd@arndb.de>
References: <1363298204-8014-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:y15Jr/1fQWAwpH69ySBrNHtNT6b5xM/jbIOCq6R+Imv
 jV09K9imLgZnbNI9dKrfMByOfxoRPnILf2oPa6jvh0ccXeyb7N
 BYmolC+8EKPJYvrASLERk+NXtH4w8mOU+FbF6+P0vIAA+mfXCn
 AHzj2UA/ghQ+7njJ+tAXqP2A0R8j+YaWcjutL+L/NqJ5DXWpB9
 u8TI+AENs/F4WD7maqLffxdBsQmJVA70hVO4fKqmhDXYTqLzb7
 oNOP/n9JxolF0bAN32FUxMxSIPz5MWPQ5EmYx1AzmmOuRSl2V4
 bXdCXwnTO1hnuq2sdiIHS4Wt53WmkAWjr57q4+x5VGUla7NB1+
 esj2P7fX8Ua4lnmrk33jHrDPiVq27bdXXfMqY7+Cq
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

This patch fixes below build error when CONFIG_POWER_SUPPLY is not set.

drivers/built-in.o: In function `ab8500_power_off':
drivers/mfd/ab8500-sysctrl.c:37: undefined reference to `power_supply_get_by_name'
drivers/mfd/ab8500-sysctrl.c:53: undefined reference to `power_supply_get_by_name'
make: *** [vmlinux] Error 1

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Please apply to MFD tree for 3.9

 drivers/mfd/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 671f5b1..c346941 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -858,6 +858,7 @@ config EZX_PCAP
 config AB8500_CORE
 	bool "ST-Ericsson AB8500 Mixed Signal Power Management chip"
 	depends on GENERIC_HARDIRQS && ABX500_CORE && MFD_DB8500_PRCMU
+	select POWER_SUPPLY
 	select MFD_CORE
 	select IRQ_DOMAIN
 	help
-- 
1.8.1.2

