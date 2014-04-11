Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbaDKIkF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 04:40:05 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:23048 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750817AbaDKIj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 04:39:57 -0400
X-IronPort-AV: E=Sophos;i="4.97,840,1389715200"; 
   d="scan'208";a="29141568"
From: Duan Jiong <duanj.fnst@cn.fujitsu.com>
To: <maxime.ripard@free-electrons.com>
CC: <linux-kernel@vger.kernel.org>, Duan Jiong <duanj.fnst@cn.fujitsu.com>
Subject: [PATCH] PHY: sunxi: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO
Date: Fri, 11 Apr 2014 16:38:03 +0800
Message-ID: <1397205483-24395-1-git-send-email-duanj.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.225.86]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes coccinelle error regarding usage of IS_ERR and
PTR_ERR instead of PTR_ERR_OR_ZERO.

Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
---
 drivers/phy/phy-sun4i-usb.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/phy/phy-sun4i-usb.c b/drivers/phy/phy-sun4i-usb.c
index e6e6c4b..f7bffe2 100644
--- a/drivers/phy/phy-sun4i-usb.c
+++ b/drivers/phy/phy-sun4i-usb.c
@@ -302,10 +302,7 @@ static int sun4i_usb_phy_probe(struct platform_device *pdev)
 
 	dev_set_drvdata(dev, data);
 	phy_provider = devm_of_phy_provider_register(dev, sun4i_usb_phy_xlate);
-	if (IS_ERR(phy_provider))
-		return PTR_ERR(phy_provider);
-
-	return 0;
+	return PTR_ERR_OR_ZERO(phy_provider);
 }
 
 static const struct of_device_id sun4i_usb_phy_of_match[] = {
-- 
1.8.3.1

