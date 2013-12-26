Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab3LZTX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 14:23:59 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:50292 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753651Ab3LZTX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 14:23:58 -0500
From: Matthias Schoepe <matthias.schoepe@studium.uni-erlangen.de>
To: devel@driverdev.osuosl.org
Cc: andreas.frembs@studium.uni-erlangen.de, linux-kernel@i4.cs.fau.de,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Matthias Schoepe <matthias.schoepe@studium.uni-erlangen.de>
Subject: [PATCH] Staging rtl8192e: Fixing checkpatch errors
Date: Thu, 26 Dec 2013 20:23:32 +0100
Message-Id: <1388085812-3914-1-git-send-email-matthias.schoepe@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We fixed checkpatch errors of the following type:
	ERROR: "foo * bar" should be "foo *bar"

The error was fixed in the following files of the rtl8192e staging driver:
	rtllib_softmac.c
	rtllib_rx.c
	rtllib_crypt.c
	rtllib.h

There are no functional changes in this patch.

Signed-off-by: Matthias Schoepe <matthias.schoepe@studium.uni-erlangen.de>
Signed-off-by: Andreas Frembs <andreas.frembs@studium.uni-erlangen.de>

---
 drivers/staging/rtl8192e/rtllib.h         | 2 +-
 drivers/staging/rtl8192e/rtllib_crypt.c   | 2 +-
 drivers/staging/rtl8192e/rtllib_rx.c      | 2 +-
 drivers/staging/rtl8192e/rtllib_softmac.c | 4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtllib.h b/drivers/staging/rtl8192e/rtllib.h
index 05ef49f..83f5f57 100644
--- a/drivers/staging/rtl8192e/rtllib.h
+++ b/drivers/staging/rtl8192e/rtllib.h
@@ -2896,7 +2896,7 @@ extern void HTConstructCapabilityElement(struct rtllib_device *ieee,
 extern void HTConstructInfoElement(struct rtllib_device *ieee,
 				   u8 *posHTInfo, u8 *len, u8 isEncrypt);
 extern void HTConstructRT2RTAggElement(struct rtllib_device *ieee,
-				       u8 *posRT2RTAgg, u8* len);
+				       u8 *posRT2RTAgg, u8 *len);
 extern void HTOnAssocRsp(struct rtllib_device *ieee);
 extern void HTInitializeHTInfo(struct rtllib_device *ieee);
 extern void HTInitializeBssDesc(struct bss_ht *pBssHT);
diff --git a/drivers/staging/rtl8192e/rtllib_crypt.c b/drivers/staging/rtl8192e/rtllib_crypt.c
index 86152d0..60c0ced 100644
--- a/drivers/staging/rtl8192e/rtllib_crypt.c
+++ b/drivers/staging/rtl8192e/rtllib_crypt.c
@@ -183,7 +183,7 @@ struct lib80211_crypto_ops *rtllib_get_crypto_ops(const char *name)
 EXPORT_SYMBOL(rtllib_get_crypto_ops);
 
 
-static void * rtllib_crypt_null_init(int keyidx) { return (void *) 1; }
+static void *rtllib_crypt_null_init(int keyidx) { return (void *) 1; }
 static void rtllib_crypt_null_deinit(void *priv) {}
 
 static struct lib80211_crypto_ops rtllib_crypt_null = {
diff --git a/drivers/staging/rtl8192e/rtllib_rx.c b/drivers/staging/rtl8192e/rtllib_rx.c
index 1a011b9..374160d 100644
--- a/drivers/staging/rtl8192e/rtllib_rx.c
+++ b/drivers/staging/rtl8192e/rtllib_rx.c
@@ -211,7 +211,7 @@ rtllib_rx_frame_mgmt(struct rtllib_device *ieee, struct sk_buff *skb,
 	 * this is not mandatory.... but seems that the probe
 	 * response parser uses it
 	 */
-	struct rtllib_hdr_3addr * hdr = (struct rtllib_hdr_3addr *)skb->data;
+	struct rtllib_hdr_3addr *hdr = (struct rtllib_hdr_3addr *)skb->data;
 
 	rx_stats->len = skb->len;
 	rtllib_rx_mgt(ieee, skb, rx_stats);
diff --git a/drivers/staging/rtl8192e/rtllib_softmac.c b/drivers/staging/rtl8192e/rtllib_softmac.c
index 933bd6d..304b23e 100644
--- a/drivers/staging/rtl8192e/rtllib_softmac.c
+++ b/drivers/staging/rtl8192e/rtllib_softmac.c
@@ -1451,7 +1451,7 @@ static void rtllib_associate_abort_cb(unsigned long dev)
 	rtllib_associate_abort((struct rtllib_device *) dev);
 }
 
-static void rtllib_associate_step1(struct rtllib_device *ieee, u8 * daddr)
+static void rtllib_associate_step1(struct rtllib_device *ieee, u8 *daddr)
 {
 	struct rtllib_network *beacon = &ieee->current_network;
 	struct sk_buff *skb;
@@ -1785,7 +1785,7 @@ void rtllib_softmac_check_all_nets(struct rtllib_device *ieee)
 	spin_unlock_irqrestore(&ieee->lock, flags);
 }
 
-static inline u16 auth_parse(struct sk_buff *skb, u8** challenge, int *chlen)
+static inline u16 auth_parse(struct sk_buff *skb, u8 **challenge, int *chlen)
 {
 	struct rtllib_authentication *a;
 	u8 *t;
-- 
1.8.5.2

