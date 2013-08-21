Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab3HUHCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 03:02:51 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:39316 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab3HUHCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 03:02:38 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <davem@davemloft.net>
CC: <leoli@freescale.com>, <netdev@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <lizefan@huawei.com>, <libo.chen@huawei.com>
Subject: [PATCH 2/8] net: ucc_geth: remove unnecessary dev_set_drvdata()
Date: Wed, 21 Aug 2013 15:02:18 +0800
Message-ID: <1377068538-22432-1-git-send-email-libo.chen@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unnecessary dev_set_drvdata() is removed, because the driver core
clears the driver data to NULL after device_release or on probe failure.

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/net/ethernet/freescale/ucc_geth.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index 533885c..5930c39 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -3917,7 +3917,6 @@ static int ucc_geth_remove(struct platform_device* ofdev)
 	unregister_netdev(dev);
 	free_netdev(dev);
 	ucc_geth_memclean(ugeth);
-	dev_set_drvdata(device, NULL);
 
 	return 0;
 }
-- 
1.7.1


