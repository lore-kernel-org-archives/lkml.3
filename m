Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241AbaLKMME (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 07:12:04 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:62746 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbaLKMMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 07:12:00 -0500
X-AuditID: cbfee68e-f79b46d000002b74-4c-54898a0e731a
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org
Cc: robh+dt@kernel.org, kishon@ti.com, k.debski@samsung.com, kgene@kernel.org,
        jg1.han@samsung.com, Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH 2/4] phy: samsung-usb2: Add facility for VBUS supply
Date: Thu, 11 Dec 2014 17:32:45 +0530
Message-id: <1418299367-2412-3-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 2.2.0
In-reply-to: <1418299367-2412-1-git-send-email-gautam.vivek@samsung.com>
References: <1418299367-2412-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsWyRsSkTpevqzPE4MJtZYv5R86xWrRdOchu
	cXnhJVaLH68vsFn0P37NbHHhaQ+bxeVdc9gsZpzfx2SxaFkrs0Xr3iPsDlwem1Z1snn0bVnF
	6HH8xnYmj8+b5AJYorhsUlJzMstSi/TtErgyfr2+zlZwVa7iVWN2A+NviS5GTg4JAROJXXe+
	MUHYYhIX7q1n62Lk4hASWMoocffOV3aYon8zfzNBJBYxSkzdcQnKmcAkMeXNJLB2NgFdiaa3
	uxhBbBGBGokpt66wgxQxC/QySvz7cI4VJCEs4CKxanIzkM3BwSKgKtF7WAokzCvgLrFnyiEW
	iG1yEltuPQLbzCngIbGo5ycLSLkQUM3VXk2QkRICy9glPq97CLaLRUBA4tvkQ2A1EgKyEpsO
	MEOMkZQ4uOIGywRG4QWMDKsYRVMLkguKk9KLjPSKE3OLS/PS9ZLzczcxAgP/9L9nfTsYbx6w
	PsQowMGoxMObEd8ZIsSaWFZcmXuI0RRow0RmKdHkfGB85ZXEGxqbGVmYmpgaG5lbmimJ8yZI
	/QwWEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwCiQ4j7BzMh+z+roT1qqO489PsTCWM9V9u/G
	7BO+LQUb3LcnrfpiMv9j7YXK1vWGd+t/l999UCd6Pt/AeUfPj50cis7vTrzcMP+9d/zn+oBZ
	HL3Sf5S+uzx4+zE/bUFS0mU73VfntnF9U5y1+rjQLIMXR++muCo+ci2sW5y4N4WtZ0Nz/e3Q
	75+VWIozEg21mIuKEwF70ll4dwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t9jAV2+rs4QgzvrpS3mHznHatF25SC7
	xeWFl1gtfry+wGbR//g1s8WFpz1sFpd3zWGzmHF+H5PFomWtzBate4+wO3B5bFrVyebRt2UV
	o8fxG9uZPD5vkgtgiWpgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21
	VXLxCdB1y8wBukhJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjDmPHr9XW2
	gqtyFa8asxsYf0t0MXJySAiYSPyb+ZsJwhaTuHBvPVsXIxeHkMAiRompOy4xQTgTmCSmvJkE
	VsUmoCvR9HYXI4gtIlAjMeXWFXaQImaBXkaJfx/OsYIkhAVcJFZNbgayOThYBFQleg9LgYR5
	Bdwl9kw5xAKxTU5iy61H7CA2p4CHxKKenywg5UJANVd7NScw8i5gZFjFKJpakFxQnJSea6RX
	nJhbXJqXrpecn7uJERxXz6R3MK5qsDjEKMDBqMTDmxHfGSLEmlhWXJl7iFGCg1lJhNcqAijE
	m5JYWZValB9fVJqTWnyI0RToponMUqLJ+cCYzyuJNzQ2MTc1NrU0sTAxs1QS51WybwsREkhP
	LEnNTk0tSC2C6WPi4JRqYKw9JvzsU/f9DT3ab56/lQ96vGkdc6R6ySvztifRK0q+TLcIyTq9
	KJurXWrr3fipzR4y86qbjgtrOnuXGLU6eCxZmyEa3LOCddXCHfmC+RriwR+KxHpXBip/s551
	omTd50Y3Fa3t+Tl3f3RO8Zj+224O1/4P8Y1G869WuYZzHncuabPgXr31vhJLcUaioRZzUXEi
	AGhDErHBAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support to enable/disable VBUS controlled by a regulator
on USB 2.0 port.
This is a part of moving vbus setting out of ehci-exynos.
Since vbus can be handled by USB 2.0 phy itself, so the host
need not care about it.
Moreover, setting VBUS in USB 2.0 phy helps both ehci as well
as ohci. This issue was not taken care of until now; when
ehci is not enabled and only ohci is enabled the VBUS was never
set.

Keeping the vbus setting code in ehci-exynos intact for now
to keep supporting older dt bindings.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 .../devicetree/bindings/phy/samsung-phy.txt        |    3 ++
 drivers/phy/phy-samsung-usb2.c                     |   30 ++++++++++++++++++++
 drivers/phy/phy-samsung-usb2.h                     |    1 +
 3 files changed, 34 insertions(+)

diff --git a/Documentation/devicetree/bindings/phy/samsung-phy.txt b/Documentation/devicetree/bindings/phy/samsung-phy.txt
index 0090ad1..44d82ba 100644
--- a/Documentation/devicetree/bindings/phy/samsung-phy.txt
+++ b/Documentation/devicetree/bindings/phy/samsung-phy.txt
@@ -44,6 +44,9 @@ Required properties:
 	- the "ref" clock is used to get the rate of the clock provided to the
 	  PHY module
 
+Optional properties:
+- vbus-supply : Reference to regulator node which supplies VBUS on the PHY.
+
 The first phandle argument in the PHY specifier identifies the PHY, its
 meaning is compatible dependent. For the currently supported SoCs (Exynos 4210
 and Exynos 4212) it is as follows:
diff --git a/drivers/phy/phy-samsung-usb2.c b/drivers/phy/phy-samsung-usb2.c
index 4a12f66..7fe7c84 100644
--- a/drivers/phy/phy-samsung-usb2.c
+++ b/drivers/phy/phy-samsung-usb2.c
@@ -16,6 +16,7 @@
 #include <linux/of_address.h>
 #include <linux/phy/phy.h>
 #include <linux/platform_device.h>
+#include <linux/regulator/consumer.h>
 #include <linux/spinlock.h>
 #include "phy-samsung-usb2.h"
 
@@ -33,6 +34,16 @@ static int samsung_usb2_phy_power_on(struct phy *phy)
 	ret = clk_prepare_enable(drv->ref_clk);
 	if (ret)
 		goto err_instance_clk;
+
+	/* Enable VBUS supply */
+	if (drv->vbus) {
+		ret = regulator_enable(drv->vbus);
+		if (ret) {
+			dev_err(drv->dev, "Failed to enable VBUS supply\n");
+			goto err_fail_vbus;
+		}
+	}
+
 	if (inst->cfg->power_on) {
 		spin_lock(&drv->lock);
 		ret = inst->cfg->power_on(inst);
@@ -41,6 +52,8 @@ static int samsung_usb2_phy_power_on(struct phy *phy)
 
 	return 0;
 
+err_fail_vbus:
+	clk_disable_unprepare(drv->ref_clk);
 err_instance_clk:
 	clk_disable_unprepare(drv->clk);
 err_main_clk:
@@ -60,8 +73,14 @@ static int samsung_usb2_phy_power_off(struct phy *phy)
 		ret = inst->cfg->power_off(inst);
 		spin_unlock(&drv->lock);
 	}
+
+	/* Disable VBUS supply */
+	if (drv->vbus)
+		regulator_disable(drv->vbus);
+
 	clk_disable_unprepare(drv->ref_clk);
 	clk_disable_unprepare(drv->clk);
+
 	return ret;
 }
 
@@ -197,6 +216,17 @@ static int samsung_usb2_phy_probe(struct platform_device *pdev)
 			return ret;
 	}
 
+	/* Get Vbus regulators */
+	drv->vbus = devm_regulator_get(dev, "vbus");
+	if (IS_ERR(drv->vbus)) {
+		ret = PTR_ERR(drv->vbus);
+		if (ret == -EPROBE_DEFER)
+			return ret;
+
+		dev_warn(dev, "Failed to get VBUS supply regulator\n");
+		drv->vbus = NULL;
+	}
+
 	for (i = 0; i < drv->cfg->num_phys; i++) {
 		char *label = drv->cfg->phys[i].label;
 		struct samsung_usb2_phy_instance *p = &drv->instances[i];
diff --git a/drivers/phy/phy-samsung-usb2.h b/drivers/phy/phy-samsung-usb2.h
index 44bead9..cb92e3e 100644
--- a/drivers/phy/phy-samsung-usb2.h
+++ b/drivers/phy/phy-samsung-usb2.h
@@ -43,6 +43,7 @@ struct samsung_usb2_phy_driver {
 	void __iomem *reg_phy;
 	struct regmap *reg_pmu;
 	struct regmap *reg_sys;
+	struct regulator *vbus;
 	spinlock_t lock;
 	struct samsung_usb2_phy_instance instances[0];
 };
-- 
1.7.10.4

