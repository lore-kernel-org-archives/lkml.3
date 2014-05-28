Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbaE1Gy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 02:54:57 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:63449 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155AbaE1GxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 02:53:18 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-40-538587dbdc24
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
Subject: [PATCH v2 7/9] staging: ion: remove order argument from
 free_buffer_page()
Date: Wed, 28 May 2014 15:52:58 +0900
Message-id: <1401259980-26927-8-git-send-email-heesub.shin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1401259980-26927-1-git-send-email-heesub.shin@samsung.com>
References: <1401098701-24049-1-git-send-email-heesub.shin@samsung.com>
 <1401259980-26927-1-git-send-email-heesub.shin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAIsWRmVeSWpSXmKPExsVy+t8zPd3b7a3BBpNPWlq8/3ufzWL7xm+s
	Fi8PaVqcuFhrcfDDfRaLPWd+sVs0L17PZnFw9hImizO/dS0u75rDZrF2/jY2ixuTCy1Odyxi
	deD12LZ7G6vH5b5eJo97+w6zeOycdZfd4861PWwe++euYffo27KK0ePzJrkAjigum5TUnMyy
	1CJ9uwSujBXP+tkL3vJU9Gy5xtTA+Jiri5GTQ0LAROLI5ensELaYxIV769m6GLk4hASWMUr8
	/N/NClP0++IhdojEIkaJTxcfMEM47UwSy+aCVHFwsAloSxzaFgzSICJgLNF/dhZYA7PAYWaJ
	rllr2UASwgKhEjOenAGbyiKgKrFn93OwOK+Au8S1TcdZILbJSZw8NhlsJqeAh8T2NyEQu1oZ
	JaYff84I4kgI3GOX2Hm6kw1ikIDEt8mHWEAaJARkJTYdYIaYIylxcMUNlgmMwgsYGVYxiqYW
	JBcUJ6UXGeoVJ+YWl+al6yXn525ihMRO7w7G2wesDzEmA42byCwlmpwPjL28knhDYzMjC1MT
	U2Mjc0sz0oSVxHmTHiYFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamC8xbT54YpPE7//C446
	OOVKzxOvtBrn9OJf5+7deBT3eWe218pTARo+cevzzYLOFSxKNs3S7n1Ss0tNW8G3k11kc+TL
	K0GXDYt5NOOUStzEtEReXD/6W49/w5bXP0N1NK6pXDCpjLyp0iR3KTf9U/iSS78DWx6ExB95
	uSVA9Ybq1jADnSCvLz1KLMUZiYZazEXFiQDCNOk+swIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t9jAd3b7a3BBuuum1q8/3ufzWL7xm+s
	Fi8PaVqcuFhrcfDDfRaLPWd+sVs0L17PZnFw9hImizO/dS0u75rDZrF2/jY2ixuTCy1Odyxi
	deD12LZ7G6vH5b5eJo97+w6zeOycdZfd4861PWwe++euYffo27KK0ePzJrkAjqgGRpuM1MSU
	1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoIOVFMoSc0qBQgGJ
	xcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBkrnvWzF7zlqejZco2pgfExVxcjJ4eEgInE
	74uH2CFsMYkL99azdTFycQgJLGKU+HTxATOE084ksWxuN2sXIwcHm4C2xKFtwSANIgLGEv1n
	Z7GD1DALHGaW6Jq1lg0kISwQKjHjyRlWEJtFQFViz+7nYHFeAXeJa5uOs0Bsk5M4eWwy2ExO
	AQ+J7W9CIHa1MkpMP/6ccQIj7wJGhlWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwZH5THoH
	46oGi0OMAhyMSjy8Bxa3BAuxJpYVV+YeYpTgYFYS4b1Z2BosxJuSWFmVWpQfX1Sak1p8iDEZ
	6KqJzFKiyfnApJFXEm9obGJmZGlkZmxibmxMmrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxS
	DYy9dun3Nkc3n53V3X5W4JRwEpusQrw7q5PvyzobobJdTbPFo5//fFluMjVNXTCA49iCPw/f
	sDX+cwk9p3uy/n///xmcb/+3mk9in3lyxcTsw0tu2/MeaUvZXCE/QVlP9WOVg8lUjsUm+xxv
	Bjw783fWlYadJ0Tln2kXPdmhdfeMUOOkYKmkHblKLMUZiYZazEXFiQApRj0zEAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the pages returned from the pool are compound pages, we do not
need to pass the order information to free_buffer_page().

Signed-off-by: Heesub Shin <heesub.shin@samsung.com>
---
 drivers/staging/android/ion/ion_system_heap.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index f0ae210..d78d589e 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -77,9 +77,9 @@ static struct page *alloc_buffer_page(struct ion_system_heap *heap,
 }
 
 static void free_buffer_page(struct ion_system_heap *heap,
-			     struct ion_buffer *buffer, struct page *page,
-			     unsigned int order)
+			     struct ion_buffer *buffer, struct page *page)
 {
+	unsigned int order = compound_order(page);
 	bool cached = ion_buffer_cached(buffer);
 
 	if (!cached && !(buffer->private_flags & ION_PRIV_FLAG_SHRINKER_FREE)) {
@@ -169,7 +169,7 @@ free_table:
 	kfree(table);
 free_pages:
 	list_for_each_entry_safe(page, tmp_page, &pages, lru)
-		free_buffer_page(sys_heap, buffer, page, compound_order(page));
+		free_buffer_page(sys_heap, buffer, page);
 	return -ENOMEM;
 }
 
@@ -189,8 +189,7 @@ static void ion_system_heap_free(struct ion_buffer *buffer)
 		ion_heap_buffer_zero(buffer);
 
 	for_each_sg(table->sgl, sg, table->nents, i)
-		free_buffer_page(sys_heap, buffer, sg_page(sg),
-				get_order(sg->length));
+		free_buffer_page(sys_heap, buffer, sg_page(sg));
 	sg_free_table(table);
 	kfree(table);
 }
-- 
1.9.1

