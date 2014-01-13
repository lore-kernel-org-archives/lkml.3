Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbaAMO2z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:28:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51604 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290AbaAMO1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:27:07 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Salva=20Peir=C3=B3?= <speiro@ai2.upv.es>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 88/96] hamradio/yam: fix info leak in ioctl
Date: Mon, 13 Jan 2014 14:24:51 +0000
Message-Id: <1389623099-18783-89-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Salva=20Peir=C3=B3?= <speiro@ai2.upv.es>

commit 8e3fbf870481eb53b2d3a322d1fc395ad8b367ed upstream.

The yam_ioctl() code fails to initialise the cmd field
of the struct yamdrv_ioctl_cfg. Add an explicit memset(0)
before filling the structure to avoid the 4-byte info leak.

Signed-off-by: Salva Peiró <speiro@ai2.upv.es>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/hamradio/yam.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/hamradio/yam.c b/drivers/net/hamradio/yam.c
index 5a6412e..d8faeb6 100644
--- a/drivers/net/hamradio/yam.c
+++ b/drivers/net/hamradio/yam.c
@@ -1058,6 +1058,7 @@ static int yam_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		break;
 
 	case SIOCYAMGCFG:
+		memset(&yi, 0, sizeof(yi));
 		yi.cfg.mask = 0xffffffff;
 		yi.cfg.iobase = yp->iobase;
 		yi.cfg.irq = yp->irq;
-- 
1.8.3.2

