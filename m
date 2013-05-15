Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714Ab3EOJ4o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:56:44 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:38605 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932666Ab3EOJxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:53:03 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        balbi@ti.com, linux-usb@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.hengli.com.au,
        vinod.koul@intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 28/39] ARM: ux500: Remove empty function u8500_of_init_devices()
Date: Wed, 15 May 2013 10:51:51 +0100
Message-Id: <1368611522-9984-29-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As promised, now all devices which resided in u8500_of_init_devices()
have been enabled for Device Tree, we can completely remove it.

Acked-by: Fabio Baltieri <fabio.baltieri@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/cpu-db8500.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index f1e7a75..b407601 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -215,15 +215,6 @@ struct device * __init u8500_init_devices(void)
 }
 
 #ifdef CONFIG_MACH_UX500_DT
-
-/* TODO: Once all pieces are DT:ed, remove completely. */
-static struct device * __init u8500_of_init_devices(void)
-{
-	struct device *parent = db8500_soc_device_init();
-
-	return parent;
-}
-
 static struct of_dev_auxdata u8500_auxdata_lookup[] __initdata = {
 	/* Requires call-back bindings. */
 	OF_DEV_AUXDATA("arm,cortex-a9-pmu", 0, "arm-pmu", &db8500_pmu_platdata),
@@ -283,7 +274,7 @@ static const struct of_device_id u8500_local_bus_nodes[] = {
 
 static void __init u8500_init_machine(void)
 {
-	struct device *parent = NULL;
+	struct device *parent = db8500_soc_device_init();
 
 	/* Pinmaps must be in place before devices register */
 	if (of_machine_is_compatible("st-ericsson,mop500"))
@@ -296,9 +287,6 @@ static void __init u8500_init_machine(void)
 	else if (of_machine_is_compatible("st-ericsson,ccu9540")) {}
 		/* TODO: Add pinmaps for ccu9540 board. */
 
-	/* TODO: Export SoC, USB, cpu-freq and DMA40 */
-	parent = u8500_of_init_devices();
-
 	/* automatically probe child nodes of db8500 device */
 	of_platform_populate(NULL, u8500_local_bus_nodes, u8500_auxdata_lookup, parent);
 }
-- 
1.7.10.4

