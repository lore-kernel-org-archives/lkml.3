Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759441AbaDKQeO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:34:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56680 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422854AbaDKQJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:09:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nithin Nayak Sujir <nsujir@broadcom.com>,
        Michael Chan <mchan@broadcom.com>, Vlad Yasevich <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 42/65] tg3: Do not include vlan acceleration features in vlan_features
Date: Fri, 11 Apr 2014 09:11:14 -0700
Message-Id: <20140411161003.494831171@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140411160957.714773410@linuxfoundation.org>
References: <20140411160957.714773410@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Yasevich <vyasevic@redhat.com>

[ Upstream commit 51dfe7b944998eaeb2b34d314f3a6b16a5fd621b ]

Including hardware acceleration features in vlan_features breaks
stacked vlans (Q-in-Q) by marking the bottom vlan interface as
capable of acceleration.  This causes one of the tags to be lost
and the packets are sent with a sing vlan header.

CC: Nithin Nayak Sujir <nsujir@broadcom.com>
CC: Michael Chan <mchan@broadcom.com>
Signed-off-by: Vlad Yasevich <vyasevic@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/tg3.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -17485,8 +17485,6 @@ static int tg3_init_one(struct pci_dev *
 
 	tg3_init_bufmgr_config(tp);
 
-	features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
-
 	/* 5700 B0 chips do not support checksumming correctly due
 	 * to hardware bugs.
 	 */
@@ -17518,7 +17516,8 @@ static int tg3_init_one(struct pci_dev *
 			features |= NETIF_F_TSO_ECN;
 	}
 
-	dev->features |= features;
+	dev->features |= features | NETIF_F_HW_VLAN_CTAG_TX |
+			 NETIF_F_HW_VLAN_CTAG_RX;
 	dev->vlan_features |= features;
 
 	/*


