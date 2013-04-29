Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760010Ab3D2TKc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:10:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60994 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759929Ab3D2TD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:03:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Huang, Xiong" <xiong@qca.qualcomm.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 07/30] atl1e: limit gso segment size to prevent generation of wrong ip length fields
Date: Mon, 29 Apr 2013 12:02:31 -0700
Message-Id: <20130429184356.147563489@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130429184355.299556377@linuxfoundation.org>
References: <20130429184355.299556377@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Hannes Frederic Sowa <hannes@stressinduktion.org>

[ Upstream commit 31d1670e73f4911fe401273a8f576edc9c2b5fea ]

The limit of 0x3c00 is taken from the windows driver.

Suggested-by: Huang, Xiong <xiong@qca.qualcomm.com>
Cc: Huang, Xiong <xiong@qca.qualcomm.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/atl1e/atl1e.h      |    2 +-
 drivers/net/atl1e/atl1e_main.c |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/atl1e/atl1e.h
+++ b/drivers/net/atl1e/atl1e.h
@@ -186,7 +186,7 @@ struct atl1e_tpd_desc {
 /* how about 0x2000 */
 #define MAX_TX_BUF_LEN      0x2000
 #define MAX_TX_BUF_SHIFT    13
-/*#define MAX_TX_BUF_LEN  0x3000 */
+#define MAX_TSO_SEG_SIZE    0x3c00
 
 /* rrs word 1 bit 0:31 */
 #define RRS_RX_CSUM_MASK	0xFFFF
--- a/drivers/net/atl1e/atl1e_main.c
+++ b/drivers/net/atl1e/atl1e_main.c
@@ -2333,6 +2333,7 @@ static int __devinit atl1e_probe(struct
 
 	INIT_WORK(&adapter->reset_task, atl1e_reset_task);
 	INIT_WORK(&adapter->link_chg_task, atl1e_link_chg_task);
+	netif_set_gso_max_size(netdev, MAX_TSO_SEG_SIZE);
 	err = register_netdev(netdev);
 	if (err) {
 		netdev_err(netdev, "register netdevice failed\n");


