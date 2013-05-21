Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927Ab3EUCoY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 22:44:24 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:35842 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758899Ab3EUCoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 22:44:03 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <thomas.petazzoni@free-electrons.com>
CC: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lizefan@huawei.com>,
        <libo.chen@huawei.com>
Subject: [PATCH 18/19] drivers/net/ethernet/marvell: add missing platform_driver owne
Date: Tue, 21 May 2013 10:42:51 +0800
Message-ID: <1369104171-8824-1-git-send-email-libo.chen@huawei.com>
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
 drivers/net/ethernet/marvell/mvneta.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index c966785..be35a3e 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2820,6 +2820,7 @@ static struct platform_driver mvneta_driver = {
 	.remove = mvneta_remove,
 	.driver = {
 		.name = MVNETA_DRIVER_NAME,
+		.owner	= THIS_MODULE,
 		.of_match_table = mvneta_match,
 	},
 };
-- 
1.7.1


