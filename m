Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbaIYQ3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 12:29:23 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:51800 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbaIYQ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 12:28:55 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Tomasz Figa <tomasz.figa@gmail.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Kevin Hilman <khilman@linaro.org>, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v3 05/13] PM / Domains: Add helper variable np = dev->of_node
Date: Thu, 25 Sep 2014 18:28:32 +0200
Message-Id: <1411662520-22795-6-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411662520-22795-1-git-send-email-geert+renesas@glider.be>
References: <1411662520-22795-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
v3:
  - No changes
v2:
  - New

 drivers/base/power/domain.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index 6e36bb09e7d9c144..0ebc6bb31c9c227f 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -2171,17 +2171,18 @@ static void genpd_dev_pm_detach(struct device *dev, bool power_off)
  */
 int genpd_dev_pm_attach(struct device *dev)
 {
+	struct device_node *np = dev->of_node;
 	struct of_phandle_args pd_args;
 	struct generic_pm_domain *pd;
 	int ret;
 
-	if (!dev->of_node)
+	if (!np)
 		return -ENODEV;
 
 	if (dev->pm_domain)
 		return -EEXIST;
 
-	ret = of_parse_phandle_with_args(dev->of_node, "power-domains",
+	ret = of_parse_phandle_with_args(np, "power-domains",
 					"#power-domain-cells", 0, &pd_args);
 	if (ret < 0) {
 		if (ret != -ENOENT)
@@ -2192,8 +2193,7 @@ int genpd_dev_pm_attach(struct device *dev)
 		 * (for backwards compatibility of DT ABI)
 		 */
 		pd_args.args_count = 0;
-		pd_args.np = of_parse_phandle(dev->of_node,
-						"samsung,power-domain", 0);
+		pd_args.np = of_parse_phandle(np, "samsung,power-domain", 0);
 		if (!pd_args.np)
 			return -ENOENT;
 	}
@@ -2202,7 +2202,7 @@ int genpd_dev_pm_attach(struct device *dev)
 	if (IS_ERR(pd)) {
 		dev_dbg(dev, "%s() failed to find PM domain: %ld\n",
 			__func__, PTR_ERR(pd));
-		of_node_put(dev->of_node);
+		of_node_put(np);
 		return PTR_ERR(pd);
 	}
 
@@ -2218,7 +2218,7 @@ int genpd_dev_pm_attach(struct device *dev)
 	if (ret < 0) {
 		dev_err(dev, "failed to add to PM domain %s: %d",
 			pd->name, ret);
-		of_node_put(dev->of_node);
+		of_node_put(np);
 		return ret;
 	}
 
-- 
1.9.1

