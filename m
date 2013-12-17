Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab3LQJHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 04:07:22 -0500
Received: from smtpsalv.cc.upv.es ([158.42.249.11]:50478 "EHLO smtpsalv.upv.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839Ab3LQJHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 04:07:19 -0500
From: =?UTF-8?q?Salva=20Peir=C3=B3?= <speiro@ai2.upv.es>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Salva=20Peir=C3=B3?= <speiro@ai2.upv.es>, security@kernel.org,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        Jean-Paul Roubelat <jpr@f6fbb.org>, stable@vger.kernel.org
Subject: =?UTF-8?q?=5BPATCH=20v2=5D=20hamradio/yam=3A=20fix=20info=20leak=20in=20ioctl?=
Date: Tue, 17 Dec 2013 10:06:30 +0100
Message-Id: <1387271191-10355-1-git-send-email-speiro@ai2.upv.es>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1386920767-27962-1-git-send-email-speiro@ai2.upv.es>
References: <1386920767-27962-1-git-send-email-speiro@ai2.upv.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The yam_ioctl() code fails to initialise the cmd field
of the struct yamdrv_ioctl_cfg. Add an explicit memset(0)
before filling the structure to avoid the 4-byte info leak.

Signed-off-by: Salva Peiró <speiro@ai2.upv.es>
CC: <stable@vger.kernel.org>
---
 drivers/net/hamradio/yam.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/hamradio/yam.c b/drivers/net/hamradio/yam.c
index 1971411..61dd244 100644
--- a/drivers/net/hamradio/yam.c
+++ b/drivers/net/hamradio/yam.c
@@ -1057,6 +1057,7 @@ static int yam_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		break;
 
 	case SIOCYAMGCFG:
+		memset(&yi, 0, sizeof(yi));
 		yi.cfg.mask = 0xffffffff;
 		yi.cfg.iobase = yp->iobase;
 		yi.cfg.irq = yp->irq;
-- 
1.7.10.4

