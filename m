Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932744AbaFTCp0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 22:45:26 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:40003 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755641AbaFTCpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 22:45:25 -0400
X-AuditID: cbfee68f-b7fef6d000003970-cf-53a3a043bc28
From: Heesub Shin <heesub.shin@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Colin Cross <ccross@android.com>,
        Mitchel Humpherys <mitchelh@codeaurora.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Heesub Shin <heesub.shin@samsung.com>
Subject: [PATCH] staging: ion: fixup invalid kfree() calls on heap destroy
Date: Fri, 20 Jun 2014 11:46:14 +0900
Message-id: <1403232374-771-1-git-send-email-heesub.shin@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t8zPV3nBYuDDW5vN7PYvvEbq8XLQ5oW
	e878YrdoXryezeLg7CVMFmd+61pc3jWHzWLt/G1sFjcmFzpwemzbvY3V43JfL5PHvX2HWTzu
	XNvD5rF/7hp2j74tqxg9Pm+SC2CP4rJJSc3JLEst0rdL4Mr4d7iVteAse8X2pQUNjLvZuhjZ
	OSQETCR+WXQxcgJZYhIX7q0HinJxCAksY5TYdf07E0TCROLmjV42EFtIYDqjxJK9uhBF7UwS
	16a3s3YxcnCwCWhLHNoWDFIjImAs0X92FjtIDbNAN5PEse1LwJqFBbwkHn2dxQhiswioSlx+
	9ZYJpJdXwFXicJslxC45iZPHJrOC9EoITGeXmLFxIitEvYDEt8mHWEDqJQRkJTYdYIaol5Q4
	uOIGywRGwQWMDKsYRVMLkguKk9KLjPWKE3OLS/PS9ZLzczcxQgK6fwfj3QPWhxiTgcZNZJYS
	Tc4HRkReSbyhsZmRhamJqbGRuaUZacJK4rz3HyYFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCU
	amD0ETb7u/nuNLGOL5abXi4oCMiMsdxwucJBcfWW9TX/Z5YceXFtrd1dXdWY2piyX1fO2wca
	NX1JfHqsKlp+u9zt3bvSkjiWq3Px/jli9OHUct62iaE6DJN2f9ZvOqNhe73Ta5WeZss1ywub
	mk9OUt+qYF04i8dz/7V3rRO/JKz4+Cwsc07atpw5SizFGYmGWsxFxYkA5IkrWn4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t9jQV3nBYuDDWa/MLTYvvEbq8XLQ5oW
	e878YrdoXryezeLg7CVMFmd+61pc3jWHzWLt/G1sFjcmFzpwemzbvY3V43JfL5PHvX2HWTzu
	XNvD5rF/7hp2j74tqxg9Pm+SC2CPamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0
	MFdSyEvMTbVVcvEJ0HXLzAE6TEmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpI
	WMeY8e9wK2vBWfaK7UsLGhh3s3UxcnJICJhI3LzRC2WLSVy4tx7MFhKYziixZK9uFyMXkN3O
	JHFtejtrFyMHB5uAtsShbcEgNSICxhL9Z2exg9QwC3QzSRzbvgSsWVjAS+LR11mMIDaLgKrE
	5VdvmUB6eQVcJQ63WULskpM4eWwy6wRG7gWMDKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcx
	gmPmmdQOxpUNFocYBTgYlXh4O0wXBwuxJpYVV+YeYpTgYFYS4WWbBhTiTUmsrEotyo8vKs1J
	LT7EmAy0fCKzlGhyPjCe80riDY1NzIwsjcyMTcyNjUkTVhLnPdBqHSgkkJ5YkpqdmlqQWgSz
	hYmDU6qB0dm15UFc05HJXT/lwy12aN6f0yqrtcy//kCbv5US800HL/s2PY2n1oFme6vzy1vF
	V9Zuv9C0xI2PO4LlqLhgbrHV82cnrI23frDxDvhqv+HF6WX7Jx+5tZIxsGHhk6O5S7edFN3C
	MZX1GKvkAY3q5N3qXd7++ZM1vix60mLmMO3yEo/U+cfuK7EUZyQaajEXFScCABxSlDzdAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've noticed that the last commit to ion_system_heap.c ('staging: ion:
optimize struct ion_system_heap') has an omission, so an invalid kfree()
gets called on ion_system_heap_destroy(). As ION system heap is never
destroyed until system shutdown, it may not cause any harm, but should
be fixed. I should have caught this before the merge, my bad.

Signed-off-by: Heesub Shin <heesub.shin@samsung.com>
---
 drivers/staging/android/ion/ion_system_heap.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index c826b4c..6b77c51 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -304,7 +304,6 @@ void ion_system_heap_destroy(struct ion_heap *heap)
 
 	for (i = 0; i < num_orders; i++)
 		ion_page_pool_destroy(sys_heap->pools[i]);
-	kfree(sys_heap->pools);
 	kfree(sys_heap);
 }
 
-- 
1.9.1

