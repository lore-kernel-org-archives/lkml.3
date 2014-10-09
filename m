Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624AbaJIPFn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 11:05:43 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:61397 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757609AbaJIPFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 11:05:37 -0400
From: John Ledbetter <john@throttle.io>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        John Ledbetter <john@throttle.io>
Subject: [PATCH] staging: rtl8192e: Fix pointer type declaration style errors
Date: Thu,  9 Oct 2014 11:05:08 -0400
Message-Id: <1412867108-10200-1-git-send-email-john@throttle.io>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following checkpatch.pl errors:

drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c:1290 error: "foo* bar"
should be "foo *bar"

drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c:1305 error: "foo * bar"
should be "foo *bar"

Signed-off-by: John Ledbetter <john@throttle.io>
---
 drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c
index 0ffed2d..552d943 100644
--- a/drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c
+++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c
@@ -1287,7 +1287,7 @@ void  rtl8192_tx_fill_desc(struct net_device *dev, struct tx_desc *pdesc,
 
 void  rtl8192_tx_fill_cmd_desc(struct net_device *dev,
 			       struct tx_desc_cmd *entry,
-			       struct cb_desc *cb_desc, struct sk_buff* skb)
+			       struct cb_desc *cb_desc, struct sk_buff *skb)
 {
 	struct r8192_priv *priv = rtllib_priv(dev);
 	dma_addr_t mapping = pci_map_single(priv->pdev, skb->data, skb->len,
@@ -1302,7 +1302,7 @@ void  rtl8192_tx_fill_cmd_desc(struct net_device *dev,
 	if (cb_desc->bCmdOrInit == DESC_PACKET_TYPE_INIT) {
 		entry->CmdInit = DESC_PACKET_TYPE_INIT;
 	} else {
-		struct tx_desc * entry_tmp = (struct tx_desc *)entry;
+		struct tx_desc *entry_tmp = (struct tx_desc *)entry;
 
 		entry_tmp->CmdInit = DESC_PACKET_TYPE_NORMAL;
 		entry_tmp->Offset = sizeof(struct tx_fwinfo_8190pci) + 8;
-- 
2.1.2

