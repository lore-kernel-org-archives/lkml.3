Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721Ab3EUCsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 22:48:36 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:32394 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758639Ab3EUCm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 22:42:57 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <akpm@linux-foundation.org>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <lizefan@huawei.com>, <libo.chen@huawei.com>
Subject: [PATCH 10/19] drivers/net/ethernet/freescale: add missing platform_driver owner
Date: Tue, 21 May 2013 10:42:29 +0800
Message-ID: <1369104149-35536-1-git-send-email-libo.chen@huawei.com>
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
 drivers/net/ethernet/freescale/xgmac_mdio.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index 418068b..8ba34fa 100644
--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -262,6 +262,7 @@ MODULE_DEVICE_TABLE(of, xgmac_mdio_match);
 static struct platform_driver xgmac_mdio_driver = {
 	.driver = {
 		.name = "fsl-fman_xmdio",
+		.owner	= THIS_MODULE,
 		.of_match_table = xgmac_mdio_match,
 	},
 	.probe = xgmac_mdio_probe,
-- 
1.7.1


