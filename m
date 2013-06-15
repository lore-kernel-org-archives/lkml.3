Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab3FOCcy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 22:32:54 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:33874 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab3FOCcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 22:32:53 -0400
From: Olof Johansson <olof@lixom.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH] ARM: ux500: minor code cleanup
Date: Fri, 14 Jun 2013 19:32:47 -0700
Message-Id: <1371263567-8520-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.1.192.gc4361b8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up coding style a bit in cpu-db8500.

Signed-off-by: Olof Johansson <olof@lixom.net>
---

Linus,

Noticed the last chunk of this patch when I resolved one of the recent
conflicts, so I did a once-over of the file. Feel free to drop the
first chunk when applying if you'd prefer to do a sweeping DEFINE_RES()
cleanup instead.

 arch/arm/mach-ux500/cpu-db8500.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index 27e5566..d25db87 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -95,11 +95,7 @@ void __init u8500_map_io(void)
 }
 
 static struct resource db8500_pmu_resources[] = {
-	[0] = {
-		.start		= IRQ_DB8500_PMU,
-		.end		= IRQ_DB8500_PMU,
-		.flags		= IORESOURCE_IRQ,
-	},
+	[0] = DEFINE_RES_IRQ(IRQ_DB8500_PMU),
 };
 
 /*
@@ -281,8 +277,8 @@ static const struct of_device_id u8500_local_bus_nodes[] = {
 	/* only create devices below soc node */
 	{ .compatible = "stericsson,db8500", },
 	{ .compatible = "stericsson,db8500-prcmu", },
-	{ .compatible = "simple-bus"},
-	{ },
+	{ .compatible = "simple-bus" },
+	{},
 };
 
 static void __init u8500_init_machine(void)
@@ -290,15 +286,16 @@ static void __init u8500_init_machine(void)
 	struct device *parent = db8500_soc_device_init();
 
 	/* Pinmaps must be in place before devices register */
-	if (of_machine_is_compatible("st-ericsson,mop500"))
+	if (of_machine_is_compatible("st-ericsson,mop500")) {
 		mop500_pinmaps_init();
-	else if (of_machine_is_compatible("calaosystems,snowball-a9500")) {
+	} else if (of_machine_is_compatible("calaosystems,snowball-a9500")) {
 		snowball_pinmaps_init();
 		mop500_snowball_ethernet_clock_enable();
-	} else if (of_machine_is_compatible("st-ericsson,hrefv60+"))
+	} else if (of_machine_is_compatible("st-ericsson,hrefv60+")) {
 		hrefv60_pinmaps_init();
-	else if (of_machine_is_compatible("st-ericsson,ccu9540")) {}
+	} else if (of_machine_is_compatible("st-ericsson,ccu9540")) {
 		/* TODO: Add pinmaps for ccu9540 board. */
+	}
 
 	/* automatically probe child nodes of dbx5x0 devices */
 	if (of_machine_is_compatible("st-ericsson,u8540"))
-- 
1.8.1.192.gc4361b8

