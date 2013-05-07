Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760665Ab3EGEnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:43:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25931 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759405Ab3EGEZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:39 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=G_bqtcx_TGMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=B3eLH4dEQ3gA:10 a=YhdJeHolAAAA:8 a=7ZN4cI0QAAAA:8 a=J1Y8HTJGAAAA:8 a=1jDhsOQtFa7LoEU8SmYA:9 a=Vn2gH7L4UmAA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035900.997235930@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:59:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [120/126] esp4: fix error return code in esp_output()
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0120-esp4-fix-error-return-code-in-esp_output.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

[ Upstream commit 06848c10f720cbc20e3b784c0df24930b7304b93 ]

Fix to return a negative error code from the error handling
case instead of 0, as returned elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/ipv4/esp4.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index b61e9de..6e356c5 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -139,8 +139,6 @@ static int esp_output(struct xfrm_state *x, struct sk_buff *skb)
 
 	/* skb is pure payload to encrypt */
 
-	err = -ENOMEM;
-
 	esp = x->data;
 	aead = esp->aead;
 	alen = crypto_aead_authsize(aead);
@@ -176,8 +174,10 @@ static int esp_output(struct xfrm_state *x, struct sk_buff *skb)
 	}
 
 	tmp = esp_alloc_tmp(aead, nfrags + sglists, seqhilen);
-	if (!tmp)
+	if (!tmp) {
+		err = -ENOMEM;
 		goto error;
+	}
 
 	seqhi = esp_tmp_seqhi(tmp);
 	iv = esp_tmp_iv(aead, tmp, seqhilen);
-- 
1.7.10.4


