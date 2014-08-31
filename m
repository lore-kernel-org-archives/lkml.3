Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751119AbaHaASN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 20:18:13 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:43064 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbaHaASM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 20:18:12 -0400
From: Ramon Fried <ramon.fried@gmail.com>
To: ramon.fried@gmail.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Daniel Borkmann <dborkman@redhat.com>, Alan Cox <alan@linux.intel.com>,
        Wilfried Klaebe <w-lkml@lebenslange-mailadresse.de>,
        Mostyn Bramley-Moore <mbmcode@gmail.com>,
        Toby Smith <toby@tismith.id.au>,
        Archana kumari <archanakumari959@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Himangi Saraogi <himangi774@gmail.com>,
        Iulia Manda <iulia.manda21@gmail.com>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] staging: netlogic: fixed checkpatch.pl styling warnings
Date: Sun, 31 Aug 2014 03:16:48 +0300
Message-Id: <1409444211-758-1-git-send-email-ramon.fried@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl warnings:

WARNING: Possible unnecessary 'out of memory' message
#146: FILE: ./xlr_net.c:146:
+       if (!skb) {
+               pr_err("SKB allocation failed\n");

WARNING: Missing a blank line after declarations
#1107: FILE: ./xlr_net.c:1107:
+       struct xlr_net_priv *priv = platform_get_drvdata(pdev);
+       unregister_netdev(priv->ndev);

Signed-off-by: Ramon Fried <ramon.fried@gmail.com>
---
 drivers/staging/netlogic/xlr_net.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/netlogic/xlr_net.c b/drivers/staging/netlogic/xlr_net.c
index 9bf407d..28a42831 100644
--- a/drivers/staging/netlogic/xlr_net.c
+++ b/drivers/staging/netlogic/xlr_net.c
@@ -142,10 +142,8 @@ static inline struct sk_buff *xlr_alloc_skb(void)
 
 	/* skb->data is cache aligned */
 	skb = alloc_skb(XLR_RX_BUF_SIZE, GFP_ATOMIC);
-	if (!skb) {
-		pr_err("SKB allocation failed\n");
+	if (!skb)
 		return NULL;
-	}
 	mac_put_skb_back_ptr(skb);
 	return skb;
 }
@@ -1104,6 +1102,7 @@ err_gmac:
 static int xlr_net_remove(struct platform_device *pdev)
 {
 	struct xlr_net_priv *priv = platform_get_drvdata(pdev);
+
 	unregister_netdev(priv->ndev);
 	mdiobus_unregister(priv->mii_bus);
 	mdiobus_free(priv->mii_bus);
-- 
1.9.1

