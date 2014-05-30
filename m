Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353AbaE3B0i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 21:26:38 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:21889 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259AbaE3B0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 21:26:35 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-09-5387de49c395
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
Subject: [PATCH v2 RESEND 3/4] staging: ion: remove order argument from
 free_buffer_page()
Date: Fri, 30 May 2014 10:26:29 +0900
Message-id: <1401413190-13514-3-git-send-email-heesub.shin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1401413190-13514-1-git-send-email-heesub.shin@samsung.com>
References: <20140529204208.GA2120@kroah.com>
 <1401413190-13514-1-git-send-email-heesub.shin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsVy+t8zLV3Pe+3BBl92Glu8/3ufzWL7xm+s
	Fi8PaVqcuFhrcfDDfRaLPWd+sVs0L17PZnFw9hImizO/dS0u75rDZrF2/jY2ixuTCy1Odyxi
	deD12LZ7G6vH5b5eJo97+w6zeOycdZfd4861PWwe++euYffo27KK0ePzJrkAjigum5TUnMyy
	1CJ9uwSujP5nu1kLrvNW/Nvwkr2B8TB3FyMnh4SAiUTL95MsELaYxIV769m6GLk4hASWMUo8
	ffiFDaZowpf5zBCJ6YwSE++tZ4Fw2pkkJm/fwNrFyMHBJqAtcWhbMEiDiICxRP/ZWewgNcwC
	h5klumatZQOpERaIkdjQZgVSwyKgKtHyYAkTiM0r4C7Rv6qbFWKZnMTJY5PBbE4BD4lr33+C
	HSEkkC1xbMFsRpCZEgL32CU29X1hhxgkIPFt8iEWkPkSArISmw4wQ8yRlDi44gbLBEbhBYwM
	qxhFUwuSC4qT0otM9YoTc4tL89L1kvNzNzFCImfiDsb7B6wPMSYDjZvILCWanA+MvLySeENj
	MyMLUxNTYyNzSzPShJXEedMfJQUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYIwNnHAoqJFh
	t+69N+lFqX2bnzOflGDV/xazounuKc+/tvwTAi8u1HI3/sFuO6E8J4SF/1LK1MVrX6/WXHJ7
	6jbttg551reP5ZOvT3vBuYXb9Uw8q2/Rxr+nPsVVKxxR/O3yu73kY37rhLkdTydXvNbZvXmL
	6CFvntLYsxcMLCQTLVYd/ORc8UyJpTgj0VCLuag4EQB6KWZRsgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t9jQV3Pe+3BBqdm6lu8/3ufzWL7xm+s
	Fi8PaVqcuFhrcfDDfRaLPWd+sVs0L17PZnFw9hImizO/dS0u75rDZrF2/jY2ixuTCy1Odyxi
	deD12LZ7G6vH5b5eJo97+w6zeOycdZfd4861PWwe++euYffo27KK0ePzJrkAjqgGRpuM1MSU
	1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoIOVFMoSc0qBQgGJ
	xcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBn9z3azFlznrfi34SV7A+Nh7i5GTg4JAROJ
	CV/mM0PYYhIX7q1n62Lk4hASmM4oMfHeehYIp51JYvL2DaxdjBwcbALaEoe2BYM0iAgYS/Sf
	ncUOUsMscJhZomvWWjaQGmGBGIkNbVYgNSwCqhItD5Ywgdi8Au4S/au6WSGWyUmcPDYZzOYU
	8JC49v0nG4gtJJAtcWzBbMYJjLwLGBlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgTH5TOp
	HYwrGywOMQpwMCrx8DZGtgcLsSaWFVfmHmKU4GBWEuF1PAwU4k1JrKxKLcqPLyrNSS0+xJgM
	dNVEZinR5HxgysgriTc0NjEzsjQyMzYxNzYmTVhJnPdAq3WgkEB6YklqdmpqQWoRzBYmDk6p
	BsZV31xEReZz9dQunSrg+lj40r6SV9c3Tea+xTRh47Gp90+6hG4X+8V4yUH2xaqZpiydH7j8
	Te7dZRCbsbju4glJVe+H66z6KuTfi73x/ZkwpeiZTkNq9+Vz4VdKGDjYxCbsfrysa/FGxkXn
	JD32M59trW7tUFq4UO6qqckq9UbBhxPrqtcrXrmsxFKckWioxVxUnAgANQG/jg8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the pages returned from the pool are compound pages, we do not
need to pass the order information to free_buffer_page().

Signed-off-by: Heesub Shin <heesub.shin@samsung.com>
Reviewed-by: Mitchel Humpherys <mitchelh@codeaurora.org>
Tested-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_system_heap.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index f3b9008..e0a7e54 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -78,9 +78,9 @@ static struct page *alloc_buffer_page(struct ion_system_heap *heap,
 }
 
 static void free_buffer_page(struct ion_system_heap *heap,
-			     struct ion_buffer *buffer, struct page *page,
-			     unsigned int order)
+			     struct ion_buffer *buffer, struct page *page)
 {
+	unsigned int order = compound_order(page);
 	bool cached = ion_buffer_cached(buffer);
 
 	if (!cached && !(buffer->private_flags & ION_PRIV_FLAG_SHRINKER_FREE)) {
@@ -171,7 +171,7 @@ free_table:
 	kfree(table);
 free_pages:
 	list_for_each_entry_safe(page, tmp_page, &pages, lru)
-		free_buffer_page(sys_heap, buffer, page, compound_order(page));
+		free_buffer_page(sys_heap, buffer, page);
 	return -ENOMEM;
 }
 
@@ -191,8 +191,7 @@ static void ion_system_heap_free(struct ion_buffer *buffer)
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

