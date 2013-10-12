Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab3JLWBn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 18:01:43 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43588 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab3JLWAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 18:00:13 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <tj@kernel.org>, <yinghai@kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <grygorii.strashko@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC 22/23] mm/ARM: mm: Use memblock apis for early memory allocations
Date: Sat, 12 Oct 2013 17:59:05 -0400
Message-ID: <1381615146-20342-23-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381615146-20342-1-git-send-email-santosh.shilimkar@ti.com>
References: <1381615146-20342-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to memblock interfaces for early memory allocator

Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 arch/arm/mm/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index cef338d..091e2c9 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -414,7 +414,7 @@ free_memmap(unsigned long start_pfn, unsigned long end_pfn)
 	 * free the section of the memmap array.
 	 */
 	if (pg < pgend)
-		free_bootmem(pg, pgend - pg);
+		memblock_free_early(pg, pgend - pg);
 }
 
 /*
-- 
1.7.9.5

