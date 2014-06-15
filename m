Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588AbaFOPNS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 11:13:18 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:54889 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbaFOPNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 11:13:11 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Ana Rey <anarey@gmail.com>, Andrea Merello <andrea.merello@gmail.com>,
        Teodora Baluta <teobaluta@gmail.com>, Chi Pham <fempsci@gmail.com>,
        Himangi Saraogi <himangi774@gmail.com>,
        Xenia Ragiadakou <burzalodowa@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8192u: r8192U_core.c:  Cleaning up unclear and confusing code
Date: Sun, 15 Jun 2014 17:14:06 +0200
Message-Id: <1402845246-28125-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402845246-28125-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1402845246-28125-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes confusing and unclear code.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/rtl8192u/r8192U_core.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 1bb6143..fd8f37f 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -1245,12 +1245,11 @@ u8 DrvAggr_GetAggregatibleList(struct net_device *dev, struct sk_buff *skb,
 static void rtl8192_tx_isr(struct urb *tx_urb)
 {
 	struct sk_buff *skb = (struct sk_buff *)tx_urb->context;
-	struct net_device *dev = NULL;
+	struct net_device *dev = (struct net_device *)(skb->cb);
 	struct r8192_priv *priv = NULL;
 	cb_desc *tcb_desc = (cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
 	u8  queue_index = tcb_desc->queue_index;
 
-	memcpy(&dev, (struct net_device *)(skb->cb), sizeof(struct net_device *));
 	priv = ieee80211_priv(dev);
 
 	if (tcb_desc->queue_index != TXCMD_QUEUE) {
@@ -1408,7 +1407,7 @@ static void rtl8192_net_update(struct net_device *dev)
 	net = &priv->ieee80211->current_network;
 
 	rtl8192_config_rate(dev, &rate_config);
-	priv->basic_rate = rate_config &= 0x15f;
+	priv->basic_rate = rate_config & 0x15f;
 
 	write_nic_dword(dev, BSSIDR, ((u32 *)net->bssid)[0]);
 	write_nic_word(dev, BSSIDR+4, ((u16 *)net->bssid)[2]);
-- 
1.7.10.4

