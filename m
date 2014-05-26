Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbaEZKJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 06:09:05 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:36762 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbaEZKHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 06:07:05 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-20-53831246aed2
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
Subject: [PATCH 5/9] staging: ion: remove order from struct page_info
Date: Mon, 26 May 2014 19:04:57 +0900
Message-id: <1401098701-24049-5-git-send-email-heesub.shin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1401098701-24049-1-git-send-email-heesub.shin@samsung.com>
References: <1401098701-24049-1-git-send-email-heesub.shin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNIsWRmVeSWpSXmKPExsVy+t8zLV03oeZgg0f/uCze/73PZrF94zdW
	i5eHNC0OfrjPYrHnzC92i+bF69ksDs5ewmRx5reuxeVdc9gs1s7fxmZxY3KhxemORawOPB7b
	dm9j9bjc18vkcW/fYRaPnbPusnvcubaHzWP/3DXsHn1bVjF6fN4kF8ARxWWTkpqTWZZapG+X
	wJXRuO8cY8EzgYr3c18yNzC+4+1i5OSQEDCRaPjzgwXCFpO4cG89WxcjF4eQwDJGicnrF7HB
	FB3d9ZsRIjGdUeLTtH4mCKedSeJu33zWLkYODjYBbYlD24JBGkQEjCX6z85iB6lhFpjDLDFl
	6wUmkBphAVeJy4/UQGpYBFQl5l+bD7aZV8Bd4s6upVBXyEmcPDaZFcTmFPCQmPhkDlhcCKjm
	9saHYNdJCFxjl/j+qpcJYpCAxLfJh1hA5ksIyEpsOsAMMUdS4uCKGywTGIUXMDKsYhRNLUgu
	KE5KLzLUK07MLS7NS9dLzs/dxAiJmN4djLcPWB9iTAYaN5FZSjQ5HxhxeSXxhsZmRhamJqbG
	RuaWZqQJK4nzJj1MChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAOOvnhP1OeVdvpdSFnD/5
	vFBP7cRymcl8gUW7PxQqrPQ+zMiQssS13OKAMjO/0PaepVJPO0I+9xoszEjYOyHZ+4S14uvz
	GXmGB3Z4SUstnmz9cO7jSY4ZWekPX9m51c2LMT+ppfQ981hzh0lLmePxhwaugWXuK7LSz/81
	2HHz4Dcew1NtynefKbEUZyQaajEXFScCAACqfzOuAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t9jQV03oeZgg47TbBbv/95ns9i+8Rur
	xctDmhYHP9xnsdhz5he7RfPi9WwWB2cvYbI481vX4vKuOWwWa+dvY7O4MbnQ4nTHIlYHHo9t
	u7exelzu62XyuLfvMIvHzll32T3uXNvD5rF/7hp2j74tqxg9Pm+SC+CIamC0yUhNTEktUkjN
	S85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAE6VkmhLDGnFCgUkFhcrKRv
	h2lCaIibrgVMY4Sub0gQXI+RARpIWMeY0bjvHGPBM4GK93NfMjcwvuPtYuTkkBAwkTi66zcj
	hC0mceHeerYuRi4OIYHpjBKfpvUzQTjtTBJ3++azdjFycLAJaEsc2hYM0iAiYCzRf3YWO0gN
	s8AcZokpWy8wgdQIC7hKXH6kBlLDIqAqMf/afBYQm1fAXeLOrqUsEMvkJE4em8wKYnMKeEhM
	fDIHLC4EVHN740O2CYy8CxgZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEx+MzqR2MKxss
	DjEKcDAq8fAe8G4KFmJNLCuuzD3EKMHBrCTCq8XZHCzEm5JYWZValB9fVJqTWnyIMRnoqonM
	UqLJ+cBUkVcSb2hsYmZkaWRmbGJubEyasJI474FW60AhgfTEktTs1NSC1CKYLUwcnFINjFPT
	iz79+3LnJf/9X/tF7rNs/Ct4bc7ek9kKDKUi99SXdMyf9nLXLCXjiZYaX4QYNNKCHv9j2tF8
	ImMuA9dZpmcM4nNnZbhJ8AVEBnvwy+z+KihyQt+cNXhDfaCW1blktWQr7Qk3FrI1V/yUSSnZ
	tFn7QR3jWXmbrYnWiZvKFmkd3c+5mU0gVYmlOCPRUIu5qDgRADqdcd0LAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ION system heap uses an internal data structure, struct page_info, for
tracking down the meta information of the pages allocated from the pool.
Now that the pool returns compound pages, we don't need to store page
order in struct page_info.

Signed-off-by: Heesub Shin <heesub.shin@samsung.com>
---
 drivers/staging/android/ion/ion_system_heap.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index 48e6a58..73a2e67 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -53,7 +53,6 @@ struct ion_system_heap {
 
 struct page_info {
 	struct page *page;
-	unsigned int order;
 	struct list_head list;
 };
 
@@ -121,7 +120,6 @@ static struct page_info *alloc_largest_available(struct ion_system_heap *heap,
 			continue;
 
 		info->page = page;
-		info->order = orders[i];
 		return info;
 	}
 	kfree(info);
@@ -158,8 +156,8 @@ static int ion_system_heap_allocate(struct ion_heap *heap,
 		if (!info)
 			goto free_pages;
 		list_add_tail(&info->list, &pages);
-		size_remaining -= PAGE_SIZE << info->order;
-		max_order = info->order;
+		size_remaining -= PAGE_SIZE << compound_order(info->page);
+		max_order = compound_order(info->page);
 		i++;
 	}
 	table = kzalloc(sizeof(struct sg_table), GFP_KERNEL);
@@ -172,7 +170,7 @@ static int ion_system_heap_allocate(struct ion_heap *heap,
 	sg = table->sgl;
 	list_for_each_entry_safe(info, tmp_info, &pages, list) {
 		struct page *page = info->page;
-		sg_set_page(sg, page, PAGE_SIZE << info->order, 0);
+		sg_set_page(sg, page, PAGE_SIZE << compound_order(page), 0);
 		sg = sg_next(sg);
 		list_del(&info->list);
 		kfree(info);
@@ -185,7 +183,8 @@ free_table:
 	kfree(table);
 free_pages:
 	list_for_each_entry_safe(info, tmp_info, &pages, list) {
-		free_buffer_page(sys_heap, buffer, info->page, info->order);
+		free_buffer_page(sys_heap, buffer, info->page,
+						compound_order(info->page));
 		kfree(info);
 	}
 	return -ENOMEM;
-- 
1.9.1

