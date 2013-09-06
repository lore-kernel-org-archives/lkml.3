Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750796Ab3IFFRX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 01:17:23 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:65385 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab3IFFRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 01:17:22 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-38-5229655f6b49
From: Weijie Yang <weijie.yang@samsung.com>
To: sjenning@linux.vnet.ibm.com
Cc: minchan@kernel.org, bob.liu@oracle.com, weijie.yang.kh@gmail.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/4] mm/zswap: use GFP_NOIO instead of GFP_KERNEL
Date: Fri, 06 Sep 2013 13:16:45 +0800
Message-id: <000601ceaac0$5be39f90$13aadeb0$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6qwEVfWiEnSfrtSbWhZuJCIZZN+Q==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t9jQd34VM0ggzULtC26Tk1lsbi8aw6b
	xb01/1ktln19z25xaN8qdosnJ/6zOLB57Jx1l91j06pONo9Nnyaxezw4tJnF4+PTWywenzfJ
	BbBFcdmkpOZklqUW6dslcGW8efKGuWApZ8XlHbkNjEvZuxg5OSQETCRmT2xlgbDFJC7cW8/W
	xcjFISQwnVFixr8dYEVCAn8YJX6vywex2QS0Je72b2QFsUUE5CV2f/sOZjMLVEg8n/aduYuR
	g0NYwEVi+xc5kDCLgKrEsu+b2UBsXgE7iam7nrJA2IISPybfYwEpZxZQl5gyJRdiirzE5jVv
	waZIAIUf/dWFWKQncXvRZGaIEnGJjUdusUxgFJiFZNAshEGzkAyahaRjASPLKkbR1ILkguKk
	9FxDveLE3OLSvHS95PzcTYzgkH8mtYNxZYPFIUYBDkYlHl6OHo0gIdbEsuLK3EOMEhzMSiK8
	4hqaQUK8KYmVValF+fFFpTmpxYcYpTlYlMR5D7RaBwoJpCeWpGanphakFsFkmTg4pRoYdzOW
	Bj4U+R+gwv44/Ojtta45/+fG88qesRFaHPL/wQn2A2Ib3ivvntXQmeN2M49rZoLUoinv3v0x
	+RA5S/1l1YWCaNMTXA8Xb3dhPjDh0/FDUlKWZ+bpTFITcP39PXT5nDmi6TEKSQejtxf32qT2
	+yu9iFzWVJrSXPMt9s6dYwt/n70hOs//qBJLcUaioRZzUXEiACv6rlV1AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid zswap store and reclaim functions called recursively,
use GFP_NOIO instead of GFP_KERNEL

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
---
 mm/zswap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index cc40e6a..3d05ed8 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -427,7 +427,7 @@ static int zswap_get_swap_cache_page(swp_entry_t entry,
 		 * Get a new page to read into from swap.
 		 */
 		if (!new_page) {
-			new_page = alloc_page(GFP_KERNEL);
+			new_page = alloc_page(GFP_NOIO);
 			if (!new_page)
 				break; /* Out of memory */
 		}
@@ -435,7 +435,7 @@ static int zswap_get_swap_cache_page(swp_entry_t entry,
 		/*
 		 * call radix_tree_preload() while we can wait.
 		 */
-		err = radix_tree_preload(GFP_KERNEL);
+		err = radix_tree_preload(GFP_NOIO);
 		if (err)
 			break;
 
@@ -636,7 +636,7 @@ static int zswap_frontswap_store(unsigned type, pgoff_t offset,
 	}
 
 	/* allocate entry */
-	entry = zswap_entry_cache_alloc(GFP_KERNEL);
+	entry = zswap_entry_cache_alloc(GFP_NOIO);
 	if (!entry) {
 		zswap_reject_kmemcache_fail++;
 		ret = -ENOMEM;
-- 
1.7.10.4


