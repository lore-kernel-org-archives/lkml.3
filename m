Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab3EJOUo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:20:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57030 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753604Ab3EJOUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:20:41 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Steffen Klassert" <steffen.klassert@secunet.com>,
        "Wei Yongjun" <yongjun_wei@trendmicro.com.cn>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.834717324@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [095/118] esp4: fix error return code in esp_output()
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

[ Upstream commit 06848c10f720cbc20e3b784c0df24930b7304b93 ]

Fix to return a negative error code from the error handling
case instead of 0, as returned elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/esp4.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -137,8 +137,6 @@ static int esp_output(struct xfrm_state
 
 	/* skb is pure payload to encrypt */
 
-	err = -ENOMEM;
-
 	esp = x->data;
 	aead = esp->aead;
 	alen = crypto_aead_authsize(aead);
@@ -174,8 +172,10 @@ static int esp_output(struct xfrm_state
 	}
 
 	tmp = esp_alloc_tmp(aead, nfrags + sglists, seqhilen);
-	if (!tmp)
+	if (!tmp) {
+		err = -ENOMEM;
 		goto error;
+	}
 
 	seqhi = esp_tmp_seqhi(tmp);
 	iv = esp_tmp_iv(aead, tmp, seqhilen);

