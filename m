Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbaJ1NXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 09:23:22 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:64827 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbaJ1NXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 09:23:13 -0400
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Frank Li <Frank.Li@freescale.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCHv3 8/9] net: fec: remove unused return value from swap_buffer()
Date: Tue, 28 Oct 2014 14:23:03 +0100
Message-Id: <1414502584-10583-9-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1414502584-10583-1-git-send-email-LW@KARO-electronics.de>
References: <1414494104-27943-1-git-send-email-LW@KARO-electronics.de>
 <1414502584-10583-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/net/ethernet/freescale/fec_main.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index ddfc57d..e52864c 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -287,7 +287,7 @@ static int fec_enet_get_free_txdesc_num(struct fec_enet_private *fep,
 	return entries > 0 ? entries : entries + txq->tx_ring_size;
 }
 
-static void *swap_buffer(void *bufaddr, int len)
+static void swap_buffer(void *bufaddr, int len)
 {
 	int i;
 	unsigned int *buf = bufaddr;
@@ -295,7 +295,6 @@ static void *swap_buffer(void *bufaddr, int len)
 	for (i = 0; i < len; i += 4, buf++)
 		swab32s(buf);
 
-	return bufaddr;
 }
 
 static void fec_dump(struct net_device *ndev)
-- 
1.7.10.4

