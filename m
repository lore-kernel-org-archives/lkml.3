Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbaBQJsK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:48:10 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:14618 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbaBQJpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:45:18 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-a5-5301da2d5b84
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, davem@davemloft.net
Subject: [PATCH 7/9 v7] crypto:s5p-sss: validate iv before memcpy
Date: Mon, 17 Feb 2014 15:14:33 +0530
Message-id: <1392630275-8667-8-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392630275-8667-1-git-send-email-ch.naveen@samsung.com>
References: <1392630275-8667-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsWyRsSkVlf3FmOwwcx+CYuXhzQt5pxvYbHo
	fiVjcf/eTyaLy7vmsFnMOL+PyWLRtv/MFmfnHGJy4PDYsvImk8fOWXfZPbYdUPXo27KK0ePz
	JrkA1igum5TUnMyy1CJ9uwSujFdXT7MXTOOo2DHzNlsD42e2LkYODgkBE4lZb4S7GDmBTDGJ
	C/fWA4W5OIQEljJKPH85jwkiYSJx5tgsZojEIkaJrsl3oar6mST+rd/DBlLFJmAmcXDRanYQ
	W0TAWeJ38xpWkCJmgVmMErPvf2IEWScs4Cjx80gWSA2LgKrEzTcPmEFsXgEXickb3zJDXKQg
	MWeSDUiYU8BVovPOdhYQWwioZF3nJRaQkRICi9gl/t9uYoKYIyDxbfIhFoheWYlNB5ghjpaU
	OLjiBssERuEFjAyrGEVTC5ILipPSiwz1ihNzi0vz0vWS83M3MQID/fS/Z707GG8fsD7EmAw0
	biKzlGhyPjBS8kriDY3NjCxMTUyNjcwtzUgTVhLnTXqYFCQkkJ5YkpqdmlqQWhRfVJqTWnyI
	kYmDU6qB0ff7nKV5+Ukh1V9XrzXI0Lwl65n+/mHA9zXzhS56r1hvNuXH1wPhxyIa3c976dRr
	HFectHlf7MJ5L23yW5sfVzoFtgpY/HRuuWGbK2F2QlthZeq75+9u3OrzktCeoFTVaOXGf7dm
	9/FHxv+3n9bzlr4ta2PssW7TJtdGhQnqsgt/lK8zEf+Ro8RSnJFoqMVcVJwIALOPGoCKAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t9jAV3dW4zBBj9WCVi8PKRpMed8C4tF
	9ysZi/v3fjJZXN41h81ixvl9TBaLtv1ntjg75xCTA4fHlpU3mTx2zrrL7rHtgKpH35ZVjB6f
	N8kFsEY1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXm
	AF2ipFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYcx4dfU0e8E0joodM2+z
	NTB+Zuti5OSQEDCROHNsFjOELSZx4d56oDgXh5DAIkaJrsl3oZx+Jol/6/eAdbAJmEkcXLSa
	HcQWEXCW+N28hhWkiFlgFqPE7PufGLsYOTiEBRwlfh7JAqlhEVCVuPnmAdgGXgEXickb3zKD
	lEgIKEjMmWQDEuYUcJXovLOdBcQWAipZ13mJZQIj7wJGhlWMoqkFyQXFSem5hnrFibnFpXnp
	esn5uZsYwZH0TGoH48oGi0OMAhyMSjy8BtWMwUKsiWXFlbmHGCU4mJVEeG3XAYV4UxIrq1KL
	8uOLSnNSiw8xJgMdNZFZSjQ5HxjleSXxhsYm5qbGppYmFiZmlqQJK4nzHmi1DhQSSE8sSc1O
	TS1ILYLZwsTBKdXA2JOQMUFAZJ6Xl91pwb073yS5yy9sWTyvfg7j/FPd6z9ONtiaOpHvbN6C
	Wy8Nrm9T+jzt7Y3Ys8LJDFL3vn88vfmdYtG2QxuaDM3Lmb43HXIqXS/8odv9s3OQbnPvhnvX
	v5bJq5rylq64vJ19l6v63a4Uq/D+3M9KuTt8lhfv5cz93vLKPTdmthJLcUaioRZzUXEiABiT
	0KvoAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds code to validate "iv" buffer before trying to
memcpy the contents

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
CC: David S. Miller <davem@davemloft.net>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
TO: <linux-crypto@vger.kernel.org>
CC: <linux-samsung-soc@vger.kernel.org>
---
Changes since v6:
None

 drivers/crypto/s5p-sss.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index fa21db5..7da1da4 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -380,7 +380,8 @@ static void s5p_set_aes(struct s5p_aes_dev *dev,
 {
 	void __iomem *keystart;
 
-	memcpy(dev->aes_ioaddr + SSS_REG_AES_IV_DATA(0), iv, 0x10);
+	if (iv)
+		memcpy(dev->aes_ioaddr + SSS_REG_AES_IV_DATA(0), iv, 0x10);
 
 	if (keylen == AES_KEYSIZE_256)
 		keystart = dev->aes_ioaddr + SSS_REG_AES_KEY_DATA(0);
-- 
1.7.9.5

