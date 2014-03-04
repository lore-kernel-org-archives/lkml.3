Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbaCDMBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 07:01:55 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:36554 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757243AbaCDMBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 07:01:54 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s24C1pJX025520, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 05/12] r8152: check tx agg list before spin lock
Date: Tue, 4 Mar 2014 20:00:57 +0800
Message-ID: <1393934464-23675-6-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1393934464-23675-1-git-send-email-hayeswang@realtek.com>
References: <1393934464-23675-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.77]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check tx agg list before spin lock to avoid doing spin lock every
times.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 8ecb41b..00b3192 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1266,6 +1266,9 @@ static struct tx_agg *r8152_get_tx_agg(struct r8152 *tp)
 	struct tx_agg *agg = NULL;
 	unsigned long flags;
 
+	if (list_empty(&tp->tx_free))
+		return NULL;
+
 	spin_lock_irqsave(&tp->tx_lock, flags);
 	if (!list_empty(&tp->tx_free)) {
 		struct list_head *cursor;
-- 
1.8.4.2

