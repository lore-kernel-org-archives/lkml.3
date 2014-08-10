Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426AbaHJHex (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 03:34:53 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51121 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaHJHev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 03:34:51 -0400
Date: Sun, 10 Aug 2014 09:34:50 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Trivial patch monkey <trivial@kernel.org>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Miguel Oliveira <cmroliv@gmail.com>, gulsah.1004@gmail.com,
        peter.p.waskiewicz.jr@intel.com, kristina.martsenko@gmail.com,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] bluetooth: avoid using __uX types
Message-ID: <20140810073450.GD19735@amd.pavel.ucw.cz>
References: <1401445633-5290-1-git-send-email-cmroliv@gmail.com>
 <20140530123023.GA10549@amd.pavel.ucw.cz>
 <20140530155959.GA10682@kroah.com>
 <201405301815.10811@pali>
 <20140530163604.GA11943@kroah.com>
 <DB71A450-EF1D-479F-9111-A36FF8EA89B2@holtmann.org>
 <20140806213055.GA26046@amd.pavel.ucw.cz>
 <20140807002532.GB23406@kroah.com>
 <20140807081328.GB24700@amd.pavel.ucw.cz>
 <20140807202407.GC6060@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140807202407.GC6060@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


__u8/16 types should not be neccessary inside kernel, u8/16 should
be enough.
    
Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/include/net/bluetooth/bluetooth.h b/include/net/bluetooth/bluetooth.h
index 373000d..1176e67 100644
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
@@ -282,10 +282,10 @@ struct hci_req_ctrl {
 };
 
 struct bt_skb_cb {
-	__u8 pkt_type;
-	__u8 incoming;
-	__u16 expect;
-	__u8 force_active;
+	u8 pkt_type;
+	u8 incoming;
+	u16 expect;
+	u8 force_active;
 	struct l2cap_chan *chan;
 	struct l2cap_ctrl control;
 	struct hci_req_ctrl req;
@@ -336,7 +336,7 @@ out:
 	return NULL;
 }
 
-int bt_to_errno(__u16 code);
+int bt_to_errno(u16 code);
 
 int hci_sock_init(void);
 void hci_sock_cleanup(void);
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
