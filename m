Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750964AbaJYSTf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 14:19:35 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:31053 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750738AbaJYSTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 14:19:34 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao4QAJdjS1RbtAGh/2dsb2JhbABcgw6BLLlICwUBdJo/gQkXAX2EMC8jgRo3iEUBunaOXCyGJYozHYQ1BZ1djGiJRIFHAYIyOy+CSwEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH V2 net-next] Bluetooth: fix shadow warning in hci_disconnect()
Date: Sat, 25 Oct 2014 10:48:58 +0200
Message-Id: <1414226938-7478-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use clkoff_cp for hci_cp_read_clock_offset instead of cp
(already defined above).

Suggested-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
V2: use clkoff_cp instead of cpr (suggested by Marcel Holtmann)

 net/bluetooth/hci_conn.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index b9517bd..62f4ac6 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -141,10 +141,11 @@ int hci_disconnect(struct hci_conn *conn, __u8 reason)
 	 */
 	if (conn->type == ACL_LINK && conn->role == HCI_ROLE_MASTER) {
 		struct hci_dev *hdev = conn->hdev;
-		struct hci_cp_read_clock_offset cp;
+		struct hci_cp_read_clock_offset clkoff_cp;
 
-		cp.handle = cpu_to_le16(conn->handle);
-		hci_send_cmd(hdev, HCI_OP_READ_CLOCK_OFFSET, sizeof(cp), &cp);
+		clkoff_cp.handle = cpu_to_le16(conn->handle);
+		hci_send_cmd(hdev, HCI_OP_READ_CLOCK_OFFSET, sizeof(clkoff_cp),
+			     &clkoff_cp);
 	}
 
 	conn->state = BT_DISCONN;
-- 
1.9.3

