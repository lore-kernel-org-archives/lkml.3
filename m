Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab3HNF4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 01:56:06 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50448 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab3HNFzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 01:55:32 -0400
X-AuditID: 9c930179-b7c0bae0000040ac-be-520b1bd246e3
From: Minchan Kim <minchan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Luigi Semenzato <semenzato@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>
Subject: [PATCH v6 4/5] mm: export unmap_kernel_range
Date: Wed, 14 Aug 2013 14:55:35 +0900
Message-Id: <1376459736-7384-5-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376459736-7384-1-git-send-email-minchan@kernel.org>
References: <1376459736-7384-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now zsmalloc needs exported unmap_kernel_range for building it
as module. In detail, here it is.
https://lkml.org/lkml/2013/1/18/487

We didn't send patch to make unmap_kernel_range exportable at that time.
Because zram is staging stuff and we didn't think make VM function
exportable for staging stuff makes sense so we decided giving up build=m
for zsmalloc but zsmalloc moved under zram directory so if we can't build
zsmalloc as module, it means we can't build zram as module, either.
In addition, another reason we should export it is that buddy map_vm_area
is already exported.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/vmalloc.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 93d3182..0e9a9f8 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1254,6 +1254,7 @@ void unmap_kernel_range(unsigned long addr, unsigned long size)
 	vunmap_page_range(addr, end);
 	flush_tlb_kernel_range(addr, end);
 }
+EXPORT_SYMBOL_GPL(unmap_kernel_range);
 
 int map_vm_area(struct vm_struct *area, pgprot_t prot, struct page ***pages)
 {
-- 
1.7.9.5

