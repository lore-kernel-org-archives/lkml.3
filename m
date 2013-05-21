Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758896Ab3EUCoC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 22:44:02 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:35655 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758824Ab3EUCn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 22:43:59 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <akpm@linux-foundation.org>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lizefan@huawei.com>, <davem@davemloft.net>, <libo.chen@huawei.com>
Subject: [PATCH 13/19] drivers/net/ethernet/calxeda: add missing platform_driver owner
Date: Tue, 21 May 2013 10:42:37 +0800
Message-ID: <1369104157-13912-1-git-send-email-libo.chen@huawei.com>
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
 drivers/net/ethernet/calxeda/xgmac.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
index 4a1f2fa..493f618 100644
--- a/drivers/net/ethernet/calxeda/xgmac.c
+++ b/drivers/net/ethernet/calxeda/xgmac.c
@@ -1899,6 +1899,7 @@ MODULE_DEVICE_TABLE(of, xgmac_of_match);
 static struct platform_driver xgmac_driver = {
 	.driver = {
 		.name = "calxedaxgmac",
+		.owner = THIS_MODULE,
 		.of_match_table = xgmac_of_match,
 	},
 	.probe = xgmac_probe,
-- 
1.7.1


