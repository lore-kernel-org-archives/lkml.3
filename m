Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbaAOCmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 21:42:43 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:36496 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbaAOCmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 21:42:33 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s0F2gRis019195, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <oliver@neukum.org>, <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next v2 2/3] r8152: fix the warnings and a error from checkpatch.pl
Date: Wed, 15 Jan 2014 10:42:15 +0800
Message-ID: <1389753736-2218-3-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389753736-2218-1-git-send-email-hayeswang@realtek.com>
References: <1389250232-8663-1-git-send-email-hayeswang@realtek.com>
 <1389753736-2218-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following warnings and error:
 - WARNING: usb_free_urb(NULL) is safe this check is probably not required
 - WARNING: kfree(NULL) is safe this check is probably not required
 - ERROR: do not use C99 // comments

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 42 +++++++++++++++---------------------------
 1 file changed, 15 insertions(+), 27 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 38f3c14..eab078b 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1100,40 +1100,28 @@ static void free_all_mem(struct r8152 *tp)
 	int i;
 
 	for (i = 0; i < RTL8152_MAX_RX; i++) {
-		if (tp->rx_info[i].urb) {
-			usb_free_urb(tp->rx_info[i].urb);
-			tp->rx_info[i].urb = NULL;
-		}
+		usb_free_urb(tp->rx_info[i].urb);
+		tp->rx_info[i].urb = NULL;
 
-		if (tp->rx_info[i].buffer) {
-			kfree(tp->rx_info[i].buffer);
-			tp->rx_info[i].buffer = NULL;
-			tp->rx_info[i].head = NULL;
-		}
+		kfree(tp->rx_info[i].buffer);
+		tp->rx_info[i].buffer = NULL;
+		tp->rx_info[i].head = NULL;
 	}
 
 	for (i = 0; i < RTL8152_MAX_TX; i++) {
-		if (tp->tx_info[i].urb) {
-			usb_free_urb(tp->tx_info[i].urb);
-			tp->tx_info[i].urb = NULL;
-		}
+		usb_free_urb(tp->tx_info[i].urb);
+		tp->tx_info[i].urb = NULL;
 
-		if (tp->tx_info[i].buffer) {
-			kfree(tp->tx_info[i].buffer);
-			tp->tx_info[i].buffer = NULL;
-			tp->tx_info[i].head = NULL;
-		}
+		kfree(tp->tx_info[i].buffer);
+		tp->tx_info[i].buffer = NULL;
+		tp->tx_info[i].head = NULL;
 	}
 
-	if (tp->intr_urb) {
-		usb_free_urb(tp->intr_urb);
-		tp->intr_urb = NULL;
-	}
+	usb_free_urb(tp->intr_urb);
+	tp->intr_urb = NULL;
 
-	if (tp->intr_buff) {
-		kfree(tp->intr_buff);
-		tp->intr_buff = NULL;
-	}
+	kfree(tp->intr_buff);
+	tp->intr_buff = NULL;
 }
 
 static int alloc_all_mem(struct r8152 *tp)
@@ -2048,7 +2036,7 @@ static void r8153_first_init(struct r8152 *tp)
 	/* TX share fifo free credit full threshold */
 	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_TXFIFO_CTRL, TXFIFO_THR_NORMAL2);
 
-	// rx aggregation
+	/* rx aggregation */
 	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_USB_CTRL);
 	ocp_data &= ~RX_AGG_DISABLE;
 	ocp_write_word(tp, MCU_TYPE_USB, USB_USB_CTRL, ocp_data);
-- 
1.8.4.2

