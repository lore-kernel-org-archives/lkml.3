Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758935AbaELReE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 13:34:04 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:12082 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751843AbaELReC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 13:34:02 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: An8KAFsFcVNbsHLF/2dsb2JhbABZgwasagkBBQGaG4EaF3SCUxMcIxiBAiQTiEUBz0aFVoh8hEcBA48liiIBiwSIA4M4Ow
Date: Mon, 12 May 2014 19:33:59 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] net/wireless/lib80211_crypt_ccmp.c: code clean-up
Message-Id: <20140512193359.c42773f6889bb4261672d90b@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing some checkpatch errors/warnings

Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/wireless/lib80211_crypt_ccmp.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/net/wireless/lib80211_crypt_ccmp.c b/net/wireless/lib80211_crypt_ccmp.c
index dc0e59e..1d6faef 100644
--- a/net/wireless/lib80211_crypt_ccmp.c
+++ b/net/wireless/lib80211_crypt_ccmp.c
@@ -83,7 +83,7 @@ static void *lib80211_ccmp_init(int key_idx)
 
 	return priv;
 
-      fail:
+fail:
 	if (priv) {
 		if (priv->tfm)
 			crypto_free_cipher(priv->tfm);
@@ -101,16 +101,17 @@ static void lib80211_ccmp_deinit(void *priv)
 	kfree(priv);
 }
 
-static inline void xor_block(u8 * b, u8 * a, size_t len)
+static inline void xor_block(u8 *b, u8 *a, size_t len)
 {
 	int i;
+
 	for (i = 0; i < len; i++)
 		b[i] ^= a[i];
 }
 
 static void ccmp_init_blocks(struct crypto_cipher *tfm,
 			     struct ieee80211_hdr *hdr,
-			     u8 * pn, size_t dlen, u8 * b0, u8 * auth, u8 * s0)
+			     u8 *pn, size_t dlen, u8 *b0, u8 *auth, u8 *s0)
 {
 	u8 *pos, qc = 0;
 	size_t aad_len;
@@ -124,7 +125,7 @@ static void ccmp_init_blocks(struct crypto_cipher *tfm,
 	if (a4_included)
 		aad_len += 6;
 	if (qc_included) {
-		pos = (u8 *) & hdr->addr4;
+		pos = (u8 *)&hdr->addr4;
 		if (a4_included)
 			pos += 6;
 		qc = *pos & 0x0f;
@@ -135,7 +136,8 @@ static void ccmp_init_blocks(struct crypto_cipher *tfm,
 	 * Flag (Include authentication header, M=3 (8-octet MIC),
 	 *       L=1 (2-octet Dlen))
 	 * Nonce: 0x00 | A2 | PN
-	 * Dlen */
+	 * Dlen
+	 */
 	b0[0] = 0x59;
 	b0[1] = qc;
 	memcpy(b0 + 2, hdr->addr2, ETH_ALEN);
@@ -156,7 +158,7 @@ static void ccmp_init_blocks(struct crypto_cipher *tfm,
 	aad[2] = pos[0] & 0x8f;
 	aad[3] = pos[1] & 0xc7;
 	memcpy(aad + 4, hdr->addr1, 3 * ETH_ALEN);
-	pos = (u8 *) & hdr->seq_ctrl;
+	pos = (u8 *)&hdr->seq_ctrl;
 	aad[22] = pos[0] & 0x0f;
 	aad[23] = 0;		/* all bits masked */
 	memset(aad + 24, 0, 8);
@@ -206,7 +208,7 @@ static int lib80211_ccmp_hdr(struct sk_buff *skb, int hdr_len,
 	*pos++ = key->tx_pn[5];
 	*pos++ = key->tx_pn[4];
 	*pos++ = 0;
-	*pos++ = (key->key_idx << 6) | (1 << 5) /* Ext IV included */ ;
+	*pos++ = (key->key_idx << 6) | (1 << 5); /* Ext IV included */
 	*pos++ = key->tx_pn[3];
 	*pos++ = key->tx_pn[2];
 	*pos++ = key->tx_pn[1];
@@ -261,8 +263,7 @@ static int lib80211_ccmp_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	return 0;
 }
 
-/*
- * deal with seq counter wrapping correctly.
+/* deal with seq counter wrapping correctly.
  * refer to timer_after() for jiffies wrapping handling
  */
 static inline int ccmp_replay_check(u8 *pn_n, u8 *pn_o)
@@ -311,8 +312,8 @@ static int lib80211_ccmp_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	}
 	keyidx >>= 6;
 	if (key->key_idx != keyidx) {
-		printk(KERN_DEBUG "CCMP: RX tkey->key_idx=%d frame "
-		       "keyidx=%d priv=%p\n", key->key_idx, keyidx, priv);
+		printk(KERN_DEBUG "CCMP: RX tkey->key_idx=%d frame keyidx=%d priv=%p\n",
+		       key->key_idx, keyidx, priv);
 		return -6;
 	}
 	if (!key->key_set) {
@@ -377,7 +378,7 @@ static int lib80211_ccmp_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	return keyidx;
 }
 
-static int lib80211_ccmp_set_key(void *key, int len, u8 * seq, void *priv)
+static int lib80211_ccmp_set_key(void *key, int len, u8 *seq, void *priv)
 {
 	struct lib80211_ccmp_data *data = priv;
 	int keyidx;
@@ -407,7 +408,7 @@ static int lib80211_ccmp_set_key(void *key, int len, u8 * seq, void *priv)
 	return 0;
 }
 
-static int lib80211_ccmp_get_key(void *key, int len, u8 * seq, void *priv)
+static int lib80211_ccmp_get_key(void *key, int len, u8 *seq, void *priv)
 {
 	struct lib80211_ccmp_data *data = priv;
 
-- 
1.9.1
