Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbaLJCJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 21:09:26 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:48990 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136AbaLJCJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 21:09:20 -0500
Message-ID: <5487AB3F.7050807@huawei.com>
Date: Wed, 10 Dec 2014 10:09:03 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        <dave@sr71.net>, Rik van Riel <riel@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
CC: <linux-tip-commits@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, Xishi Qiu <qiuxishi@huawei.com>
Subject: [PATCH V3 2/2] x86/mm: use min instead of min_t
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.25.179]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The type of "MAX_DMA_PFN" and "xXx_pfn" are both unsigned long now, so use
min() instead of min_t().

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
---
 arch/x86/kernel/e820.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 49f8864..dd2f07a 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1114,8 +1114,8 @@ void __init memblock_find_dma_reserve(void)
 	 * at first, and assume boot_mem will not take below MAX_DMA_PFN
 	 */
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, NULL) {
-		start_pfn = min_t(unsigned long, start_pfn, MAX_DMA_PFN);
-		end_pfn = min_t(unsigned long, end_pfn, MAX_DMA_PFN);
+		start_pfn = min(start_pfn, MAX_DMA_PFN);
+		end_pfn = min(end_pfn, MAX_DMA_PFN);
 		nr_pages += end_pfn - start_pfn;
 	}
 
-- 
2.0.0

