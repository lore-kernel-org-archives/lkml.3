Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599Ab3KHXtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 18:49:20 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:57483 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758533Ab3KHXnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 18:43:33 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <tj@kernel.org>, <linux-kernel@vger.kernel.org>
CC: <linux-mm@kvack.org>, <linux-arm-kernel@lists.infradead.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH 03/24] mm/bootmem: remove duplicated declaration of __free_pages_bootmem()
Date: Fri, 8 Nov 2013 18:41:39 -0500
Message-ID: <1383954120-24368-4-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383954120-24368-1-git-send-email-santosh.shilimkar@ti.com>
References: <1383954120-24368-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

The __free_pages_bootmem is used internally by MM core and
already defined in internal.h. So, remove duplicated declaration.

Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 include/linux/bootmem.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/bootmem.h b/include/linux/bootmem.h
index f1f07d3..55d52fb 100644
--- a/include/linux/bootmem.h
+++ b/include/linux/bootmem.h
@@ -52,7 +52,6 @@ extern void free_bootmem_node(pg_data_t *pgdat,
 			      unsigned long size);
 extern void free_bootmem(unsigned long physaddr, unsigned long size);
 extern void free_bootmem_late(unsigned long physaddr, unsigned long size);
-extern void __free_pages_bootmem(struct page *page, unsigned int order);
 
 /*
  * Flags for reserve_bootmem (also if CONFIG_HAVE_ARCH_BOOTMEM_NODE,
-- 
1.7.9.5

