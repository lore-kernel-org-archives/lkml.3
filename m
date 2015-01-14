Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbbANBWk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 20:22:40 -0500
Received: from m12-18.163.com ([220.181.12.18]:47231 "EHLO m12-18.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbbANBWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 20:22:39 -0500
X-Coremail-DSSMTP: 117.88.247.19
From: weiyj_lk@163.com
To: Kishon Vijay Abraham I <kishon@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>, linux-kernel@vger.kernel.org
Subject: [PATCH] phy: fix return value check in armada375_usb_phy_probe()
Date: Wed, 14 Jan 2015 09:10:00 +0800
Message-Id: <1421197800-14935-1-git-send-email-weiyj_lk@163.com>
X-Mailer: git-send-email 1.9.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: EsCowEC5_kNWxLVU7DGOAA--.767S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Wr4kAFWDXryfuF1furWfZrb_yoWDCFb_W3
	ykur93Xr4qya1IgrWUA3y5A3ySvF1kGa4DWr4Yq3yavryYgr1akr98X3s7Xrsagw4rGr9r
	K3W5Zr4Svr1xJjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUnP8n5UUUUU==
X-Originating-IP: [117.88.247.19]
X-CM-SenderInfo: pzhl5yxbonqiywtou0bp/1tbiGQuB1lEAQr7-OgAAst
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function devm_ioremap_resource() returns
ERR_PTR() and never returns NULL. The NULL test in the return
value check should be replaced with IS_ERR().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/phy/phy-armada375-usb2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/phy-armada375-usb2.c b/drivers/phy/phy-armada375-usb2.c
index ac7d99d..7c99ca2 100644
--- a/drivers/phy/phy-armada375-usb2.c
+++ b/drivers/phy/phy-armada375-usb2.c
@@ -118,8 +118,8 @@ static int armada375_usb_phy_probe(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	usb_cluster_base = devm_ioremap_resource(&pdev->dev, res);
-	if (!usb_cluster_base)
-		return -ENOMEM;
+	if (IS_ERR(usb_cluster_base))
+		return PTR_ERR(usb_cluster_base);
 
 	phy = devm_phy_create(dev, NULL, &armada375_usb_phy_ops);
 	if (IS_ERR(phy)) {

