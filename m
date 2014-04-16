Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784AbaDPKcw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:32:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51741 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755441AbaDPKcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:32:48 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nithin Nayak Sujir <nsujir@broadcom.com>,
        Michael Chan <mchan@broadcom.com>, Vlad Yasevich <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 27/46] tg3: Do not include vlan acceleration features in vlan_features
Date: Wed, 16 Apr 2014 11:31:43 +0100
Message-Id: <1397644322-13905-28-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
References: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Yasevich <vyasevic@redhat.com>

commit 51dfe7b944998eaeb2b34d314f3a6b16a5fd621b upstream.

Including hardware acceleration features in vlan_features breaks
stacked vlans (Q-in-Q) by marking the bottom vlan interface as
capable of acceleration.  This causes one of the tags to be lost
and the packets are sent with a sing vlan header.

CC: Nithin Nayak Sujir <nsujir@broadcom.com>
CC: Michael Chan <mchan@broadcom.com>
Signed-off-by: Vlad Yasevich <vyasevic@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/broadcom/tg3.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index c200bc2..17822c5 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -17432,8 +17432,6 @@ static int tg3_init_one(struct pci_dev *pdev,
 
 	tg3_init_bufmgr_config(tp);
 
-	features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
-
 	/* 5700 B0 chips do not support checksumming correctly due
 	 * to hardware bugs.
 	 */
@@ -17465,7 +17463,8 @@ static int tg3_init_one(struct pci_dev *pdev,
 			features |= NETIF_F_TSO_ECN;
 	}
 
-	dev->features |= features;
+	dev->features |= features | NETIF_F_HW_VLAN_CTAG_TX |
+			 NETIF_F_HW_VLAN_CTAG_RX;
 	dev->vlan_features |= features;
 
 	/*
-- 
1.9.1

