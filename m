Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab3CBNZr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 08:25:47 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:30674 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab3CBNZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 08:25:43 -0500
X-AuditID: cbfee68f-b7f6a6d000004969-b0-5131fdd65f8a
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, sarah.a.sharp@linux.intel.com, kgene.kim@samsung.com,
        kishon@ti.com
Subject: [PATCH v2 07/10] usb: phy: samsung: Enable runtime power management on
 usb3phy
Date: Sat, 02 Mar 2013 18:53:08 +0530
Message-id: <1362230590-20960-8-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1362230590-20960-1-git-send-email-gautam.vivek@samsung.com>
References: <1362230590-20960-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsWyRsSkVvfaX8NAg6vvhSwO3q+3aF68ns2i
	d8FVNosLT3vYLC7vmsNmMXtJP4vFjPP7mCwWLWtltmg+cYrZgdNj3slAj/1z17B79G1Zxehx
	/MZ2Jo/Pm+QCWKO4bFJSczLLUov07RK4Mvp7H7EVTOOsmH8ns4HxOXsXIyeHhICJRN+Wm8wQ
	tpjEhXvr2boYuTiEBJYySrTNnMQIU/R7BkiCEygxnVHi45EqiKIpTBKvey8ygSTYBHQlmt7u
	AmsQEZCVOHzlNzNIEbPAJUaJFSu2sIAkhAUiJZ79PA1mswioSvw41M7axcjBwSvgIfH/ryrE
	MgWJN7efgV3EKeApMf36ZlaIxR4Sf+4dh7p6FbvEglWeEGMEJL5NPsQCMkYCaO+mA1DPSEoc
	XHGDZQKj8AJGhlWMoqkFyQXFSelFxnrFibnFpXnpesn5uZsYgSF/+t+z/h2Mdw9YH2JMBho3
	kVlKNDkfGDN5JfGGxibmpsamZkaWlpampAkrifPKX5IJFBJITyxJzU5NLUgtii8qzUktPsTI
	xMEp1cCofZxv+qMXe0ucgquyjmgsuG168/nnJWv02SwmXQ984TZltafWXW7l9H8BpzyUF3Rx
	H1nJdsXPwjhXqSIl9JHplPjqEw1yb75opzc3/VOJmpeS7Lrq5nRZo8KZ7HnMvK9+zT6hM0/w
	4xl9Nv6UzJjZIivdV2QuaTBSvr4h20HgjJwPV+yVHEklluKMREMt5qLiRAAAltSKjwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t9jQd1rfw0DDb5u4bQ4eL/eonnxejaL
	3gVX2SwuPO1hs7i8aw6bxewl/SwWM87vY7JYtKyV2aL5xClmB06PeScDPfbPXcPu0bdlFaPH
	8RvbmTw+b5ILYI1qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy
	8QnQdcvMAbpHSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5jR3/uIrWAa
	Z8X8O5kNjM/Zuxg5OSQETCR+z1jPBmGLSVy4B2ELCUxnlPh4pKqLkQvInsIk8br3IhNIgk1A
	V6Lp7S5GEFtEQFbi8JXfzCBFzAKXGCVWrNjCApIQFoiUePbzNJjNIqAq8eNQO2sXIwcHr4CH
	xP+/qhDLFCTe3H7GDGJzCnhKTL++mRVisYfEn3vH2Scw8i5gZFjFKJpakFxQnJSea6hXnJhb
	XJqXrpecn7uJERxTz6R2MK5ssDjEKMDBqMTDG/DRIFCINbGsuDL3EKMEB7OSCO/5q4aBQrwp
	iZVVqUX58UWlOanFhxiTgY6ayCwlmpwPjPe8knhDYxNzU2NTSxMLEzNL0oSVxHkZTz0JEBJI
	TyxJzU5NLUgtgtnCxMEp1cA425XrccEu64fBOv2CzQq97uz+LTyWpaqGG7Sl9ezeTj3nKFZr
	LPPjBed+nYJZiwvn5WyOWrh9p+53oV8mV9aqmp+pYCj4rvO1/G3ktVONfv2X2T7HC9z884vn
	5ZKjkgLPf9gf05kdmhoecjHU84QhJ8+K8tObfwvMm7YsL0nhc959xSsP/N4psRRnJBpqMRcV
	JwIAljzT8e0CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable autosuspending of Samsung usb3.0 PHY

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/usb/phy/samsung-usb3phy.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/phy/samsung-usb3phy.c b/drivers/usb/phy/samsung-usb3phy.c
index 70e2c7b..7594cc7 100644
--- a/drivers/usb/phy/samsung-usb3phy.c
+++ b/drivers/usb/phy/samsung-usb3phy.c
@@ -24,6 +24,7 @@
 #include <linux/err.h>
 #include <linux/io.h>
 #include <linux/of.h>
+#include <linux/pm_runtime.h>
 #include <linux/usb/samsung_usb_phy.h>
 #include <linux/platform_data/samsung-usbphy.h>
 
@@ -287,6 +288,8 @@ static int samsung_usb3phy_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, sphy);
 
+	pm_runtime_enable(&pdev->dev);
+
 	return usb_add_phy(&sphy->phy, USB_PHY_TYPE_USB3);
 }
 
@@ -296,6 +299,10 @@ static int samsung_usb3phy_remove(struct platform_device *pdev)
 
 	usb_remove_phy(&sphy->phy);
 
+	if (!pm_runtime_suspended(&pdev->dev))
+		pm_runtime_put(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+
 	if (sphy->pmuregs)
 		iounmap(sphy->pmuregs);
 	if (sphy->sysreg)
-- 
1.7.6.5

