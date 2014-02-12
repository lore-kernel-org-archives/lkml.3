Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbaBLIjF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:39:05 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50068 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751797AbaBLINt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:13:49 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "=?UTF-8?q?Salva=20Peir=C3=B3?=" <speiro@ai2.upv.es>,
        "David S. Miller" <davem@davemloft.net>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.775277194@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 09/79] hamradio/yam: fix info leak in ioctl
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Salva Peiró <speiro@ai2.upv.es>

[ Upstream commit 8e3fbf870481eb53b2d3a322d1fc395ad8b367ed ]

The yam_ioctl() code fails to initialise the cmd field
of the struct yamdrv_ioctl_cfg. Add an explicit memset(0)
before filling the structure to avoid the 4-byte info leak.

Signed-off-by: Salva Peiró <speiro@ai2.upv.es>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/hamradio/yam.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/hamradio/yam.c b/drivers/net/hamradio/yam.c
index 96a98d2..e4260ab 100644
--- a/drivers/net/hamradio/yam.c
+++ b/drivers/net/hamradio/yam.c
@@ -1060,6 +1060,7 @@ static int yam_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		break;
 
 	case SIOCYAMGCFG:
+		memset(&yi, 0, sizeof(yi));
 		yi.cfg.mask = 0xffffffff;
 		yi.cfg.iobase = yp->iobase;
 		yi.cfg.irq = yp->irq;

