Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab3KBNsK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 09:48:10 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:44944 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab3KBNsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 09:48:05 -0400
From: Govindarajulu Varadarajan <govindarajulu90@gmail.com>
To: davem@davemloft.net, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
        linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, IvDoorn@gmail.com, sbhatewara@vmware.com,
        samuel@sortiz.org, chas@cmf.nrl.navy.mil, roland@kernel.org,
        isdn@linux-pingi.de, jcliburn@gmail.com, benve@cisco.com,
        ssujith@cisco.com, jeffrey.t.kirsher@intel.com,
        jesse.brandeburg@intel.com, shahed.shaikh@qlogic.com, joe@perches.com,
        apw@canonical.com
Cc: Govindarajulu Varadarajan <govindarajulu90@gmail.com>
Subject: [PATCH net-next 01/13] net: Check skb for NULL in dev_kfree_skb_irq
Date: Sat,  2 Nov 2013 19:17:42 +0530
Message-Id: <1383400074-30555-2-git-send-email-govindarajulu90@gmail.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1383400074-30555-1-git-send-email-govindarajulu90@gmail.com>
References: <1383400074-30555-1-git-send-email-govindarajulu90@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Govindarajulu Varadarajan <govindarajulu90@gmail.com>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 0054c8c..63bd44d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2146,7 +2146,7 @@ EXPORT_SYMBOL(__netif_schedule);
 
 void dev_kfree_skb_irq(struct sk_buff *skb)
 {
-	if (atomic_dec_and_test(&skb->users)) {
+	if (skb && atomic_dec_and_test(&skb->users)) {
 		struct softnet_data *sd;
 		unsigned long flags;
 
-- 
1.8.4.2

