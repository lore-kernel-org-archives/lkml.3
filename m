Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759269AbaELQ5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 12:57:19 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:60030 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529AbaELQ5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 12:57:16 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Jon Loeliger <jdl@jdl.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [RFC PATCH 7/9] dt: deps: kirkwood: make it possible to use CONFIG_OF_DEPENDENCIES
Date: Mon, 12 May 2014 18:47:58 +0200
Message-Id: <1399913280-6915-8-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the feature of dependency based initialization order for drivers
if CONFIG_OF_DEPENDENCIES is enabled.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 arch/arm/mach-kirkwood/board-dt.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/mach-kirkwood/board-dt.c b/arch/arm/mach-kirkwood/board-dt.c
index 7818815..5c352b7 100644
--- a/arch/arm/mach-kirkwood/board-dt.c
+++ b/arch/arm/mach-kirkwood/board-dt.c
@@ -17,6 +17,7 @@
 #include <linux/of_address.h>
 #include <linux/of_net.h>
 #include <linux/of_platform.h>
+#include <linux/of_dependencies.h>
 #include <linux/dma-mapping.h>
 #include <linux/irqchip.h>
 #include <linux/kexec.h>
@@ -133,7 +134,14 @@ static void __init kirkwood_dt_init(void)
 	if (of_machine_is_compatible("marvell,mv88f6281gtw-ge"))
 		mv88f6281gtw_ge_init();
 
+#ifdef CONFIG_OF_DEPENDENCIES
+	if (!of_init_build_order(NULL, NULL))
+		of_init_create_devices(NULL, NULL);
+	else
+		of_init_free_order();
+#else
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+#endif
 }
 
 static const char * const kirkwood_dt_board_compat[] = {
-- 
1.8.3.1

