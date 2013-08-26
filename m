Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733Ab3HZDbd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 23:31:33 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:50351 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794Ab3HZDbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 23:31:32 -0400
Message-ID: <521ACBEF.7020301@huawei.com>
Date: Mon, 26 Aug 2013 11:30:55 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>, <anirudh@xilinx.com>,
        <John.Linn@xilinx.com>
CC: <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: [PATCH] net: xilinx: fix memleak
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 decrease device_node refcount np1 in err case.

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
index e90e1f4..64b4639 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
@@ -175,6 +175,7 @@ int axienet_mdio_setup(struct axienet_local *lp, struct device_node *np)
 		printk(KERN_WARNING "Setting MDIO clock divisor to "
 		       "default %d\n", DEFAULT_CLOCK_DIVISOR);
 		clk_div = DEFAULT_CLOCK_DIVISOR;
+		of_node_put(np1);
 		goto issue;
 	}

-- 
1.7.1

