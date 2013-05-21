Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768Ab3EUCrm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 22:47:42 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:34743 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758622Ab3EUCnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 22:43:08 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <akpm@linux-foundation.org>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <lizefan@huawei.com>, <libo.chen@huawei.com>
Subject: [PATCH 09/19] drivers/net/ethernet: add missing platform_driver owner
Date: Tue, 21 May 2013 10:42:26 +0800
Message-ID: <1369104146-30624-1-git-send-email-libo.chen@huawei.com>
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
 drivers/net/ethernet/dnet.c   |    3 ++-
 drivers/net/ethernet/korina.c |    1 +
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/dnet.c b/drivers/net/ethernet/dnet.c
index f3d60eb..63c26ad 100644
--- a/drivers/net/ethernet/dnet.c
+++ b/drivers/net/ethernet/dnet.c
@@ -970,7 +970,8 @@ static struct platform_driver dnet_driver = {
 	.probe		= dnet_probe,
 	.remove		= dnet_remove,
 	.driver		= {
-		.name		= "dnet",
+		.name	= "dnet",
+		.owner	= THIS_MODULE,
 	},
 };
 
diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
index 5409fe8..c41bcf6 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -1223,6 +1223,7 @@ static int korina_remove(struct platform_device *pdev)
 
 static struct platform_driver korina_driver = {
 	.driver.name = "korina",
+	.driver.owner = THIS_MODULE,
 	.probe = korina_probe,
 	.remove = korina_remove,
 };
-- 
1.7.1


