Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbaAYW3Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 17:29:25 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1661 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752479AbaAYW3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 17:29:24 -0500
From: Richard Weinberger <richard@nod.at>
To: rui.zhang@intel.com
Cc: eduardo.valentin@ti.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, horms@verge.net.au,
        laurent.pinchart+renesas@ideasonboard.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 2/2] thermal,rcar_thermal: Add dependency on HAS_IOMEM
Date: Sat, 25 Jan 2014 23:29:14 +0100
Message-Id: <1390688954-4940-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit beeb5a1e (thermal: rcar-thermal: Enable driver compilation with COMPILE_TEST)
broke build on archs wihout io memory.

On archs like S390 or um this driver cannot build nor work.
Make it depend on HAS_IOMEM to bypass build failures.

drivers/thermal/rcar_thermal.c:404: undefined reference to `devm_ioremap_resource'
drivers/thermal/rcar_thermal.c:426: undefined reference to `devm_ioremap_resource'

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/thermal/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index 35c0664..88efa8f 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -136,6 +136,7 @@ config SPEAR_THERMAL
 config RCAR_THERMAL
 	tristate "Renesas R-Car thermal driver"
 	depends on ARCH_SHMOBILE || COMPILE_TEST
+	depends on HAS_IO_MEM
 	help
 	  Enable this to plug the R-Car thermal sensor driver into the Linux
 	  thermal framework.
-- 
1.8.1.4

