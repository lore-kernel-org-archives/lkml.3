Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668Ab3EUCm5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 22:42:57 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:32381 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab3EUCm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 22:42:56 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lizefan@huawei.com>, <libo.chen@huawei.com>
Subject: [PATCH 06/19] drivers/usb/phy: add missing platform_driver owner
Date: Tue, 21 May 2013 10:42:18 +0800
Message-ID: <1369104138-20552-1-git-send-email-libo.chen@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set the owner of platform_driver, to ensure that the
caller of driver holds a module refernece

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/usb/phy/phy-rcar-usb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/phy/phy-rcar-usb.c b/drivers/usb/phy/phy-rcar-usb.c
index a35681b..a3422a5 100644
--- a/drivers/usb/phy/phy-rcar-usb.c
+++ b/drivers/usb/phy/phy-rcar-usb.c
@@ -208,6 +208,7 @@ static int rcar_usb_phy_remove(struct platform_device *pdev)
 static struct platform_driver rcar_usb_phy_driver = {
 	.driver		= {
 		.name	= "rcar_usb_phy",
+		.owner	= THIS_MODULE,
 	},
 	.probe		= rcar_usb_phy_probe,
 	.remove		= rcar_usb_phy_remove,
-- 
1.7.1


