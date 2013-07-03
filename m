Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615Ab3GCIqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 04:46:47 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39760 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932065Ab3GCIpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 04:45:13 -0400
From: Hebbar Gururaja <gururaja.hebbar@ti.com>
To: <khilman@linaro.org>, <tony@atomide.com>, <benoit.cousson@gmail.com>
CC: <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <vaibhav.bedia@ti.com>, <sudhakar.raj@ti.com>,
        <gururaja.hebbar@ti.com>, Russell King <linux@arm.linux.org.uk>
Subject: [Patch V2 2/4] ARM: Davinci: da8xx/omap-l1: Remove hard coding of rtc device wakeup
Date: Wed, 3 Jul 2013 14:17:03 +0530
Message-ID: <1372841225-18813-3-git-send-email-gururaja.hebbar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372841225-18813-1-git-send-email-gururaja.hebbar@ti.com>
References: <1372841225-18813-1-git-send-email-gururaja.hebbar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since now rtc-omap driver itself calls deice_init_wakeup(dev, true),
duplicate call from the rtc device registration can be removed.

This is basically a partial revert of the prev commit

commit 75c99bb0006ee065b4e2995078d779418b0fab54
Author: Sekhar Nori <nsekhar@ti.com>

    davinci: da8xx/omap-l1: mark RTC as a wakeup source

Signed-off-by: Hebbar Gururaja <gururaja.hebbar@ti.com>
Acked-by: Kevin Hilman <khilman@linaro.org>
Acked-by: Sekhar Nori <nsekhar@ti.com>
Cc: Russell King <linux@arm.linux.org.uk>
---
Changes in V2:
	- Coding style corrections (remove extra space)
	- use prefix ARM: for commit subject keeping with arch/arm convention

:100644 100644 bf57252... 9140b1c... M	arch/arm/mach-davinci/devices-da8xx.c
 arch/arm/mach-davinci/devices-da8xx.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/arch/arm/mach-davinci/devices-da8xx.c b/arch/arm/mach-davinci/devices-da8xx.c
index bf57252..9140b1c 100644
--- a/arch/arm/mach-davinci/devices-da8xx.c
+++ b/arch/arm/mach-davinci/devices-da8xx.c
@@ -827,14 +827,7 @@ static struct platform_device da8xx_rtc_device = {
 
 int da8xx_register_rtc(void)
 {
-	int ret;
-
-	ret = platform_device_register(&da8xx_rtc_device);
-	if (!ret)
-		/* Atleast on DA850, RTC is a wakeup source */
-		device_init_wakeup(&da8xx_rtc_device.dev, true);
-
-	return ret;
+	return platform_device_register(&da8xx_rtc_device);
 }
 
 static void __iomem *da8xx_ddr2_ctlr_base;
-- 
1.7.9.5

