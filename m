Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbaEZKHM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 06:07:12 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:36762 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbaEZKHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 06:07:07 -0400
X-AuditID: cbfee690-b7fb56d000003439-d7-5383124a19bd
From: Heesub Shin <heesub.shin@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Colin Cross <ccross@android.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Mitchel Humpherys <mitchelh@codeaurora.org>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        Sunghwan Yun <sunghwan.yun@samsung.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Heesub Shin <heesub.shin@samsung.com>
Subject: [PATCH 7/9] staging: ion: remove order argument from free_buffer_page()
Date: Mon, 26 May 2014 19:04:59 +0900
Message-id: <1401098701-24049-7-git-send-email-heesub.shin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1401098701-24049-1-git-send-email-heesub.shin@samsung.com>
References: <1401098701-24049-1-git-send-email-heesub.shin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDIsWRmVeSWpSXmKPExsVy+t8zTV0voeZgg6Yrwhbv/95ns9i+8Rur
	xctDmhYHP9xnsdhz5he7RfPi9WwWB2cvYbI481vX4vKuOWwWa+dvY7O4MbnQ4nTHIlYHHo9t
	u7exelzu62XyuLfvMIvHzll32T3uXNvD5rF/7hp2j74tqxg9Pm+SC+CI4rJJSc3JLEst0rdL
	4Mr4v3M7a8FbnorTne2sDYyPuboYOTkkBEwkuhacY4ewxSQu3FvP1sXIxSEksIxR4mXPclaY
	oqYzOxghEtMZJSYc3sgC4bQzSVxY+wqohYODTUBb4tC2YJAGEQFjif6zs9hBapgF5jBLTNl6
	gQkkISwQILFnx1Mwm0VAVeJS12mwDbwC7hI7f66AOkNO4uSxyWBxTgEPiYlP5rCA2EJANbc3
	PgQ7T0LgGrvE9r1/mSEGCUh8m3yIBeQICQFZiU0HmCHmSEocXHGDZQKj8AJGhlWMoqkFyQXF
	SelFJnrFibnFpXnpesn5uZsYITEzYQfjvQPWhxiTgcZNZJYSTc4HxlxeSbyhsZmRhamJqbGR
	uaUZacJK4rxqj5KChATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTCGPBa9KN+w7sxkpm+frn63
	imF+u351caDAvRt6ee+9RWZyvJk1z7o9k8Egc89Rnu5Ev/A5rff7Ns971SzB4xSSvbnZ/uYC
	9wPsGeHcMyTWrXRj+OlxYGbtIdb3ZwySw+aVK7wzvN39kvXGnJIfmu5KvxbtVbFX+OawcNu3
	FScnXE3Q2bdr+uZFSizFGYmGWsxFxYkA3Mpvaq8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t9jQV0voeZgg6f9/Bbv/95ns9i+8Rur
	xctDmhYHP9xnsdhz5he7RfPi9WwWB2cvYbI481vX4vKuOWwWa+dvY7O4MbnQ4nTHIlYHHo9t
	u7exelzu62XyuLfvMIvHzll32T3uXNvD5rF/7hp2j74tqxg9Pm+SC+CIamC0yUhNTEktUkjN
	S85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAE6VkmhLDGnFCgUkFhcrKRv
	h2lCaIibrgVMY4Sub0gQXI+RARpIWMeY8X/ndtaCtzwVpzvbWRsYH3N1MXJySAiYSDSd2cEI
	YYtJXLi3nq2LkYtDSGA6o8SEwxtZIJx2JokLa18BZTg42AS0JQ5tCwZpEBEwlug/O4sdpIZZ
	YA6zxJStF5hAEsICARJ7djwFs1kEVCUudZ1mBbF5Bdwldv5cwQ6xTU7i5LHJYHFOAQ+JiU/m
	sIDYQkA1tzc+ZJvAyLuAkWEVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnBEPpPawbiyweIQ
	owAHoxIP7wHvpmAh1sSy4srcQ4wSHMxKIrxanM3BQrwpiZVVqUX58UWlOanFhxiTga6ayCwl
	mpwPTBZ5JfGGxiZmRpZGZsYm5sbGpAkrifMeaLUOFBJITyxJzU5NLUgtgtnCxMEp1cDo8i17
	Urnpypibtn4cXl9u2N24laW46ujj7e4zZbR2GiybeGFRVPK83F1Kmt9+B5mLvWndHftb6dzc
	w3/u18bXdi48kXRnu8yjK2KM13K+R7S5VMkpG53evObf7zkBW06vunM5cYO1hkw99/my2C3P
	1zKUTJOOXqh96dr5fXv/fZnJxMzj7rNATImlOCPRUIu5qDgRADAVmggMAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not that the pages returned from the pool are compound pages, we do not
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

