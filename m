Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbaGHANk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:13:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56401 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632AbaGHADQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 20:03:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Syam Sidhardhan <s.syam@samsung.com>,
        Gustavo Padovan <gustavo@padovan.org>
Subject: [PATCH 3.4 17/44] Bluetooth: Remove unused hci_le_ltk_reply()
Date: Mon,  7 Jul 2014 17:07:07 -0700
Message-Id: <20140707235859.172858510@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235858.652771077@linuxfoundation.org>
References: <20140707235858.652771077@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Syam Sidhardhan <s.syam@samsung.com>

commit e10b9969f217c948c5523045f44eba4d3a758ff0 upstream.

In this API, we were using sizeof operator for an array
given as function argument, which is invalid.
However this API is not used anywhere.

Signed-off-by: Syam Sidhardhan <s.syam@samsung.com>
Signed-off-by: Gustavo Padovan <gustavo@padovan.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/bluetooth/hci_core.h |    1 -
 net/bluetooth/hci_conn.c         |   16 ----------------
 2 files changed, 17 deletions(-)

--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1068,7 +1068,6 @@ void hci_le_conn_update(struct hci_conn
 					u16 latency, u16 to_multiplier);
 void hci_le_start_enc(struct hci_conn *conn, __le16 ediv, __u8 rand[8],
 							__u8 ltk[16]);
-void hci_le_ltk_reply(struct hci_conn *conn, u8 ltk[16]);
 void hci_le_ltk_neg_reply(struct hci_conn *conn);
 
 int hci_do_inquiry(struct hci_dev *hdev, u8 length);
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -224,22 +224,6 @@ void hci_le_start_enc(struct hci_conn *c
 }
 EXPORT_SYMBOL(hci_le_start_enc);
 
-void hci_le_ltk_reply(struct hci_conn *conn, u8 ltk[16])
-{
-	struct hci_dev *hdev = conn->hdev;
-	struct hci_cp_le_ltk_reply cp;
-
-	BT_DBG("%p", conn);
-
-	memset(&cp, 0, sizeof(cp));
-
-	cp.handle = cpu_to_le16(conn->handle);
-	memcpy(cp.ltk, ltk, sizeof(ltk));
-
-	hci_send_cmd(hdev, HCI_OP_LE_LTK_REPLY, sizeof(cp), &cp);
-}
-EXPORT_SYMBOL(hci_le_ltk_reply);
-
 void hci_le_ltk_neg_reply(struct hci_conn *conn)
 {
 	struct hci_dev *hdev = conn->hdev;


