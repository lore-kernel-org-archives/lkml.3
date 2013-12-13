Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138Ab3LMIGe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 03:06:34 -0500
Received: from smtpsalv.cc.upv.es ([158.42.249.11]:60669 "EHLO smtpsalv.upv.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461Ab3LMIGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 03:06:32 -0500
X-Greylist: delayed 1205 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Dec 2013 03:06:32 EST
From: =?UTF-8?q?Salva=20Peir=C3=B3?= <speiro@ai2.upv.es>
To: linux-kernel@vger.kernel.org
Cc: <security@kernel.org>, <linux-hams@vger.kernel.org>,
        <netdev@vger.kernel.org>, Jean-Paul Roubelat <jpr@f6fbb.org>,
        =?UTF-8?q?Salva=20Peir=C3=B3?= <speiro@ai2.upv.es>,
        <stable@vger.kernel.org>
Subject: =?UTF-8?q?=5BPATCH=5D=20hamradio/yam=3A=20fix=20info=20leak=20in=20ioctl?=
Date: Fri, 13 Dec 2013 08:46:07 +0100
Message-Id: <1386920767-27962-1-git-send-email-speiro@ai2.upv.es>
X-Mailer: git-send-email 1.7.10.4
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
index 1971411..bb02c8a 100644
--- a/drivers/net/hamradio/yam.c
+++ b/drivers/net/hamradio/yam.c
@@ -953,6 +953,7 @@ static int yam_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	struct yamdrv_ioctl_mcs *ym;
 	int ioctl_cmd;
 
+	memset(&yi, 0, sizeof(yi));
 	if (copy_from_user(&ioctl_cmd, ifr->ifr_data, sizeof(int)))
 		 return -EFAULT;
 
-- 
1.7.10.4

