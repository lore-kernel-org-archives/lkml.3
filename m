Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967957Ab3DRKNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 06:13:30 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:54766 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967926Ab3DRKN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 06:13:26 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 29/32] ARM: ux500: Stop passing UART's platform data for Device Tree boots
Date: Thu, 18 Apr 2013 11:12:11 +0100
Message-Id: <1366279934-30761-30-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was required to pass DMA channel configuration information to the
UART driver before the new DMA API was in place. Now that it is, and
is fully compatible with Device Tree we can stop doing that.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/cpu-db8500.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index b216233..27d75c8 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -236,9 +236,9 @@ static struct of_dev_auxdata u8500_auxdata_lookup[] __initdata = {
 	/* Requires call-back bindings. */
 	OF_DEV_AUXDATA("arm,cortex-a9-pmu", 0, "arm-pmu", &db8500_pmu_platdata),
 	/* Requires DMA bindings. */
-	OF_DEV_AUXDATA("arm,pl011", 0x80120000, "uart0", &uart0_plat),
-	OF_DEV_AUXDATA("arm,pl011", 0x80121000, "uart1", &uart1_plat),
-	OF_DEV_AUXDATA("arm,pl011", 0x80007000, "uart2", &uart2_plat),
+	OF_DEV_AUXDATA("arm,pl011", 0x80120000, "uart0", NULL),
+	OF_DEV_AUXDATA("arm,pl011", 0x80121000, "uart1", NULL),
+	OF_DEV_AUXDATA("arm,pl011", 0x80007000, "uart2", NULL),
 	OF_DEV_AUXDATA("arm,pl022", 0x80002000, "ssp0",  &ssp0_plat),
 	OF_DEV_AUXDATA("arm,pl18x", 0x80126000, "sdi0",  &mop500_sdi0_data),
 	OF_DEV_AUXDATA("arm,pl18x", 0x80118000, "sdi1",  &mop500_sdi1_data),
-- 
1.7.10.4

