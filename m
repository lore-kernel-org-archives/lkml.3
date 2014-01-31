Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367AbaAaMsE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 07:48:04 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1661 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753989AbaAaMsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 07:48:02 -0500
From: Richard Weinberger <richard@nod.at>
To: wim@iguana.be
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH] watchdog,dw: Add dependency on HAS_IOMEM
Date: Fri, 31 Jan 2014 13:47:34 +0100
Message-Id: <1391172454-17959-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On archs like S390 or um this driver cannot build nor work.
Make it depend on HAS_IOMEM to bypass build failures.

drivers/built-in.o: In function `dw_wdt_drv_probe':
drivers/watchdog/dw_wdt.c:302: undefined reference to `devm_ioremap_resource'

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/watchdog/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 4c4c566..79d2589 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -223,6 +223,7 @@ config SA1100_WATCHDOG
 
 config DW_WATCHDOG
 	tristate "Synopsys DesignWare watchdog"
+	depends on HAS_IOMEM
 	help
 	  Say Y here if to include support for the Synopsys DesignWare
 	  watchdog timer found in many chips.
-- 
1.8.1.4

