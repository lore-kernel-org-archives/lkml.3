Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbaFPPBP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 11:01:15 -0400
Received: from mx-rz-1.rrze.uni-erlangen.de ([131.188.11.20]:43392 "EHLO
	mx-rz-1.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754318AbaFPO65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 10:58:57 -0400
X-RRZE-Submit-IP: 131.188.42.190
From: Stephan Gabert <stephan.gabert@fau.de>
To: pe1dnn@amsat.org, gregkh@linuxfoundation.org
Cc: nicolas.pfeiffer@fau.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-kernel@i4.cs.fau.de,
        Stephan Gabert <stephan.gabert@fau.de>
Subject: [PATCH 4/5] staging/wlags49_h2: convert printk calls to netdev_* calls
Date: Mon, 16 Jun 2014 16:50:52 +0200
Message-Id: <1402930253-32537-5-git-send-email-stephan.gabert@fau.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402930253-32537-1-git-send-email-stephan.gabert@fau.de>
References: <1402930253-32537-1-git-send-email-stephan.gabert@fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use netdev_* where applicable.

Signed-off-by: Stephan Gabert <stephan.gabert@fau.de>
Signed-off-by: Nicolas Pfeiffer <nicolas.pfeiffer@fau.de>
---
 drivers/staging/wlags49_h2/wl_cs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_cs.c b/drivers/staging/wlags49_h2/wl_cs.c
index 764f547..e658000 100644
--- a/drivers/staging/wlags49_h2/wl_cs.c
+++ b/drivers/staging/wlags49_h2/wl_cs.c
@@ -233,12 +233,12 @@ int wl_adapter_insert(struct pcmcia_device *link)
 	SET_NETDEV_DEV(dev, &link->dev);
 	ret = register_netdev(dev);
 	if (ret < 0) {
-		printk("%s: register_netdev() failed\n", KBUILD_MODNAME);
+		netdev_err(dev, "register_netdev() failed\n");
 		goto failed;
 	}
 
-	printk(KERN_INFO "%s: Wireless, io_addr %#03lx, irq %d, mac_address"
-		" %pM\n", dev->name, dev->base_addr, dev->irq, dev->dev_addr);
+	netdev_info(dev, "io_addr %#03lx, irq %d, mac_address %pM\n",
+			dev->base_addr, dev->irq, dev->dev_addr);
 
 	return 0;
 
-- 
1.9.1

