Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262AbaE3B0J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 21:26:09 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:65469 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831AbaE3B0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 21:26:05 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-46-5387de2bfdd4
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
Subject: [PATCH v2 RESEND 1/4] staging: ion: remove order from struct page_info
Date: Fri, 30 May 2014 10:26:27 +0900
Message-id: <1401413190-13514-1-git-send-email-heesub.shin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <20140529204208.GA2120@kroah.com>
References: <20140529204208.GA2120@kroah.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLIsWRmVeSWpSXmKPExsVy+t8zPV3te+3BBk+faFu8/3ufzWL7xm+s
	Fi8PaVqcuFhrcfDDfRaLPWd+sVs0L17PZnFw9hImizO/dS0u75rDZrF2/jY2ixuTCy1Odyxi
	deD12LZ7G6vH5b5eJo97+w6zeOycdZfd4861PWwe++euYffo27KK0ePzJrkAjigum5TUnMyy
	1CJ9uwSujAcf3jEWXBSs6N2X2sB4nq+LkZNDQsBEovv2Z2YIW0ziwr31bCC2kMAyRonryyth
	anZt/s4KEZ/OKDHrhkIXIxeQ3c4k8XP/Q8YuRg4ONgFtiUPbgkFqRASMJfrPzmIHqWEWOMws
	0TVrLdhQYQF/iV8L9oMNYhFQlVg6dwdYnFfAXeL0hy4miGVyEiePTQar4RTQk9h9ZgsjxGJd
	iRO929lAhkoIXGOX6Ft+ihlikIDEt8mHWECOkBCQldh0AOoZSYmDK26wTGAUXsDIsIpRNLUg
	uaA4Kb3ISK84Mbe4NC9dLzk/dxMjJGr6djDePGB9iDEZaNxEZinR5Hxg1OWVxBsamxlZmJqY
	GhuZW5qRJqwkzrvoYVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBkZbWRmdXRrT1fs0/F/k
	b33+fJvXkkSdDZOm+QrmRVs6X17KEhUWds1bf8ni6yx9vesmLn/9dGMMv7fup9Q9nsubZlXP
	3+JTsr91F2P9t+2bCxsXHXz1eJ6SBQ/TMzupo+VhgsdnGXolfbuS8unyphc3Lhe6bd5/ZYF1
	iFpU7ZGVjN7rDz7RO5GgxFKckWioxVxUnAgAwtFKmbACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t9jQV3te+3BBjuvqVm8/3ufzWL7xm+s
	Fi8PaVqcuFhrcfDDfRaLPWd+sVs0L17PZnFw9hImizO/dS0u75rDZrF2/jY2ixuTCy1Odyxi
	deD12LZ7G6vH5b5eJo97+w6zeOycdZfd4861PWwe++euYffo27KK0ePzJrkAjqgGRpuM1MSU
	1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoIOVFMoSc0qBQgGJ
	xcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBkPPrxjLLgoWNG7L7WB8TxfFyMnh4SAicSu
	zd9ZIWwxiQv31rOB2EIC0xklZt1Q6GLkArLbmSR+7n/I2MXIwcEmoC1xaFswSI2IgLFE/9lZ
	7CA1zAKHmSW6Zq0FaxYW8Jf4tWA/2FAWAVWJpXN3gMV5BdwlTn/oYoJYJidx8thksBpOAT2J
	3We2MEIs1pU40budbQIj7wJGhlWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwVH5TGoH48oG
	i0OMAhyMSjy8jZHtwUKsiWXFlbmHGCU4mJVEeB0PA4V4UxIrq1KL8uOLSnNSiw8xJgNdNZFZ
	SjQ5H5gw8kriDY1NzIwsjcyMTcyNjUkTVhLnPdBqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBMVc6
	/COj3t18O55C8xmvrfRE7rB3C9zlmbsreomcO9NEGaP3hh95jBiMEv4y/WhT+fXN7rPbYq75
	ytNkmiZs/7j9ec+jb6raZmJZ8ue6PpcmLfr0/LuUZunBWcu6m/I8ylb84fh8Za9Y1/qTP66e
	aImxflC/t9MoblqgZE3GpQObhSO2M8h4KrEUZyQaajEXFScCAOU7SJQOAwAA
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
Reviewed-by: Mitchel Humpherys <mitchelh@codeaurora.org>
Tested-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_system_heap.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index cb7ae08..621b857 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -54,7 +54,6 @@ struct ion_system_heap {
 
 struct page_info {
 	struct page *page;
-	unsigned int order;
 	struct list_head list;
 };
 
@@ -123,7 +122,6 @@ static struct page_info *alloc_largest_available(struct ion_system_heap *heap,
 			continue;
 
 		info->page = page;
-		info->order = orders[i];
 		return info;
 	}
 	kfree(info);
@@ -160,8 +158,8 @@ static int ion_system_heap_allocate(struct ion_heap *heap,
 		if (!info)
 			goto free_pages;
 		list_add_tail(&info->list, &pages);
-		size_remaining -= PAGE_SIZE << info->order;
-		max_order = info->order;
+		size_remaining -= PAGE_SIZE << compound_order(info->page);
+		max_order = compound_order(info->page);
 		i++;
 	}
 	table = kmalloc(sizeof(struct sg_table), GFP_KERNEL);
@@ -174,7 +172,7 @@ static int ion_system_heap_allocate(struct ion_heap *heap,
 	sg = table->sgl;
 	list_for_each_entry_safe(info, tmp_info, &pages, list) {
 		struct page *page = info->page;
-		sg_set_page(sg, page, PAGE_SIZE << info->order, 0);
+		sg_set_page(sg, page, PAGE_SIZE << compound_order(page), 0);
 		sg = sg_next(sg);
 		list_del(&info->list);
 		kfree(info);
@@ -187,7 +185,8 @@ free_table:
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

