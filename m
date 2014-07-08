Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbaGHI6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:58:47 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56990 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638AbaGHI5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:57:54 -0400
From: Mugunthan V N <mugunthanvnm@ti.com>
To: <netdev@vger.kernel.org>
CC: <davem@davemloft.net>, <linux-api@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Mugunthan V N <mugunthanvnm@ti.com>
Subject: [net-next PATCH 2/3] drivers: net: cpsw: remove redundancy check
Date: Tue, 8 Jul 2014 14:27:40 +0530
Message-ID: <1404809861-7040-3-git-send-email-mugunthanvnm@ti.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
In-Reply-To: <1404809861-7040-1-git-send-email-mugunthanvnm@ti.com>
References: <1404809861-7040-1-git-send-email-mugunthanvnm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In cpsw_set_coalesce, rx_coalesce_usecs is already checked before
calling this function, so removing redundancy check.

Signed-off-by: Mugunthan V N <mugunthanvnm@ti.com>
---
 drivers/net/ethernet/ti/cpsw.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index b988d16..a6117e6 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -884,9 +884,6 @@ static int cpsw_set_coalesce(struct net_device *ndev,
 	u32 addnl_dvdr = 1;
 	u32 coal_intvl = 0;
 
-	if (!coal->rx_coalesce_usecs)
-		return -EINVAL;
-
 	coal_intvl = coal->rx_coalesce_usecs;
 
 	int_ctrl =  readl(&priv->wr_regs->int_control);
-- 
2.0.0.390.gcb682f8

