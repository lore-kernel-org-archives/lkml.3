Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646AbaGXJq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:46:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54651 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758773AbaGXJqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:46:53 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marcin Kraglak <marcin.kraglak@tieto.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 019/128] Bluetooth: Allow change security level on ATT_CID in slave role
Date: Thu, 24 Jul 2014 10:44:28 +0100
Message-Id: <1406195177-8656-20-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcin Kraglak <marcin.kraglak@tieto.com>

commit 92d1372e1a9fec00e146b74e8b9ad7a385b9b37f upstream.

Kernel supports SMP Security Request so don't block increasing security
when we are slave.

Signed-off-by: Marcin Kraglak <marcin.kraglak@tieto.com>
Acked-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
1.9.1

