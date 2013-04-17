Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966948Ab3DQWd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 18:33:26 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:18695 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966716Ab3DQWdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 18:33:22 -0400
X-AuditID: cbfee68e-b7f946d000001e37-bb-516f232fd7b0
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, "'Wei Yongjun'" <yongjun_wei@trendmicro.com.cn>,
        "'David S. Miller'" <davem@davemloft.net>
References: 
In-reply-to: 
Subject: [PATCH 3.8-stable] esp4: fix error return code in esp_output()
Date: Thu, 18 Apr 2013 07:33:19 +0900
Message-id: <003301ce3bbb$8fd1fd70$af75f850$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAEJzDJAAtXBJYAH2IzBg
Content-language: ko
x-cr-hashedpuzzle: FwhA G7Ul Iezj LhFK LqV0 PERw UsR3 VquK Z2D4 ayjJ byRL eH0n
 kkT+ pDmj yXEM
 zol1;5;ZABhAHYAZQBtAEAAZABhAHYAZQBtAGwAbwBmAHQALgBuAGUAdAA7AGoAaABiAGkAcgBkAC4AYwBoAG8AaQBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBzAHQAYQBiAGwAZQBAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAeQBvAG4AZwBqAHUAbgBfAHcAZQBpAEAAdAByAGUAbgBkAG0AaQBjAHIAbwAuAGMAbwBtAC4AYwBuAA==;Sosha1_v1;7;{1DFECEDD-CC72-4F39-A810-386042C2CA4A};agBoAGIAaQByAGQALgBjAGgAbwBpAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtAA==;Wed,
 17 Apr 2013 22:33:11
 GMT;WwBQAEEAVABDAEgAIAAzAC4AOAAtAHMAdABhAGIAbABlAF0AIABlAHMAcAA0ADoAIABmAGkAeAAgAGUAcgByAG8AcgAgAHIAZQB0AHUAcgBuACAAYwBvAGQAZQAgAGkAbgAgAGUAcwBwAF8AbwB1AHQAcAB1AHQAKAApAA==
x-cr-puzzleid: {1DFECEDD-CC72-4F39-A810-386042C2CA4A}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t8zfV195fxAgy/3bSzmnG9hsVjSzG1x
	edccNosFGx8xWuxc18nuwOqxZeVNJo++LasYPZbeO8ro8XmTXABLFJdNSmpOZllqkb5dAlfG
	x9tvmAv6uSt+LL3A1sC4haOLkZNDQsBE4uvzHYwQtpjEhXvr2boYuTiEBJYxSnw994UZpujh
	3rtQiemMEvtPnwZLCAn8ZZTofSENYrMJ6EocW7+FFcQWEfCWODXlF1gNs0CZxMcXvexdjBxA
	9dwSq5uDQMKcAjwS6/50MoOEhQXcJRoaREBMFgFVifmf2UEqeAXsJGa8OQ5lC0r8mHyPBWKg
	lsT6nceZIGx5ic1r3oJNkRBQl3j0Vxdiv5vEvbUvGCFKRCT2vXgH9eEPVonuK24QtqnEh+W3
	2UGekhB4yy5x+/FqsJksAgIS3yYfYoGYKSux6QA0ECQlDq64wTKBUWoWkotmIbloFpKLZiFZ
	vYCRZRWjaGpBckFxUnqRkV5xYm5xaV66XnJ+7iZGSBz37WC8ecD6EGMy0PqJzFKiyfnANJBX
	Em9obGZkYWpiamxkbmlGmrCSOK9ai3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsau1QzK
	eVMnWTz2id/1VqWU432b2N4njef7tKb4zpRm2lZgm/JfIOnMX4MDcvJcLV3uTHtvnaiJ752U
	u+jtppSPvqsWcVXK/mr+/uIpE7u4b2p53G/20zM+Of49fGQ71xEbv/qzp45r6ByIM82JXMUX
	fjps0Tsv2c1mqZYKxzO0X5l/cuRf6KvEUpyRaKjFXFScCADOOeSP+QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMKsWRmVeSWpSXmKPExsVy+t9jQV195fxAg40HzS3mnG9hsVjSzG1x
	edccNosFGx8xWuxc18nuwOqxZeVNJo++LasYPZbeO8ro8XmTXABLVAOjTUZqYkpqkUJqXnJ+
	SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QXiWFssScUqBQQGJxsZK+HaYJ
	oSFuuhYwjRG6viFBcD1GBmggYR1jxsfbb5gL+rkrfiy9wNbAuIWji5GTQ0LAROLh3rtsELaY
	xIV764FsLg4hgemMEvtPn2YGSQgJ/GWU6H0hDWKzCehKHFu/hRXEFhHwljg15RdYDbNAmcTH
	F73sXYwcQPXcEqubg0DCnAI8Euv+dDKDhIUF3CUaGkRATBYBVYn5n9lBKngF7CRmvDkOZQtK
	/Jh8jwVioJbE+p3HmSBseYnNa96CTZEQUJd49FcXYr+bxL21LxghSkQk9r14xwjxyA9Wie4r
	bhC2qcSH5bfZJzCKzEKyYRaSDbOQbJiFZNQCRpZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmb
	GMFJ4pnUDsaVDRaHGAU4GJV4eB+sygsUYk0sK67MPcQowcGsJML7SDY/UIg3JbGyKrUoP76o
	NCe1+BBjMtD/E5mlRJPzgQksryTe0NjEzMjSyMzCyMTcnDRhJXHeA63WgUIC6YklqdmpqQWp
	RTBbmDg4pRoYJ976c8vxf+rB09+nLz3ta1124t30oGPMum5OORwx1x8eU16qnaRTVXdrF0dQ
	Q/dpxWeZDf89r7SdmXahhzN1X/6e+7nHc46Z3v4vfmbCm5v6ez1OeJXOVsjzLt6b+mffiQ93
	z9168Nglf+YltcYD+y5Mn2Vi5CT77OtirgZr5wdsRxxcp79fb63EUpyRaKjFXFScCACJvsQu
	VgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch looks like it should be in the 3.8-stable tree, should we apply
it?

------------------

From: "Wei Yongjun <yongjun_wei@trendmicro.com.cn>"

commit 06848c10f720cbc20e3b784c0df24930b7304b93 upstream

Fix to return a negative error code from the error handling
case instead of 0, as returned elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 net/ipv4/esp4.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index 3b4f0cd..4cfe34d 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -139,8 +139,6 @@ static int esp_output(struct xfrm_state *x, struct
sk_buff *skb)

        /* skb is pure payload to encrypt */

-       err = -ENOMEM;
-
        esp = x->data;
        aead = esp->aead;
        alen = crypto_aead_authsize(aead);
@@ -176,8 +174,10 @@ static int esp_output(struct xfrm_state *x, struct
sk_buff *skb)
        }

        tmp = esp_alloc_tmp(aead, nfrags + sglists, seqhilen);
-       if (!tmp)
+       if (!tmp) {
+               err = -ENOMEM;
                goto error;
+       }

        seqhi = esp_tmp_seqhi(tmp);
        iv = esp_tmp_iv(aead, tmp, seqhilen);
--
1.7.9.5

