Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112Ab3GBLSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 07:18:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36185 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730Ab3GBLIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 07:08:04 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 11/50] 8139cp: reset BQL when ring tx ring cleared
Date: Tue,  2 Jul 2013 12:06:59 +0100
Message-Id: <1372763258-20664-12-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
References: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: stephen hemminger <stephen@networkplumber.org>

commit 98962baad72fd6d393bf39dbb7c2076532c363c6 upstream.

This patch cures transmit timeout's with DHCP observed
while running under KVM. When the transmit ring is cleaned out,
the Byte Queue Limit values need to be reset.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/realtek/8139cp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index e0490ad..d9ef667 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -1116,6 +1116,7 @@ static void cp_clean_rings (struct cp_private *cp)
 			cp->dev->stats.tx_dropped++;
 		}
 	}
+	netdev_reset_queue(cp->dev);
 
 	memset(cp->rx_ring, 0, sizeof(struct cp_desc) * CP_RX_RING_SIZE);
 	memset(cp->tx_ring, 0, sizeof(struct cp_desc) * CP_TX_RING_SIZE);
-- 
1.8.1.2

