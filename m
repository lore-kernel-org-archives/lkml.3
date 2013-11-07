Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab3KGC5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 21:57:44 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:53731 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753667Ab3KGC5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 21:57:42 -0500
From: Jisheng Zhang <jszhang@marvell.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <shawn.guo@linaro.org>, Jisheng Zhang <jszhang@marvell.com>
Subject: [PATCH v2] usb: phy: phy-mxs-usb: set the correct platform drvdata
Date: Thu, 7 Nov 2013 10:55:49 +0800
Message-ID: <1383792949-4521-1-git-send-email-jszhang@marvell.com>
X-Mailer: git-send-email 1.8.4.2
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-11-07_01:2013-11-06,2013-11-07,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1311060258
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to set mxs_phy rather as the platform drvdata so that we can get
the correct mxs_phy in mxs_phy_remove().

Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
---
 drivers/usb/phy/phy-mxs-usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/phy/phy-mxs-usb.c b/drivers/usb/phy/phy-mxs-usb.c
index fdd33b4..545844b 100644
--- a/drivers/usb/phy/phy-mxs-usb.c
+++ b/drivers/usb/phy/phy-mxs-usb.c
@@ -164,7 +164,7 @@ static int mxs_phy_probe(struct platform_device *pdev)
 
 	mxs_phy->clk = clk;
 
-	platform_set_drvdata(pdev, &mxs_phy->phy);
+	platform_set_drvdata(pdev, mxs_phy);
 
 	ret = usb_add_phy_dev(&mxs_phy->phy);
 	if (ret)
-- 
1.8.4.2

