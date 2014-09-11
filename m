Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529AbaIKMx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:53:59 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:22894 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405AbaIKMx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:53:56 -0400
X-AuditID: cbfee61b-f79f86d00000144c-e7-54119b61ad24
From: Robert Baldyga <r.baldyga@samsung.com>
To: paulz@synopsys.com
Cc: gregkh@linuxfoundation.org, dinguyen@opensource.altera.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        m.szyprowski@samsung.com, b.zolnierkie@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 2/2] Revert
 "usb: dwc2: move "samsung,s3c6400-hsotg" into common platform"
Date: Thu, 11 Sep 2014 14:53:31 +0200
Message-id: <1410440011-9106-3-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1410440011-9106-1-git-send-email-r.baldyga@samsung.com>
References: <1410440011-9106-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKLMWRmVeSWpSXmKPExsVy+t9jAd3E2YIhBpvaLS02zljParHq0xpm
	i+bF69ksLu+aw2axaFkrs8XaI3fZLbZPmc5k8eDwTnYHDo/9c9ewe/Rfm8Tu0bdlFaPHlv2f
	GT0+b5ILYI3isklJzcksSy3St0vgypi736PgF2fF1i8vWRsYN3B0MXJySAiYSPTuXcEOYYtJ
	XLi3nq2LkYtDSGARo8TiaVMZIZx2Jol1/5+wglSxCehIbPk+ASjBwSEC1PH9AydIDbPATUaJ
	+csnsYPEhQViJOa1O4CYLAKqEh93OIOYvAIuEg8fukGskpM4eWwy2EBOAVeJ9b17wE4QAir5
	uOc82wRG3gWMDKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxggPrmfQOxlUNFocYBTgYlXh4
	K1kEQ4RYE8uKK3MPMUpwMCuJ8N6YDhTiTUmsrEotyo8vKs1JLT7EKM3BoiTOe7DVOlBIID2x
	JDU7NbUgtQgmy8TBKdXAyPIoi9c38moex9riT0d0rVl95BcXF6u8NPb5fuO25jr1j4yv05ac
	7HOfoMaTcl+xOkY3TbZwc1xbzN96F3ah52rc7iyOkgbPlS7mPPabUniktHGro7PJjeWe8Tkv
	731f45gRP89bp8pqevDCSdZzS7byl7ZNbp+xgcNDQSCn/kdMu+Da3UFKLMUZiYZazEXFiQAT
	ly7hKAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 8df438571cdbd5c4fcd1b25b19eea1ad5c3cf777.

This patch breaks building dwc2 driver in gadget mode at samsung
platforms.
---
 drivers/usb/dwc2/gadget.c   | 1 +
 drivers/usb/dwc2/platform.c | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 0eb60ef..ce6071d 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -3640,6 +3640,7 @@ static int s3c_hsotg_resume(struct platform_device *pdev)
 
 #ifdef CONFIG_OF
 static const struct of_device_id s3c_hsotg_of_ids[] = {
+	{ .compatible = "samsung,s3c6400-hsotg", },
 	{ .compatible = "snps,dwc2", },
 	{ /* sentinel */ }
 };
diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
index 544a13e..121dbda 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -129,7 +129,6 @@ static const struct of_device_id dwc2_of_match_table[] = {
 	{ .compatible = "brcm,bcm2835-usb", .data = &params_bcm2835 },
 	{ .compatible = "rockchip,rk3066-usb", .data = &params_rk3066 },
 	{ .compatible = "snps,dwc2", .data = NULL },
-	{ .compatible = "samsung,s3c6400-hsotg", .data = NULL},
 	{},
 };
 MODULE_DEVICE_TABLE(of, dwc2_of_match_table);
-- 
1.9.1

