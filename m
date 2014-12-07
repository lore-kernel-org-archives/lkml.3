Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbaLGT3L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 14:29:11 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:5006 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753481AbaLGT0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 14:26:52 -0500
X-IronPort-AV: E=Sophos;i="5.07,534,1413237600"; 
   d="scan'208";a="111932941"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Jouni Malinen <j@w1.fi>
Cc: kernel-janitors@vger.kernel.org, linux@rasmusvillemoes.dk, joe@perches.com,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 15/20] hostap_cs: fix misspelling of current function in string
Date: Sun,  7 Dec 2014 20:20:57 +0100
Message-Id: <1417980062-25151-16-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1417980062-25151-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1417980062-25151-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace a misspelled function name by %s and then __func__.

This was done using Coccinelle, including the use of Levenshtein distance,
as proposed by Rasmus Villemoes.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
The semantic patch is difficult to summarize, but is available in the cover
letter of this patch series.

 drivers/net/wireless/hostap/hostap_cs.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_cs.c b/drivers/net/wireless/hostap/hostap_cs.c
index b6ec519..50033aa 100644
--- a/drivers/net/wireless/hostap/hostap_cs.c
+++ b/drivers/net/wireless/hostap/hostap_cs.c
@@ -381,18 +381,15 @@ static void prism2_pccard_genesis_reset(local_info_t *local, int hcr)
 
 	res = pcmcia_read_config_byte(hw_priv->link, CISREG_COR, &old_cor);
 	if (res != 0) {
-		printk(KERN_DEBUG "prism2_pccard_genesis_sreset failed 1 "
-		       "(%d)\n", res);
+		printk(KERN_DEBUG "%s failed 1 (%d)\n", __func__, res);
 		return;
 	}
-	printk(KERN_DEBUG "prism2_pccard_genesis_sreset: original COR %02x\n",
-		old_cor);
+	printk(KERN_DEBUG "%s: original COR %02x\n", __func__, old_cor);
 
 	res = pcmcia_write_config_byte(hw_priv->link, CISREG_COR,
 				old_cor | COR_SOFT_RESET);
 	if (res != 0) {
-		printk(KERN_DEBUG "prism2_pccard_genesis_sreset failed 2 "
-		       "(%d)\n", res);
+		printk(KERN_DEBUG "%s failed 2 (%d)\n", __func__, res);
 		return;
 	}
 
@@ -401,8 +398,7 @@ static void prism2_pccard_genesis_reset(local_info_t *local, int hcr)
 	/* Setup Genesis mode */
 	res = pcmcia_write_config_byte(hw_priv->link, CISREG_CCSR, hcr);
 	if (res != 0) {
-		printk(KERN_DEBUG "prism2_pccard_genesis_sreset failed 3 "
-		       "(%d)\n", res);
+		printk(KERN_DEBUG "%s failed 3 (%d)\n", __func__, res);
 		return;
 	}
 	mdelay(10);
@@ -410,8 +406,7 @@ static void prism2_pccard_genesis_reset(local_info_t *local, int hcr)
 	res = pcmcia_write_config_byte(hw_priv->link, CISREG_COR,
 				old_cor & ~COR_SOFT_RESET);
 	if (res != 0) {
-		printk(KERN_DEBUG "prism2_pccard_genesis_sreset failed 4 "
-		       "(%d)\n", res);
+		printk(KERN_DEBUG "%s failed 4 (%d)\n", __func__, res);
 		return;
 	}
 

