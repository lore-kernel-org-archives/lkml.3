Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbaATOPu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 09:15:50 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:46758 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898AbaATOMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 09:12:38 -0500
From: Roger Quadros <rogerq@ti.com>
To: <bcousson@baylibre.com>, <tony@atomide.com>
CC: <balbi@ti.com>, <lee.jones@linaro.org>, <arnd@arndb.de>, <sre@debian.org>,
        <mark.rutland@arm.com>, <m.paolino@virtualopensystems.com>,
        <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH v6 01/10] mfd: omap-usb-host: Use resource managed clk_get()
Date: Mon, 20 Jan 2014 16:11:22 +0200
Message-ID: <1390227091-4523-2-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1390227091-4523-1-git-send-email-rogerq@ti.com>
References: <1390227091-4523-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_clk_get() instead of clk_get().

CC: Lee Jones <lee.jones@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/omap-usb-host.c | 81 +++++++++------------------------------------
 1 file changed, 16 insertions(+), 65 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 142650f..1c9bca2 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -674,46 +674,46 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 
 	omap->ehci_logic_fck = ERR_PTR(-EINVAL);
 	if (need_logic_fck) {
-		omap->ehci_logic_fck = clk_get(dev, "ehci_logic_fck");
+		omap->ehci_logic_fck = devm_clk_get(dev, "ehci_logic_fck");
 		if (IS_ERR(omap->ehci_logic_fck)) {
 			ret = PTR_ERR(omap->ehci_logic_fck);
 			dev_dbg(dev, "ehci_logic_fck failed:%d\n", ret);
 		}
 	}
 
-	omap->utmi_p1_gfclk = clk_get(dev, "utmi_p1_gfclk");
+	omap->utmi_p1_gfclk = devm_clk_get(dev, "utmi_p1_gfclk");
 	if (IS_ERR(omap->utmi_p1_gfclk)) {
 		ret = PTR_ERR(omap->utmi_p1_gfclk);
 		dev_err(dev, "utmi_p1_gfclk failed error:%d\n", ret);
-		goto err_p1_gfclk;
+		goto err_mem;
 	}
 
-	omap->utmi_p2_gfclk = clk_get(dev, "utmi_p2_gfclk");
+	omap->utmi_p2_gfclk = devm_clk_get(dev, "utmi_p2_gfclk");
 	if (IS_ERR(omap->utmi_p2_gfclk)) {
 		ret = PTR_ERR(omap->utmi_p2_gfclk);
 		dev_err(dev, "utmi_p2_gfclk failed error:%d\n", ret);
-		goto err_p2_gfclk;
+		goto err_mem;
 	}
 
-	omap->xclk60mhsp1_ck = clk_get(dev, "xclk60mhsp1_ck");
+	omap->xclk60mhsp1_ck = devm_clk_get(dev, "xclk60mhsp1_ck");
 	if (IS_ERR(omap->xclk60mhsp1_ck)) {
 		ret = PTR_ERR(omap->xclk60mhsp1_ck);
 		dev_err(dev, "xclk60mhsp1_ck failed error:%d\n", ret);
-		goto err_xclk60mhsp1;
+		goto err_mem;
 	}
 
-	omap->xclk60mhsp2_ck = clk_get(dev, "xclk60mhsp2_ck");
+	omap->xclk60mhsp2_ck = devm_clk_get(dev, "xclk60mhsp2_ck");
 	if (IS_ERR(omap->xclk60mhsp2_ck)) {
 		ret = PTR_ERR(omap->xclk60mhsp2_ck);
 		dev_err(dev, "xclk60mhsp2_ck failed error:%d\n", ret);
-		goto err_xclk60mhsp2;
+		goto err_mem;
 	}
 
-	omap->init_60m_fclk = clk_get(dev, "init_60m_fclk");
+	omap->init_60m_fclk = devm_clk_get(dev, "init_60m_fclk");
 	if (IS_ERR(omap->init_60m_fclk)) {
 		ret = PTR_ERR(omap->init_60m_fclk);
 		dev_err(dev, "init_60m_fclk failed error:%d\n", ret);
-		goto err_init60m;
+		goto err_mem;
 	}
 
 	for (i = 0; i < omap->nports; i++) {
@@ -727,21 +727,21 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 		 * platforms have all clocks and we can function without
 		 * them
 		 */
-		omap->utmi_clk[i] = clk_get(dev, clkname);
+		omap->utmi_clk[i] = devm_clk_get(dev, clkname);
 		if (IS_ERR(omap->utmi_clk[i]))
 			dev_dbg(dev, "Failed to get clock : %s : %ld\n",
 				clkname, PTR_ERR(omap->utmi_clk[i]));
 
 		snprintf(clkname, sizeof(clkname),
 				"usb_host_hs_hsic480m_p%d_clk", i + 1);
-		omap->hsic480m_clk[i] = clk_get(dev, clkname);
+		omap->hsic480m_clk[i] = devm_clk_get(dev, clkname);
 		if (IS_ERR(omap->hsic480m_clk[i]))
 			dev_dbg(dev, "Failed to get clock : %s : %ld\n",
 				clkname, PTR_ERR(omap->hsic480m_clk[i]));
 
 		snprintf(clkname, sizeof(clkname),
 				"usb_host_hs_hsic60m_p%d_clk", i + 1);
-		omap->hsic60m_clk[i] = clk_get(dev, clkname);
+		omap->hsic60m_clk[i] = devm_clk_get(dev, clkname);
 		if (IS_ERR(omap->hsic60m_clk[i]))
 			dev_dbg(dev, "Failed to get clock : %s : %ld\n",
 				clkname, PTR_ERR(omap->hsic60m_clk[i]));
@@ -784,7 +784,7 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 
 		if (ret) {
 			dev_err(dev, "Failed to create DT children: %d\n", ret);
-			goto err_alloc;
+			goto err_mem;
 		}
 
 	} else {
@@ -792,40 +792,12 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 		if (ret) {
 			dev_err(dev, "omap_usbhs_alloc_children failed: %d\n",
 						ret);
-			goto err_alloc;
+			goto err_mem;
 		}
 	}
 
 	return 0;
 
-err_alloc:
-	for (i = 0; i < omap->nports; i++) {
-		if (!IS_ERR(omap->utmi_clk[i]))
-			clk_put(omap->utmi_clk[i]);
-		if (!IS_ERR(omap->hsic60m_clk[i]))
-			clk_put(omap->hsic60m_clk[i]);
-		if (!IS_ERR(omap->hsic480m_clk[i]))
-			clk_put(omap->hsic480m_clk[i]);
-	}
-
-	clk_put(omap->init_60m_fclk);
-
-err_init60m:
-	clk_put(omap->xclk60mhsp2_ck);
-
-err_xclk60mhsp2:
-	clk_put(omap->xclk60mhsp1_ck);
-
-err_xclk60mhsp1:
-	clk_put(omap->utmi_p2_gfclk);
-
-err_p2_gfclk:
-	clk_put(omap->utmi_p1_gfclk);
-
-err_p1_gfclk:
-	if (!IS_ERR(omap->ehci_logic_fck))
-		clk_put(omap->ehci_logic_fck);
-
 err_mem:
 	pm_runtime_disable(dev);
 
@@ -847,27 +819,6 @@ static int usbhs_omap_remove_child(struct device *dev, void *data)
  */
 static int usbhs_omap_remove(struct platform_device *pdev)
 {
-	struct usbhs_hcd_omap *omap = platform_get_drvdata(pdev);
-	int i;
-
-	for (i = 0; i < omap->nports; i++) {
-		if (!IS_ERR(omap->utmi_clk[i]))
-			clk_put(omap->utmi_clk[i]);
-		if (!IS_ERR(omap->hsic60m_clk[i]))
-			clk_put(omap->hsic60m_clk[i]);
-		if (!IS_ERR(omap->hsic480m_clk[i]))
-			clk_put(omap->hsic480m_clk[i]);
-	}
-
-	clk_put(omap->init_60m_fclk);
-	clk_put(omap->utmi_p1_gfclk);
-	clk_put(omap->utmi_p2_gfclk);
-	clk_put(omap->xclk60mhsp2_ck);
-	clk_put(omap->xclk60mhsp1_ck);
-
-	if (!IS_ERR(omap->ehci_logic_fck))
-		clk_put(omap->ehci_logic_fck);
-
 	pm_runtime_disable(&pdev->dev);
 
 	/* remove children */
-- 
1.8.3.2

