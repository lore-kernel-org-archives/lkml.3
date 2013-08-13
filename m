Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934Ab3HMChd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 22:37:33 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:35017 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756741Ab3HMChb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 22:37:31 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-da-52099be837b2
From: Heesub Shin <heesub.shin@samsung.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heesub Shin <heesub.shin@samsung.com>,
        Dongjun Shin <d.j.shin@samsung.com>
Subject: [PATCH] fs/buffer.c: use lowmem_page_address instead of page_address
Date: Tue, 13 Aug 2013 11:37:55 +0900
Message-id: <1376361475-17778-1-git-send-email-heesub.shin@samsung.com>
X-Mailer: git-send-email 1.8.3.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsVy+t8zPd0XszmDDLrPWVicuFhrcXD2EiaL
	PXtPslhc3jWHzeL83+OsDqwefVtWMXp83iTnsenJW6YA5igum5TUnMyy1CJ9uwSujAddbWwF
	W1krpp06yNrAuJWli5GDQ0LARGLvW8kuRk4gU0ziwr31bF2MXBxCAssYJU5+usQOkTCRaPh7
	kgkiMZ1RoqP/KTOE084k8XHWLSaQSWwC2hKHtgWDNIgI6Ej8bjjLAlLDLNDLKHHm2S5WkISw
	gK/EooV/wGwWAVWJd6dXgNm8Au4S15/egtqmILHsy1qwBRICz9kkjp7+wQLRICDxbfIhqLNl
	JTYdYIaol5Q4uOIGywRGwQWMDKsYRVMLkguKk9KLDPWKE3OLS/PS9ZLzczcxQoKxdwfj7QPW
	hxiTgcZNZJYSTc4HBnNeSbyhsZmRhamJqbGRuaUZacJK4rxqLdaBQgLpiSWp2ampBalF8UWl
	OanFhxiZODilGhhtDl9pY1++iaEvJ/px+p6Yn2u0Dsf2etx5fT8+Sqp+2Zo07my9QsHlDYVC
	e6+K//pjl5h3Kv+t55/GHRL8Aj2BnQ0LDy+912VeHdb7k2Haiyspk6s+Rk5jrtwoZZH0/q7W
	CbeoPRMd9Wf/8Zyi4lh2Sk76MpfirqX2f6wrVvjcOH00TbFpn7gSS3FGoqEWc1FxIgCpmJW5
	XAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOIsWRmVeSWpSXmKPExsVy+t9jQd0XszmDDN7OMLU4cbHW4uDsJUwW
	e/aeZLG4vGsOm8X5v8dZHVg9+rasYvT4vEnOY9OTt0wBzFENjDYZqYkpqUUKqXnJ+SmZeem2
	St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QCuVFMoSc0qBQgGJxcVK+naYJoSGuOla
	wDRG6PqGBMH1GBmggYR1jBkPutrYCrayVkw7dZC1gXErSxcjJ4eEgIlEw9+TTBC2mMSFe+vZ
	uhi5OIQEpjNKdPQ/ZYZw2pkkPs66BVTFwcEmoC1xaFswSIOIgI7E74azLCA1zAK9jBJnnu1i
	BUkIC/hKLFr4B8xmEVCVeHd6BZjNK+Aucf3pLXaIbQoSy76sZZ7AyL2AkWEVo2hqQXJBcVJ6
	rqFecWJucWleul5yfu4mRnCwP5PawbiyweIQowAHoxIPr8B7jiAh1sSy4srcQ4wSHMxKIrwn
	dTiDhHhTEiurUovy44tKc1KLDzEmA22fyCwlmpwPjMS8knhDYxMzI0sjM2MTc2Nj0oSVxHkP
	tFoHCgmkJ5akZqemFqQWwWxh4uCUamDMifyvUu3IP1nolbjn3ubLnI/eejQfeP/04bVV8ho2
	padzl/3N2vJpoWTC3audkZUnpY/I/9nXfcjdrF7q1WP/ZYWzd7Q/4Igya2yqvLzvac5+tvt/
	8k0vBR6bbHtraoyG5BvPu/cOHTztL77ww+QXru05Ma9kjZce/b7iReNu1VWhFx4w3K5KVGIp
	zkg01GIuKk4EAFgIFB26AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here, the page has been identified as lowmem already. So, calling
lowmem_page_address() directly is a little cheaper than page_address().

Signed-off-by: Heesub Shin <heesub.shin@samsung.com>
Cc: Dongjun Shin <d.j.shin@samsung.com>
---
 fs/buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 695eb14..ccc2c7b 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1464,7 +1464,7 @@ void set_bh_page(struct buffer_head *bh,
 		 */
 		bh->b_data = (char *)(0 + offset);
 	else
-		bh->b_data = page_address(page) + offset;
+		bh->b_data = lowmem_page_address(page) + offset;
 }
 EXPORT_SYMBOL(set_bh_page);
 
-- 
1.8.3.2

