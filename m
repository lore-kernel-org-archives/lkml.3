Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab3KGC2K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 21:28:10 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:44783 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753222Ab3KGC2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 21:28:08 -0500
From: Jisheng Zhang <jszhang@marvell.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <shawn.guo@linaro.org>, Jisheng Zhang <jszhang@marvell.com>
Subject: [PATCH] usb: phy: phy-mxs-usb: set the correct platform drvdata
Date: Thu, 7 Nov 2013 10:26:20 +0800
Message-ID: <1383791180-3579-1-git-send-email-jszhang@marvell.com>
X-Mailer: git-send-email 1.8.4.2
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-11-06_06:2013-11-06,2013-11-06,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1311060250
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to set mxs_phy rather as the platform drvdata so that we can get
the correct mxs_phy in mxs_phy_remove().

Change-Id: I6e1753cc978e2ed3fbb3d1865be0c54031d337d2
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

