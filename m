Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbaDRJa6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:30:58 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:46005 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752369AbaDRJWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:49 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Vlad Yasevich <vyasevic@redhat.com>,
        Nithin Nayak Sujir <nsujir@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 57/72] tg3: Do not include vlan acceleration features in vlan_features
Date: Fri, 18 Apr 2014 11:22:30 +0200
Message-Id: <3552f3fcb4da06e0129eb4a66c31ad410ecbb9e4.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vlad Yasevich <vyasevic@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 51dfe7b944998eaeb2b34d314f3a6b16a5fd621b ]

Including hardware acceleration features in vlan_features breaks
stacked vlans (Q-in-Q) by marking the bottom vlan interface as
capable of acceleration.  This causes one of the tags to be lost
and the packets are sent with a sing vlan header.

CC: Nithin Nayak Sujir <nsujir@broadcom.com>
CC: Michael Chan <mchan@broadcom.com>
Signed-off-by: Vlad Yasevich <vyasevic@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ethernet/broadcom/tg3.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 14a50a11d72e..aae7ba66e7bb 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -17480,8 +17480,6 @@ static int tg3_init_one(struct pci_dev *pdev,
 
 	tg3_init_bufmgr_config(tp);
 
-	features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
-
 	/* 5700 B0 chips do not support checksumming correctly due
 	 * to hardware bugs.
 	 */
@@ -17513,7 +17511,8 @@ static int tg3_init_one(struct pci_dev *pdev,
 			features |= NETIF_F_TSO_ECN;
 	}
 
-	dev->features |= features;
+	dev->features |= features | NETIF_F_HW_VLAN_CTAG_TX |
+			 NETIF_F_HW_VLAN_CTAG_RX;
 	dev->vlan_features |= features;
 
 	/*
-- 
1.9.2

