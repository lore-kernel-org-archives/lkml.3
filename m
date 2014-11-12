Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbaKLLLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 06:11:54 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:39296 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751359AbaKLLLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 06:11:52 -0500
From: Jisheng Zhang <jszhang@marvell.com>
To: <davem@davemloft.net>, <antoine.tenart@free-electrons.com>,
        <arnd@arndb.de>, <sebastian.hesselbarth@gmail.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Jisheng Zhang <jszhang@marvell.com>
Subject: [PATCH] net: pxa168_eth: move SET_NETDEV_DEV a bit earlier
Date: Wed, 12 Nov 2014 19:08:47 +0800
Message-ID: <1415790527-6494-1-git-send-email-jszhang@marvell.com>
X-Mailer: git-send-email 2.1.3
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.28,0.0.0000
 definitions=2014-11-12_05:2014-11-11,2014-11-12,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=2
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1411120088
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is to ensure the net_device's dev.parent is set before we used it
in dma_zalloc_coherent() from init_hash_table().

Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
---
 drivers/net/ethernet/marvell/pxa168_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
index 21ddece..38f7cee 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -1540,8 +1540,8 @@ static int pxa168_eth_probe(struct platform_device *pdev)
 	if (err)
 		goto err_free_mdio;
 
-	pxa168_init_hw(pep);
 	SET_NETDEV_DEV(dev, &pdev->dev);
+	pxa168_init_hw(pep);
 	err = register_netdev(dev);
 	if (err)
 		goto err_mdiobus;
-- 
2.1.3

