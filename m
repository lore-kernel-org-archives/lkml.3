Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795Ab3EUCn2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 22:43:28 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:34912 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758602Ab3EUCnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 22:43:25 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <khc@pm.waw.pl>
CC: <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <lizefan@huawei.com>,
        <libo.chen@huawei.com>
Subject: [PATCH 16/19] drivers/net/wan: add missing platform_driver owner
Date: Tue, 21 May 2013 10:42:45 +0800
Message-ID: <1369104165-27484-1-git-send-email-libo.chen@huawei.com>
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
 drivers/net/wan/ixp4xx_hss.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wan/ixp4xx_hss.c b/drivers/net/wan/ixp4xx_hss.c
index fc9d11d..db2d775 100644
--- a/drivers/net/wan/ixp4xx_hss.c
+++ b/drivers/net/wan/ixp4xx_hss.c
@@ -1391,6 +1391,7 @@ static int hss_remove_one(struct platform_device *pdev)
 
 static struct platform_driver ixp4xx_hss_driver = {
 	.driver.name	= DRV_NAME,
+	.driver.owner	= THIS_MODULE,
 	.probe		= hss_init_one,
 	.remove		= hss_remove_one,
 };
-- 
1.7.1


