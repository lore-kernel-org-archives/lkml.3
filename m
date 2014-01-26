Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbaAZKob (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 05:44:31 -0500
Received: from andre.telenet-ops.be ([195.130.132.53]:39040 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbaAZKoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 05:44:30 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Matthew Whitehead <tedheadster@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] net/apne: Remove unused variable ei_local
Date: Sun, 26 Jan 2014 11:44:23 +0100
Message-Id: <1390733063-9077-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/net/ethernet/8390/apne.c: In function ‘apne_probe1’:
drivers/net/ethernet/8390/apne.c:215: warning: unused variable ‘ei_local’

Introduced by commit c45f812f0280c13f1b7992be5e0de512312a9e8f ("8390 :
Replace ei_debug with msg_enable/NETIF_MSG_* feature"), which added the
variable without using it.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/net/ethernet/8390/apne.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/8390/apne.c b/drivers/net/ethernet/8390/apne.c
index 811fa5d5c697..30104b60da85 100644
--- a/drivers/net/ethernet/8390/apne.c
+++ b/drivers/net/ethernet/8390/apne.c
@@ -212,7 +212,6 @@ static int __init apne_probe1(struct net_device *dev, int ioaddr)
     int neX000, ctron;
 #endif
     static unsigned version_printed;
-    struct ei_device *ei_local = netdev_priv(dev);
 
     if ((apne_msg_enable & NETIF_MSG_DRV) && (version_printed++ == 0))
 		netdev_info(dev, version);
-- 
1.7.9.5

