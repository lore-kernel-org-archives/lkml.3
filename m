Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933753Ab3ECOfc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 10:35:32 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:45077 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933859Ab3ECOfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 10:35:18 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 52/63] ARM: ux500: Remove empty function u8500_of_init_devices()
Date: Fri,  3 May 2013 15:32:38 +0100
Message-Id: <1367591569-32197-53-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
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
index 36ef6ed..a2c83c2 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -221,15 +221,6 @@ struct device * __init u8500_init_devices(struct ab8500_platform_data *ab8500)
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
@@ -288,7 +279,7 @@ static const struct of_device_id u8500_local_bus_nodes[] = {
 
 static void __init u8500_init_machine(void)
 {
-	struct device *parent = NULL;
+	struct device *parent = db8500_soc_device_init();
 
 	/* Pinmaps must be in place before devices register */
 	if (of_machine_is_compatible("st-ericsson,mop500"))
@@ -301,9 +292,6 @@ static void __init u8500_init_machine(void)
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

