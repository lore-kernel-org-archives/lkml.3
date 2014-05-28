Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbaE1GxM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 02:53:12 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:63352 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095AbaE1Gwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 02:52:53 -0400
X-AuditID: cbfee690-b7fb56d000003439-fe-538587c4d6e5
From: Heesub Shin <heesub.shin@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Colin Cross <ccross@android.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Mitchel Humpherys <mitchelh@codeaurora.org>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        Sunghwan Yun <sunghwan.yun@samsung.com>,
        Dongjun Shin <d.j.shin@samsung.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Heesub Shin <heesub.shin@samsung.com>
Subject: [PATCH v2 2/9] staging: ion: simplify ion_page_pool_total()
Date: Wed, 28 May 2014 15:52:53 +0900
Message-id: <1401259980-26927-3-git-send-email-heesub.shin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1401259980-26927-1-git-send-email-heesub.shin@samsung.com>
References: <1401098701-24049-1-git-send-email-heesub.shin@samsung.com>
 <1401259980-26927-1-git-send-email-heesub.shin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsVy+t8zLd0j7a3BBvsOyFi8/3ufzWL7xm+s
	Fi8PaVqcuFhrcfDDfRaLPWd+sVs0L17PZnFw9hImizO/dS0u75rDZrF2/jY2ixuTCy1Odyxi
	deD12LZ7G6vH5b5eJo97+w6zeOycdZfd4861PWwe++euYffo27KK0ePzJrkAjigum5TUnMyy
	1CJ9uwSujHenNjAWNHNWzOk6y9zAeJK9i5GTQ0LAROJT90Y2CFtM4sK99UA2F4eQwDJGiddP
	9rLCFL1YuZQJIrGIUeL+oYnMEE47k8T07a+Bqjg42AS0JQ5tCwZpEBEwlug/O4sdpIZZ4DCz
	RNestWwgNcICLhI7uwNAalgEVCUmTZ4MtoBXwF3i+YcWqIvkJE4emww2klPAQ2L7mxCIVa2M
	EtOPP2cEcSQEbrFLXHz2nBVikIDEt8mHWEAaJARkJTYdYIaYIylxcMUNlgmMwgsYGVYxiqYW
	JBcUJ6UXmegVJ+YWl+al6yXn525ihETOhB2M9w5YH2JMBho3kVlKNDkfGHl5JfGGxmZGFqYm
	psZG5pZmpAkrifOqPUoKEhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cA46c9ulolsivsSv8W/
	q+U4znOzfJPutw0tRvYzCySZfl/eurQ4NvtPeslj/rMHnIUXC2c5VUx/e9i8kPvknpsX+1t8
	5FzLvt89sO/218sWLMUf/0k+cNW//uCzuMHryRP5/y3lPfTM7uOjZ3bb6/h2775SmbRQJH9f
	dnTgjqs63QG+/eapKlKCSizFGYmGWsxFxYkAydwsOrICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t9jAd0j7a3BBlPXS1i8/3ufzWL7xm+s
	Fi8PaVqcuFhrcfDDfRaLPWd+sVs0L17PZnFw9hImizO/dS0u75rDZrF2/jY2ixuTCy1Odyxi
	deD12LZ7G6vH5b5eJo97+w6zeOycdZfd4861PWwe++euYffo27KK0ePzJrkAjqgGRpuM1MSU
	1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoIOVFMoSc0qBQgGJ
	xcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBnvTm1gLGjmrJjTdZa5gfEkexcjJ4eEgInE
	i5VLmSBsMYkL99azdTFycQgJLGKUuH9oIjOE084kMX37a9YuRg4ONgFtiUPbgkEaRASMJfrP
	zmIHqWEWOMws0TVrLRtIjbCAi8TO7gCQGhYBVYlJkyezgti8Au4Szz+0QC2Wkzh5bDLYSE4B
	D4ntb0IgVrUySkw//pxxAiPvAkaGVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjBcflMagfj
	ygaLQ4wCHIxKPLwHFrcEC7EmlhVX5h5ilOBgVhLhvVnYGizEm5JYWZValB9fVJqTWnyIMRno
	qonMUqLJ+cCUkVcSb2hsYmZkaWRmbGJubEyasJI474FW60AhgfTEktTs1NSC1CKYLUwcnFIN
	jLsOfZ+7qOO2jp1QnK2LxdUjd7Y5Mi33trc0OvrkSmXw4k6fHc5dExoP6O9+IM50vuTqoqKf
	IlyPmb2k2raKy9W8clStrdhjrKnIaHnxe+dxL3vd1E2ukx7WvPtvcbqy6kyouH5jUOyi1KM3
	74gUJfP+so96fEjLLuDBTsuNn7y+T39yoTSyTomlOCPRUIu5qDgRAHXhP4cPAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ion_page_pool_total() returns the total number of pages in the pool.
Depending on the argument passed, it counts highmem pages in or not.
This commit simplifies the code lines for better readability.

Signed-off-by: Heesub Shin <heesub.shin@samsung.com>
---
 drivers/staging/android/ion/ion_page_pool.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/android/ion/ion_page_pool.c b/drivers/staging/android/ion/ion_page_pool.c
index ead4054..1684780 100644
--- a/drivers/staging/android/ion/ion_page_pool.c
+++ b/drivers/staging/android/ion/ion_page_pool.c
@@ -119,12 +119,12 @@ void ion_page_pool_free(struct ion_page_pool *pool, struct page *page)
 
 static int ion_page_pool_total(struct ion_page_pool *pool, bool high)
 {
-	int total = 0;
+	int count = pool->low_count;
 
-	total += high ? (pool->high_count + pool->low_count) *
-		(1 << pool->order) :
-			pool->low_count * (1 << pool->order);
-	return total;
+	if (high)
+		count += pool->high_count;
+
+	return count << pool->order;
 }
 
 int ion_page_pool_shrink(struct ion_page_pool *pool, gfp_t gfp_mask,
-- 
1.9.1

