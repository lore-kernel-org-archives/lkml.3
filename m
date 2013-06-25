Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab3FYTDQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 15:03:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40996 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab3FYSd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:33:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 51/95] 8139cp: reset BQL when ring tx ring cleared
Date: Tue, 25 Jun 2013 11:32:38 -0700
Message-Id: <20130625182159.397184396@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: stephen hemminger <stephen@networkplumber.org>

[ Upstream commit 98962baad72fd6d393bf39dbb7c2076532c363c6 ]

This patch cures transmit timeout's with DHCP observed
while running under KVM. When the transmit ring is cleaned out,
the Byte Queue Limit values need to be reset.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/8139cp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -1136,6 +1136,7 @@ static void cp_clean_rings (struct cp_pr
 			cp->dev->stats.tx_dropped++;
 		}
 	}
+	netdev_reset_queue(cp->dev);
 
 	memset(cp->rx_ring, 0, sizeof(struct cp_desc) * CP_RX_RING_SIZE);
 	memset(cp->tx_ring, 0, sizeof(struct cp_desc) * CP_TX_RING_SIZE);


