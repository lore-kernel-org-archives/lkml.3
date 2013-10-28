Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542Ab3J1MAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 08:00:19 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:35709 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755989Ab3J1L6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 07:58:34 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.37 with qID r9SBwWNR016693, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH 2/5] net/usb/r8152: make sure the tx checksum setting is correct
Date: Mon, 28 Oct 2013 19:58:11 +0800
Message-ID: <1382961494-2272-3-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382961494-2272-1-git-send-email-hayeswang@realtek.com>
References: <1382961494-2272-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.218]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clear the checksum setting before checking the necessary of hardware
checksum.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 5dbfe50..815d890 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1094,6 +1094,7 @@ r8152_tx_csum(struct r8152 *tp, struct tx_desc *desc, struct sk_buff *skb)
 	memset(desc, 0, sizeof(*desc));
 
 	desc->opts1 = cpu_to_le32((skb->len & TX_LEN_MASK) | TX_FS | TX_LS);
+	desc->opts2 = 0;
 
 	if (skb->ip_summed == CHECKSUM_PARTIAL) {
 		__be16 protocol;
-- 
1.8.3.1

