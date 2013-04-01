Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758681Ab3DAN6F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 09:58:05 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:57893 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758529Ab3DAN6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 09:58:00 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-01-51599266fefe
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-omap@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, balbi@ti.com,
        stern@rowland.harvard.edu, sarah.a.sharp@linux.intel.com,
        rob.herring@calxeda.com, kgene.kim@samsung.com, kishon@ti.com,
        dianders@chromium.org, t.figa@samsung.com, p.paneri@samsung.com
Subject: [PATCH v3 05/11] usb: dwc3: exynos: Enable runtime power management
Date: Mon, 01 Apr 2013 19:24:04 +0530
Message-id: <1364824448-14732-6-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1364824448-14732-1-git-send-email-gautam.vivek@samsung.com>
References: <1364824448-14732-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsWyRsSkWjdtUmSgwbl3NhYH79dbnF12kM2i
	efF6NoveBVfZLC487WGzuLxrDpvF7CX9LBYzzu9jsli0rJXZ4vyWTiaLwysOMFk0nzjFbDHh
	9wU2i/UzXrM48Hks+HyF3WN2w0UWj3knAz32z10D5N39wejRt2UVo8fxG9uZPD5vkgvgiOKy
	SUnNySxLLdK3S+DKOPJuInNBL2/Fvzk32BoYu7i7GDk5JARMJO5cPMwEYYtJXLi3nq2LkYtD
	SGApo8TFjlvsMEWTr89lhEgsYpTYOXcNlDOFSWLNoWNsIFVsAroSTW93ASU4OEQE4iQ2TxAG
	CTMLdDFJLD0qDmILC/hI/Ph1Emwoi4CqxO57z8BaeQU8JE6+/coKsUxB4s3tZ8wgNqeAp8SH
	rYvBrhMCqmm/eoIVZK+EwCN2iadzfzJBDBKQ+Db5EAvIXgkBWYlNB5gh5khKHFxxg2UCo/AC
	RoZVjKKpBckFxUnpRcZ6xYm5xaV56XrJ+bmbGIFxdPrfs/4djHcPWB9iTAYaN5FZSjQ5HxiH
	eSXxhsZmRhamJqbGRuaWZqQJK4nzqrVYBwoJpCeWpGanphakFsUXleakFh9iZOLglGpglN1w
	asaXuxmRZ0TSHLZEbbn6UVre9tX+9qe/pxgedVmXsLJ8+9QlLrH8ttcUp2+2eia1LsWwx8+Y
	9fqaC3Z2sxusDW1X7lBoPj5/dsqrNK1t9dyhjCadLiliX5Zf+iK5zvr9gg86d5Zk6YrcTr18
	50fCpZ9PDyxUedb48Xwqd8r5F0/+LDr3KlKJpTgj0VCLuag4EQB+FOnnuQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42I5/e+xgG7apMhAg3fHjC0O3q+3OLvsIJtF
	8+L1bBa9C66yWVx42sNmcXnXHDaL2Uv6WSxmnN/HZLFoWSuzxfktnUwWh1ccYLJoPnGK2WLC
	7wtsFutnvGZx4PNY8PkKu8fshossHvNOBnrsn7sGyLv7g9Gjb8sqRo/jN7YzeXzeJBfAEdXA
	aJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdLeSQlli
	TilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMePIu4nMBb28Ff/m3GBrYOzi7mLk
	5JAQMJGYfH0uI4QtJnHh3nq2LkYuDiGBRYwSO+euYYRwpjBJrDl0jA2kik1AV6Lp7S6gBAeH
	iECcxOYJwiBhZoEuJomlR8VBbGEBH4kfv06yg9gsAqoSu+89A2vlFfCQOPn2KyvEMgWJN7ef
	MYPYnAKeEh+2LmYCsYWAatqvnmCdwMi7gJFhFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZw
	lD6T2sG4ssHiEKMAB6MSD2/EhYhAIdbEsuLK3EOMEhzMSiK8KzIjA4V4UxIrq1KL8uOLSnNS
	iw8xJgNdNZFZSjQ5H5hA8kriDY1NzE2NTS1NLEzMLEkTVhLnPdBqHSgkkJ5YkpqdmlqQWgSz
	hYmDU6qB0U0rNvZ9yj2/WXn/mVt350afTutV/qPFLzLZ/Pltk7vhYiKuCnaHyuYdmfymaMvC
	Y2s+H5rLEGBTxNG0XMuuWc7rr/A3vRcVPyU9vQ2/5qR8rhTeyXhoeV1RQ8LJlh3X+8XK6nge
	MkqutLFfE6rN0HXBSvP5xC/HN945H3zYZ9LMT+2qqjwsSizFGYmGWsxFxYkA5VvHAxYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enabling runtime power management on dwc3-exynos
letting dwc3 controller to be autosuspended on exynos
platform when not in use.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/usb/dwc3/dwc3-exynos.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-exynos.c
index 1ea7bd8..1ae81a0 100644
--- a/drivers/usb/dwc3/dwc3-exynos.c
+++ b/drivers/usb/dwc3/dwc3-exynos.c
@@ -19,6 +19,7 @@
 #include <linux/platform_data/dwc3-exynos.h>
 #include <linux/dma-mapping.h>
 #include <linux/clk.h>
+#include <linux/pm_runtime.h>
 #include <linux/usb/otg.h>
 #include <linux/usb/nop-usb-xceiv.h>
 #include <linux/of.h>
@@ -138,6 +139,11 @@ static int dwc3_exynos_probe(struct platform_device *pdev)
 	exynos->dev	= dev;
 	exynos->clk	= clk;
 
+	pm_runtime_set_active(dev);
+	pm_runtime_enable(dev);
+	pm_runtime_get_sync(dev);
+	pm_runtime_forbid(dev);
+
 	clk_prepare_enable(exynos->clk);
 
 	if (node) {
@@ -152,10 +158,14 @@ static int dwc3_exynos_probe(struct platform_device *pdev)
 		goto err2;
 	}
 
+	pm_runtime_put_sync(dev);
+	pm_runtime_allow(dev);
+
 	return 0;
 
 err2:
 	clk_disable_unprepare(clk);
+	pm_runtime_disable(dev);
 err1:
 	return ret;
 }
@@ -164,6 +174,8 @@ static int dwc3_exynos_remove(struct platform_device *pdev)
 {
 	struct dwc3_exynos	*exynos = platform_get_drvdata(pdev);
 
+	pm_runtime_disable(&pdev->dev);
+
 	platform_device_unregister(exynos->usb2_phy);
 	platform_device_unregister(exynos->usb3_phy);
 	device_for_each_child(&pdev->dev, NULL, dwc3_exynos_remove_child);
-- 
1.7.6.5

