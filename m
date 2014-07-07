Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218AbaGHAjE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:39:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55776 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbaGGXyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marcin Kraglak <marcin.kraglak@tieto.com>,
        Johan Hedberg <johan.hedberg@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 3.14 44/94] Bluetooth: Allow change security level on ATT_CID in slave role
Date: Mon,  7 Jul 2014 16:57:34 -0700
Message-Id: <20140707235758.091700301@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235756.780319003@linuxfoundation.org>
References: <20140707235756.780319003@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcin Kraglak <marcin.kraglak@tieto.com>

commit 92d1372e1a9fec00e146b74e8b9ad7a385b9b37f upstream.

Kernel supports SMP Security Request so don't block increasing security
when we are slave.

Signed-off-by: Marcin Kraglak <marcin.kraglak@tieto.com>
Acked-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/l2cap_sock.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -778,11 +778,6 @@ static int l2cap_sock_setsockopt(struct
 
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


