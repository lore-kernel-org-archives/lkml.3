Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbaDXK3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:29:45 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:49039 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019AbaDXK0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 06:26:46 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Ben Dooks <ben.dooks@codethink.co.uk>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 2/6] ARM: davinci: Use generic runtime and clock helpers
Date: Thu, 24 Apr 2014 12:26:34 +0200
Message-Id: <1398335198-26555-3-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398335198-26555-1-git-send-email-geert+renesas@glider.be>
References: <1398335198-26555-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 arch/arm/mach-davinci/pm_domain.c |   34 ++--------------------------------
 1 file changed, 2 insertions(+), 32 deletions(-)

diff --git a/arch/arm/mach-davinci/pm_domain.c b/arch/arm/mach-davinci/pm_domain.c
index 6b98413cebd6..eb2eb126fdc0 100644
--- a/arch/arm/mach-davinci/pm_domain.c
+++ b/arch/arm/mach-davinci/pm_domain.c
@@ -10,43 +10,13 @@
  * warranty of any kind, whether express or implied.
  */
 #include <linux/init.h>
-#include <linux/pm_runtime.h>
 #include <linux/pm_clock.h>
 #include <linux/platform_device.h>
 
-#ifdef CONFIG_PM_RUNTIME
-static int davinci_pm_runtime_suspend(struct device *dev)
-{
-	int ret;
-
-	dev_dbg(dev, "%s\n", __func__);
-
-	ret = pm_generic_runtime_suspend(dev);
-	if (ret)
-		return ret;
-
-	ret = pm_clk_suspend(dev);
-	if (ret) {
-		pm_generic_runtime_resume(dev);
-		return ret;
-	}
-
-	return 0;
-}
-
-static int davinci_pm_runtime_resume(struct device *dev)
-{
-	dev_dbg(dev, "%s\n", __func__);
-
-	pm_clk_resume(dev);
-	return pm_generic_runtime_resume(dev);
-}
-#endif
-
 static struct dev_pm_domain davinci_pm_domain = {
 	.ops = {
-		SET_RUNTIME_PM_OPS(davinci_pm_runtime_suspend,
-				   davinci_pm_runtime_resume, NULL)
+		SET_RUNTIME_PM_OPS(pm_generic_runtime_clk_suspend,
+				   pm_generic_clk_runtime_resume, NULL)
 		USE_PLATFORM_PM_SLEEP_OPS
 	},
 };
-- 
1.7.9.5

