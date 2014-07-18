Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965099AbaGRNCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:02:43 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17185 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758618AbaGRNCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:02:41 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Marcin Kraglak <marcin.kraglak@tieto.com>,
        Marcel Holtmann <marcel@holtmann.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 091/170] Bluetooth: Allow change security level on ATT_CID in slave role
Date: Fri, 18 Jul 2014 14:11:36 +0200
Message-Id: <350c598f19fa0b7ffd149924e1aeeade1998e234.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcin Kraglak <marcin.kraglak@tieto.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 92d1372e1a9fec00e146b74e8b9ad7a385b9b37f upstream.

Kernel supports SMP Security Request so don't block increasing security
when we are slave.

Signed-off-by: Marcin Kraglak <marcin.kraglak@tieto.com>
Acked-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/bluetooth/l2cap_sock.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 07c9aea21244..a3a81d96314b 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -631,11 +631,6 @@ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
 
 		/*change security for LE channels */
 		if (chan->scid == L2CAP_CID_ATT) {
-			if (!conn->hcon->out) {
-				err = -EINVAL;
-				break;
-			}
-
 			if (smp_conn_security(conn->hcon, sec.level))
 				break;
 			sk->sk_state = BT_CONFIG;
-- 
2.0.0

