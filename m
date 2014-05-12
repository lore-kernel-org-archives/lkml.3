Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbaELBnT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:43:19 -0400
Received: from 1wt.eu ([62.212.114.60]:34697 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875AbaELBnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:43:13 -0400
Message-Id: <20140512003204.546049873@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:33:34 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: =?ISO-8859-15?q?Salva=20Peir=F3?= <speiro@ai2.upv.es>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 094/143] hamradio/yam: fix info leak in ioctl
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: =?latin1?q?Salva=20Peir=F3?= <speiro@ai2.upv.es>

[ Upstream commit 8e3fbf870481eb53b2d3a322d1fc395ad8b367ed ]

The yam_ioctl() code fails to initialise the cmd field
of the struct yamdrv_ioctl_cfg. Add an explicit memset(0)
before filling the structure to avoid the 4-byte info leak.

Signed-off-by: Salva Peiró <speiro@ai2.upv.es>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/net/hamradio/yam.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/hamradio/yam.c b/drivers/net/hamradio/yam.c
index 694132e..1a1002d 100644
--- a/drivers/net/hamradio/yam.c
+++ b/drivers/net/hamradio/yam.c
@@ -1060,6 +1060,7 @@ static int yam_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		break;
 
 	case SIOCYAMGCFG:
+		memset(&yi, 0, sizeof(yi));
 		yi.cfg.mask = 0xffffffff;
 		yi.cfg.iobase = yp->iobase;
 		yi.cfg.irq = yp->irq;
-- 
1.7.12.2.21.g234cd45.dirty



