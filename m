Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781AbaIYPGc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:06:32 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39259 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753745AbaIYPG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:06:29 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: <santosh.shilimkar@ti.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        <khilman@linaro.org>
CC: Geert Uytterhoeven <geert+renesas@glider.be>, <linux-pm@vger.kernel.org>,
        <ben.dooks@codethink.co.uk>, <laurent.pinchart@ideasonboard.com>,
        <grant.likely@secretlab.ca>, <ulf.hansson@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [RFC PATCH 3/4] ARM: keystone: pm: remove unused clk pm domain code
Date: Thu, 25 Sep 2014 18:05:36 +0300
Message-ID: <1411657537-25238-4-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411657537-25238-1-git-send-email-grygorii.strashko@ti.com>
References: <1411657537-25238-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused CLK PM domain code, since Keystone 2 PM
has been switched to use Generic PM domain framework.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 arch/arm/mach-keystone/pm_domain.c | 57 --------------------------------------
 1 file changed, 57 deletions(-)

diff --git a/arch/arm/mach-keystone/pm_domain.c b/arch/arm/mach-keystone/pm_domain.c
index 3cf6696..8a70caa 100644
--- a/arch/arm/mach-keystone/pm_domain.c
+++ b/arch/arm/mach-keystone/pm_domain.c
@@ -21,53 +21,6 @@
 #include <linux/platform_device.h>
 #include <linux/of.h>
 
-#ifdef CONFIG_PM_RUNTIME
-
-static int keystone_pm_runtime_suspend(struct device *dev)
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
-static int keystone_pm_runtime_resume(struct device *dev)
-{
-	dev_dbg(dev, "%s\n", __func__);
-
-	pm_clk_resume(dev);
-
-	return pm_generic_runtime_resume(dev);
-}
-#endif
-
-static struct dev_pm_domain keystone_pm_domain = {
-	.ops = {
-		SET_RUNTIME_PM_OPS(keystone_pm_runtime_suspend,
-				   keystone_pm_runtime_resume, NULL)
-		USE_PLATFORM_PM_SLEEP_OPS
-	},
-};
-
-static struct pm_clk_notifier_block platform_domain_notifier = {
-	.pm_domain = &keystone_pm_domain,
-};
-
-static struct of_device_id of_keystone_table[] = {
-	{.compatible = "ti,keystone"},
-	{ /* end of list */ },
-};
 
 #ifdef CONFIG_PM_GENERIC_DOMAINS
 
@@ -183,15 +136,5 @@ static int __init keystone_pm_domain_init(void) { return 0; }
 
 int __init keystone_pm_runtime_init(void)
 {
-	struct device_node *np;
-
-	np = of_find_matching_node(NULL, of_keystone_table);
-	if (!np)
-		return 0;
-
-	/* TODO: remove clock_ops code
-	 * pm_clk_add_notifier(&platform_bus_type, &platform_domain_notifier);
-	 */
-
 	return keystone_pm_domain_init();
 }
-- 
1.9.1

