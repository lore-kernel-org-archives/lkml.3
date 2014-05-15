Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751304AbaEOIkA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 04:40:00 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:63770 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbaEOIj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 04:39:58 -0400
X-AuditID: cbfee61b-b7f766d00000646c-98-53747d59dd8b
From: Weijie Yang <weijie.yang@samsung.com>
To: "'Minchan Kim'" <minchan@kernel.org>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Nitin Gupta'" <ngupta@vflare.org>, "'Bob Liu'" <bob.liu@oracle.com>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Weijie Yang'" <weijie.yang.kh@gmail.com>
Subject: [PATCH] zsmalloc: fixup trivial zs size classes value in comments
Date: Thu, 15 May 2014 16:38:31 +0800
Message-id: <000201cf7019$3e2c7cf0$ba8576d0$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9wGQ0NiGoiIdOUQUmgr44856s2Qw==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsVy+t9jQd3I2pJggzevjSzmrF/DZtF1aiqL
	xeVdc9gsln19z26xoWUWu8WTE/9ZHNg8ds66y+6xaVUnm8eJGb9ZPD4+vcXisfPTZlaPz5vk
	AtiiuGxSUnMyy1KL9O0SuDKa+34yFxxhq2i60cfawDiZtYuRk0NCwERi3vRZLBC2mMSFe+vZ
	uhi5OIQEpjNK/Nu8iB3C+cMo8WjdUzaQKjYBbYm7/RvBukUE1CTWHXzBAlLELHCRUeLG9ZvM
	IAlhAS+JN88uMXYxcnCwCKhKTNjpDBLmFbCTWLRnBhOELSjxY/I9sM3MAuoSk+YtYoaw5SU2
	r3nLDNIqARR/9FcXYpWexOvrB6HKxSU2HrnFMoFRYBaSSbOQTJqFZNIsJC0LGFlWMYqmFiQX
	FCel5xrpFSfmFpfmpesl5+duYgQH/zPpHYyrGiwOMQpwMCrx8DJMLg4WYk0sK67MPcQowcGs
	JMLrWF0SLMSbklhZlVqUH19UmpNafIhRmoNFSZz3YKt1oJBAemJJanZqakFqEUyWiYNTqoHR
	PZJxqo7J5SdXL638l9XAzbf0ygMH45Y9FkbzGtTeNnwpOGnhdUl9vp2a6PzFE87GydsfUW/i
	OLnSsUb8I/uHQ88txNIyVhziquN2OnoixGz6seeqry5vtHOK+fHxIPPBHWV7Oa+5rLz5s+Qi
	W1R/mZHEnyPLHeY2qy/esHXuu036+9iEl1ysVmIpzkg01GIuKk4EAECcCgt6AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to calculation, ZS_SIZE_CLASSES value is 255
on systems with 4K page size, not 254. The old value may
forget count the ZS_MIN_ALLOC_SIZE in.

This patch fixup this trivial issue in the comments.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
---
 mm/zsmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 36b4591..04a6000 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -141,7 +141,7 @@
 #define ZS_MAX_ALLOC_SIZE	PAGE_SIZE
 
 /*
- * On systems with 4K page size, this gives 254 size classes! There is a
+ * On systems with 4K page size, this gives 255 size classes! There is a
  * trader-off here:
  *  - Large number of size classes is potentially wasteful as free page are
  *    spread across these classes
-- 
1.7.10.4


