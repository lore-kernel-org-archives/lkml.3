Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab3HPIK5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 04:10:57 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:52623 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab3HPIKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 04:10:44 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.34 with qID r7G8AaMA017142, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <romieu@fr.zoreil.com>, <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 2/7] r8152: replace void * with struct r8152 *
Date: Fri, 16 Aug 2013 16:09:33 +0800
Message-ID: <1376640578-4258-2-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1376640578-4258-1-git-send-email-hayeswang@realtek.com>
References: <1376640578-4258-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the type of contex of tx_agg and rx_agg from void * to
staruc r8152 *.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index c13662b..a18f02d 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -329,10 +329,12 @@ struct tx_desc {
 #define IPV6_CS			(1 << 28) /* Calculate IPv6 checksum */
 };
 
+struct r8152;
+
 struct rx_agg {
 	struct list_head list;
 	struct urb *urb;
-	void *context;
+	struct r8152 *context;
 	void *buffer;
 	void *head;
 };
@@ -340,7 +342,7 @@ struct rx_agg {
 struct tx_agg {
 	struct list_head list;
 	struct urb *urb;
-	void *context;
+	struct r8152 *context;
 	void *buffer;
 	void *head;
 	u32 skb_num;
-- 
1.8.3.1

