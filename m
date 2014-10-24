Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbaJXJtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 05:49:20 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:47278 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbaJXJtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 05:49:16 -0400
X-AuditID: cbfee61b-f79d76d0000024d6-41-544a209a3ddc
From: Weijie Yang <weijie.yang@samsung.com>
To: mina86@mina86.com
Cc: m.szyprowski@samsung.com, iamjoonsoo.kim@lge.com,
        aneesh.kumar@linux.vnet.ibm.com,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Linux-MM'" <linux-mm@kvack.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Weijie Yang'" <weijie.yang.kh@gmail.com>
Subject: [PATCH] mm, cma: make parameters order consistent in func declaration
 and definition
Date: Fri, 24 Oct 2014 17:47:57 +0800
Message-id: <000201cfef6f$c5422b10$4fc68130$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/vb5dDYVdBfU4PTMGO+fmmhfksMg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRmVeSWpSXmKPExsVy+t9jAd1ZCl4hBl9mWlnMWb+GzeLx63ks
	Fiu7m9ksLu+aw2Zxb81/Vou1R+6yWyw43sJq8eTEfxYHDo+ds+6ye2z6NIndo+vtFSaPEzN+
	s3g8OLSZxWPdn1dMHn1bVjF6fN4kF8ARxWWTkpqTWZZapG+XwJVx6spE9oKb3BWHf2s0MN7i
	7GLk5JAQMJE4vKCVEcIWk7hwbz1bFyMXh5DAIkaJ1Zd+MEM4fxglrjT+BKtiE9CWuNu/kRXE
	FhEQlXjS0M0CUsQs0MIk8ePiGiaQhLBAvMTeR0vBGlgEVCX2729gAbF5Bewkltw4AmULSvyY
	fA/MZhZQl5g0bxEzhC0vsXnNWyCbA+gkdYlHf3UhdulJbJ7YwwhRIi6x8cgtlgmMArOQTJqF
	ZNIsJJNmIWlZwMiyilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4Sp5J72Bc1WBxiFGAg1GJ
	h/fGDM8QIdbEsuLK3EOMEhzMSiK8s6S9QoR4UxIrq1KL8uOLSnNSiw8xSnOwKInzHmy1DhQS
	SE8sSc1OTS1ILYLJMnFwSjUwTnd7cGiuuMctgf8snqxu+1f416ixz8lzunLO2br68Z8TSyq7
	llVbHb+t+05M59WSmUfLshem9AfvsWSqDG7fwrRM0SZ7A7cef3mcxIHkqgXqgbb7V7zhtF/T
	+3FJrcGnO7cufjlz7cE7s5SXRZstw/tlK9fn8LELX39S80pONqMljNE1ddNBJZbijERDLeai
	4kQAu7TooY4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the current code, the base and size parameters order is not consistent
in functions declaration and definition. If someone calls these functions
according to the declaration parameters order in cma.h, he will run into
some bug and it's hard to find the reason.

This patch makes the parameters order consistent in functions declaration
and definition.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
---
 include/linux/cma.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/cma.h b/include/linux/cma.h
index 0430ed0..a93438b 100644
--- a/include/linux/cma.h
+++ b/include/linux/cma.h
@@ -18,12 +18,12 @@ struct cma;
 extern phys_addr_t cma_get_base(struct cma *cma);
 extern unsigned long cma_get_size(struct cma *cma);
 
-extern int __init cma_declare_contiguous(phys_addr_t size,
-			phys_addr_t base, phys_addr_t limit,
+extern int __init cma_declare_contiguous(phys_addr_t base,
+			phys_addr_t size, phys_addr_t limit,
 			phys_addr_t alignment, unsigned int order_per_bit,
 			bool fixed, struct cma **res_cma);
-extern int cma_init_reserved_mem(phys_addr_t size,
-					phys_addr_t base, int order_per_bit,
+extern int cma_init_reserved_mem(phys_addr_t base,
+					phys_addr_t size, int order_per_bit,
 					struct cma **res_cma);
 extern struct page *cma_alloc(struct cma *cma, int count, unsigned int align);
 extern bool cma_release(struct cma *cma, struct page *pages, int count);
-- 
1.7.0.4


