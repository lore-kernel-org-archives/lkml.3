Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbaLMWpR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 17:45:17 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60524 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800AbaLMWpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 17:45:15 -0500
Date: Sat, 13 Dec 2014 23:45:13 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
        linux-bluetooth@vger.kernel.org, marcel@holtmann.org
Cc: trivial@kernel.org
Subject: [patch] __uX types should not be neccessary in-kernel
Message-ID: <20141213224513.GA14795@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For in-kernel use, uX types should be enough, no need to use __uX.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/include/net/bluetooth/bluetooth.h b/include/net/bluetooth/bluetooth.h
index 58695ff..a0f0154 100644
--- a/include/net/bluetooth/bluetooth.h
+++ b/include/net/bluetooth/bluetooth.h
@@ -58,8 +58,8 @@
 
 #define BT_SECURITY	4
 struct bt_security {
-	__u8 level;
-	__u8 key_size;
+	u8 level;
+	u8 key_size;
 };
 #define BT_SECURITY_SDP		0
 #define BT_SECURITY_LOW		1
@@ -76,7 +76,7 @@ struct bt_security {
 
 #define BT_POWER	9
 struct bt_power {
-	__u8 force_active;
+	u8 force_active;
 };
 #define BT_POWER_FORCE_ACTIVE_OFF 0
 #define BT_POWER_FORCE_ACTIVE_ON  1
@@ -110,7 +110,7 @@ struct bt_power {
 
 #define BT_VOICE		11
 struct bt_voice {
-	__u16 setting;
+	u16 setting;
 };
 
 #define BT_VOICE_TRANSPARENT			0x0003
@@ -170,7 +170,7 @@ static inline const char *state_to_string(int state)
 
 /* BD Address */
 typedef struct {
-	__u8 b[6];
+	u8 b[6];
 } __packed bdaddr_t;
 
 /* BD Address type */
@@ -178,7 +178,7 @@ typedef struct {
 #define BDADDR_LE_PUBLIC	0x01
 #define BDADDR_LE_RANDOM	0x02
 
-static inline bool bdaddr_type_is_valid(__u8 type)
+static inline bool bdaddr_type_is_valid(u8 type)
 {
 	switch (type) {
 	case BDADDR_BREDR:
@@ -190,7 +190,7 @@ static inline bool bdaddr_type_is_valid(__u8 type)
 	return false;
 }
 
-static inline bool bdaddr_type_is_le(__u8 type)
+static inline bool bdaddr_type_is_le(u8 type)
 {
 	switch (type) {
 	case BDADDR_LE_PUBLIC:
@@ -260,15 +260,15 @@ struct sock *bt_accept_dequeue(struct sock *parent, struct socket *newsock);
 
 /* Skb helpers */
 struct l2cap_ctrl {
-	__u8	sframe:1,
+	u8	sframe:1,
 		poll:1,
 		final:1,
 		fcs:1,
 		sar:2,
 		super:2;
-	__u16	reqseq;
-	__u16	txseq;
-	__u8	retries;
+	u16	reqseq;
+	u16	txseq;
+	u8	retries;
 };
 
 struct hci_dev;
@@ -282,11 +282,11 @@ struct hci_req_ctrl {
 };
 
 struct bt_skb_cb {
-	__u8 pkt_type;
-	__u8 incoming;
-	__u16 opcode;
-	__u16 expect;
-	__u8 force_active;
+	u8 pkt_type;
+	u8 incoming;
+	u16 opcode;
+	u16 expect;
+	u8 force_active;
 	struct l2cap_chan *chan;
 	struct l2cap_ctrl control;
 	struct hci_req_ctrl req;
@@ -337,7 +337,7 @@ out:
 	return NULL;
 }
 
-int bt_to_errno(__u16 code);
+int bt_to_errno(u16 code);
 
 int hci_sock_init(void);
 void hci_sock_cleanup(void);

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
