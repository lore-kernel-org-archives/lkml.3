Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab3A3B1E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 20:27:04 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:60406 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab3A3B1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 20:27:02 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Simon Baatz <gmbnomis@gmail.com>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ARM: kirkwood: provide ge clock aliases for shared smi
Date: Wed, 30 Jan 2013 02:26:40 +0100
Message-Id: <1359509201-11674-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DT support for mv643xx_eth will split smi driver from core gbe driver.
Although different drivers, both use the same internal device and the
same (gateable) clock. This patch provides a proper clock alias for
the smi driver to not break non-DT kernels.

Reported-by: Simon Baatz <gmbnomis@gmail.com>
Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Simon Baatz <gmbnomis@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-kirkwood/common.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-kirkwood/common.c b/arch/arm/mach-kirkwood/common.c
index bac21a5..502d80d 100644
--- a/arch/arm/mach-kirkwood/common.c
+++ b/arch/arm/mach-kirkwood/common.c
@@ -252,7 +252,9 @@ void __init kirkwood_clk_init(void)
 	orion_clkdev_add(NULL, "orion_spi.0", runit);
 	orion_clkdev_add(NULL, "orion_spi.1", runit);
 	orion_clkdev_add(NULL, MV643XX_ETH_NAME ".0", ge0);
+	orion_clkdev_add(NULL, MV643XX_ETH_SHARED_NAME ".0", ge0);
 	orion_clkdev_add(NULL, MV643XX_ETH_NAME ".1", ge1);
+	orion_clkdev_add(NULL, MV643XX_ETH_SHARED_NAME ".1", ge1);
 	orion_clkdev_add(NULL, "orion_wdt", tclk);
 	orion_clkdev_add("0", "sata_mv.0", sata0);
 	orion_clkdev_add("1", "sata_mv.0", sata1);
-- 
1.7.10.4

