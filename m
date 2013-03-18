Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469Ab3CRFwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 01:52:16 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:63109 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab3CRFwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 01:52:15 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-67-5146ab8d506c
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: should check the node page was truncated first
Date: Mon, 18 Mar 2013 14:51:29 +0900
Message-id: <1363585889-8286-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrILMWRmVeSWpSXmKPExsVy+t8zI93e1W6BBh+XmFjs2XuSxeLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGX0nPzBWNDGVXHnzla2BsaFHF2MnBwSAiYSj24+Y4Ww
	xSQu3FvP1sXIxSEksIxRYu+PSSwwRasmzWOFSCxilFiwdikjSEJIoI1JYke7excjBwebgLbE
	5v0GIGERAWaJBVPPM4LUMwtMYJT4v+g92CBhAVeJl6e+MoHYLAKqEltOPwabwyvgJnFv7UZG
	iGW6Eqv/P2cHaZYQOMImcX7rBzaIBgGJb5MPsYAskxCQldh0gBmiXlLi4IobLBMYBRcwMqxi
	FE0tSC4oTkovMtUrTswtLs1L10vOz93ECAmuiTsY7x+wPsSYDDRuIrOUaHI+MDjzSuINjc2M
	LExNTI2NzC3NSBNWEudVb7EOFBJITyxJzU5NLUgtii8qzUktPsTIxMEp1cDI0trG8HU9o7iF
	zIWtd+OuVL/Jf5HAvn22R1O7cdeBbK99Wd5vCzgnlOdJR1tqpPixfN7Xe8v5+rmeBLNDy7V/
	SS/6evLf4Tte7mberpEaLP7//gt0zvkrpBbyhP9ETpmYfWLm79xVT6M8ep7NsDoUkss6V2vD
	nSaDO8+Fde137zH5e0/pl54SS3FGoqEWc1FxIgBRmvxNRAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42I5/e+xgG7vardAg33f9C327D3JYnF51xw2
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzek7+YCxo46q4
	c2crWwPjQo4uRk4OCQETiVWT5rFC2GISF+6tZ+ti5OIQEljEKLFg7VJGkISQQBuTxI529y5G
	Dg42AW2JzfsNQMIiAswSC6aeZwSpZxaYwCjxf9F7FpCEsICrxMtTX5lAbBYBVYktpx+DzeEV
	cJO4t3YjI8QyXYnV/5+zT2DkXsDIsIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOHSfSe9g
	XNVgcYhRgINRiYfXgMc1UIg1say4MvcQowQHs5IIb0OIW6AQb0piZVVqUX58UWlOavEhxmSg
	7ROZpUST84FxlVcSb2hsYmZkaWRmYWRibk6asJI478FW60AhgfTEktTs1NSC1CKYLUwcnFIN
	jDy+7au8NT7NE5pyQ3eKJtPqk64mKUXWFWcvnpHLKXyfWGL5M9zyk4rjogVe1jvu7xJ9nHvH
	fUGZXnHVJxXv/6VFd/5kT9bZYGPJyd45Y61xe2yzyQOT6KN1l279CWw3yZbzkNQKdzDTfHHt
	isiSUNsYb6HoyZ+XBTRvq9kwP7aZhY9rW+s9JZbijERDLeai4kQA2V+jtaECAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, f2fs doesn't reclaim any node pages.
However, if we found that a node page was truncated by checking its block
address with zero during f2fs_write_node_page, we should not skip that node
page and return zero to reclaim it.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/node.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 9e6ed67..90221cc 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1097,13 +1097,6 @@ static int f2fs_write_node_page(struct page *page,
 	block_t new_addr;
 	struct node_info ni;
 
-	if (wbc->for_reclaim) {
-		dec_page_count(sbi, F2FS_DIRTY_NODES);
-		wbc->pages_skipped++;
-		set_page_dirty(page);
-		return AOP_WRITEPAGE_ACTIVATE;
-	}
-
 	wait_on_page_writeback(page);
 
 	mutex_lock_op(sbi, NODE_WRITE);
@@ -1118,6 +1111,14 @@ static int f2fs_write_node_page(struct page *page,
 	if (ni.blk_addr == NULL_ADDR)
 		goto out;
 
+	if (wbc->for_reclaim) {
+		dec_page_count(sbi, F2FS_DIRTY_NODES);
+		wbc->pages_skipped++;
+		set_page_dirty(page);
+		mutex_unlock_op(sbi, NODE_WRITE);
+		return AOP_WRITEPAGE_ACTIVATE;
+	}
+
 	set_page_writeback(page);
 
 	/* insert node offset */
-- 
1.8.1.3.566.gaa39828

