Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab3CBN2R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 08:28:17 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:30661 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab3CBNZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 08:25:22 -0500
X-AuditID: cbfee68d-b7f636d0000009be-e7-5131fdc052ca
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, sarah.a.sharp@linux.intel.com, kgene.kim@samsung.com,
        kishon@ti.com, Doug Anderson <dianders@chromium.org>
Subject: [PATCH v2 02/10] USB: dwc3: Adjust runtime pm to allow autosuspend
Date: Sat, 02 Mar 2013 18:53:03 +0530
Message-id: <1362230590-20960-3-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1362230590-20960-1-git-send-email-gautam.vivek@samsung.com>
References: <1362230590-20960-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42JZI2JSq3vgr2Ggwb8tMhYH79dbnF12kM2i
	efF6NoveBVfZLC487WGzuLxrDpvF7CX9LBYzzu9jsli0rJXZovnEKWYHLo/ZDRdZPOadDPTY
	P3cNu0ffllWMHsdvbGfy+LxJLoAtissmJTUnsyy1SN8ugStj/8ff7AX3OCt2fp7H3MDYxtHF
	yMkhIWAisa/zGyuELSZx4d56ti5GLg4hgaWMEo3zb7HCFG1ovckOkZjOKHF1zmYoZwqTRNem
	Q0wgVWwCuhJNb3cxgtgiArISh6/8ZgYpYhb4zShxfvccsFHCAt4SH7+2sIPYLAKqEifufGMG
	sXkFPCQ23rnLArFOQeLN7WdgcU4BT4np1zeD9QoB1fy5dxxss4TALnaJY4uvQQ0SkPg2+RBQ
	MwdQQlZi0wFmiDmSEgdX3GCZwCi8gJFhFaNoakFyQXFSepGhXnFibnFpXrpecn7uJkZgPJz+
	96x3B+PtA9aHGJOBxk1klhJNzgfGU15JvKGxibmpsamZkaWlpSlpwkrivHKXZAKFBNITS1Kz
	U1MLUovii0pzUosPMTJxcEo1MOpPFVKqZxEyPNvxI0Bb2OFg4qs5Ar25BRePKbzV2tnB/4Kh
	bbrfsbdJToErXzIXbVkZNG/T/F01vwzrd8UEV/2arnzibvqflXMa5v9V/MUdPYXlWEmzQQHj
	uZlT7twTMJOcs+/xXP3TYf8n5LjV28lc2eGeM11Eo2/J68VbW94m3+LI3qjyT0CJpTgj0VCL
	uag4EQDBAWDYnQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t9jQd0Dfw0DDV5/E7Q4eL/e4uyyg2wW
	zYvXs1n0LrjKZnHhaQ+bxeVdc9gsZi/pZ7GYcX4fk8WiZa3MFs0nTjE7cHnMbrjI4jHvZKDH
	/rlr2D36tqxi9Dh+YzuTx+dNcgFsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaW
	FuZKCnmJuam2Si4+AbpumTlAlykplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkAD
	CWsYM/Z//M1ecI+zYufnecwNjG0cXYycHBICJhIbWm+yQ9hiEhfurWfrYuTiEBKYzihxdc5m
	dghnCpNE16ZDTCBVbAK6Ek1vdzGC2CICshKHr/xmBiliFvjNKHF+9xxWkISwgLfEx68tYGNZ
	BFQlTtz5xgxi8wp4SGy8c5cFYp2CxJvbz8DinAKeEtOvbwbrFQKq+XPvOPsERt4FjAyrGEVT
	C5ILipPScw31ihNzi0vz0vWS83M3MYKj7ZnUDsaVDRaHGAU4GJV4eAM+GgQKsSaWFVfmHmKU
	4GBWEuE9f9UwUIg3JbGyKrUoP76oNCe1+BBjMtBVE5mlRJPzgYkgryTe0NjE3NTY1NLEwsTM
	kjRhJXFexlNPAoQE0hNLUrNTUwtSi2C2MHFwSjUw1jQnfzsdcdn7oUort0V60ZvXRZftAooX
	72mxc7i7diJz12Gm57XCOWrLzkwX89M4s523N8vvaN+CmXFduobyU/NPaVzfp9H8cWX2j7WT
	TwvJNSaJlnILnLo+b+evh1eCV+tKthsKprAV7phwgK8p49Vvn23uciLOS84ErmLPmltsG93k
	/2CREktxRqKhFnNRcSIAIvrLqvoCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code in the dwc3 probe effectively disables runtime pm
from ever working because it calls a get() that was never put() until
device removal.  Change the runtime pm code to match the standard
formula and allow runtime pm to function.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
CC: Doug Anderson <dianders@chromium.org>
---
 drivers/usb/dwc3/core.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index be0672f..85914e0 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -528,6 +528,7 @@ static int dwc3_probe(struct platform_device *pdev)
 		goto err3;
 	}
 
+	pm_runtime_put_sync(dev);
 	pm_runtime_allow(dev);
 
 	return 0;
@@ -557,6 +558,7 @@ err1:
 
 err0:
 	dwc3_free_event_buffers(dwc);
+	pm_runtime_disable(&pdev->dev);
 
 	return ret;
 }
@@ -568,7 +570,8 @@ static int dwc3_remove(struct platform_device *pdev)
 	usb_phy_set_suspend(dwc->usb2_phy, 1);
 	usb_phy_set_suspend(dwc->usb3_phy, 1);
 
-	pm_runtime_put(&pdev->dev);
+	if (!pm_runtime_suspended(&pdev->dev))
+		pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
 	dwc3_debugfs_exit(dwc);
-- 
1.7.6.5

