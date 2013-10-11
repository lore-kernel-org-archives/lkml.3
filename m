Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933062Ab3JKUMD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:12:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46118 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932403Ab3JKTlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:41:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Antonio Quartulli <antonio@open-mesh.org>,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
        Marek Lindner <mareklindner@neomailbox.ch>
Subject: [ 030/135] batman-adv: set the TAG flag for the vid passed to BLA
Date: Fri, 11 Oct 2013 12:38:31 -0700
Message-Id: <20131011193948.500218367@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antonio Quartulli <antonio@open-mesh.com>

[ Upstream commit 4c18c425b2d228415b635e97a64737d7f27c5536 ]

When receiving or sending a packet a packet on a VLAN, the
vid has to be marked with the TAG flag in order to make any
component in batman-adv understand that the packet is coming
from a really tagged network.

This fix the Bridge Loop Avoidance behaviour which was not
able to send announces over VLAN interfaces.

Introduced by 0b1da1765fdb00ca5d53bc95c9abc70dfc9aae5b
("batman-adv: change VID semantic in the BLA code")

Signed-off-by: Antonio Quartulli <antonio@open-mesh.org>
Acked-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/soft-interface.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -168,6 +168,7 @@ static int batadv_interface_tx(struct sk
 	case ETH_P_8021Q:
 		vhdr = (struct vlan_ethhdr *)skb->data;
 		vid = ntohs(vhdr->h_vlan_TCI) & VLAN_VID_MASK;
+		vid |= BATADV_VLAN_HAS_TAG;
 
 		if (vhdr->h_vlan_encapsulated_proto != ethertype)
 			break;
@@ -329,6 +330,7 @@ void batadv_interface_rx(struct net_devi
 	case ETH_P_8021Q:
 		vhdr = (struct vlan_ethhdr *)skb->data;
 		vid = ntohs(vhdr->h_vlan_TCI) & VLAN_VID_MASK;
+		vid |= BATADV_VLAN_HAS_TAG;
 
 		if (vhdr->h_vlan_encapsulated_proto != ethertype)
 			break;


