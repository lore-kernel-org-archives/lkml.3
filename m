Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaKPWBf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 17:01:35 -0500
Received: from 1wt.eu ([62.212.114.60]:47988 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbaKPWBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 17:01:33 -0500
Message-Id: <20141116215329.938673493@1wt.eu>
User-Agent: quilt/0.48-1
Date: Sun, 16 Nov 2014 22:53:59 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Zhu Yanjun <Yanjun.Zhu@windriver.com>, Willy Tarreau <w@1wt.eu>
Subject: [ 31/48] gianfar: disable vlan tag insertion by default
In-Reply-To: <28c765bc23bd4bae1611534e510f49f8@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Zhu Yanjun <Yanjun.Zhu@windriver.com>

2.6.x kernels require a similar logic change as commit 51b8cbfc
[gianfar: fix bug caused by e1653c3e] introduces for newer kernels.

Gianfar driver originally enables vlan tag insertion by default.
This will lead to unusable connections on some configurations.

Since gianfar nic vlan tag insertion is disabled by default and
it is not enabled any longer, it is not necessary to disable it
again.

Reported-by: Xu Jianrong <roy.xu@huawei.com>
Suggested-by: Wang Feng <sky.wangfeng@huawei.com>
Signed-off-by: Zhu Yanjun <Yanjun.Zhu@windriver.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/net/gianfar.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/gianfar.c b/drivers/net/gianfar.c
index 8aa2cf6..afdcb41 100644
--- a/drivers/net/gianfar.c
+++ b/drivers/net/gianfar.c
@@ -1115,7 +1115,6 @@ int startup_gfar(struct net_device *dev)
 	/* keep vlan related bits if it's enabled */
 	if (priv->vlgrp) {
 		rctrl |= RCTRL_VLEX | RCTRL_PRSDEP_INIT;
-		tctrl |= TCTRL_VLINS;
 	}
 
 	/* Init rctrl based on our settings */
@@ -1456,11 +1455,6 @@ static void gfar_vlan_rx_register(struct net_device *dev,
 		tempval |= (RCTRL_VLEX | RCTRL_PRSDEP_INIT);
 		gfar_write(&priv->regs->rctrl, tempval);
 	} else {
-		/* Disable VLAN tag insertion */
-		tempval = gfar_read(&priv->regs->tctrl);
-		tempval &= ~TCTRL_VLINS;
-		gfar_write(&priv->regs->tctrl, tempval);
-
 		/* Disable VLAN tag extraction */
 		tempval = gfar_read(&priv->regs->rctrl);
 		tempval &= ~RCTRL_VLEX;
-- 
1.7.12.2.21.g234cd45.dirty



