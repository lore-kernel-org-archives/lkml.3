Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932752Ab3KHXrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 18:47:52 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:52868 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932352Ab3KHXns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 18:43:48 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <tj@kernel.org>, <linux-kernel@vger.kernel.org>
CC: <linux-mm@kvack.org>, <linux-arm-kernel@lists.infradead.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 15/24] mm/lib/cpumask: Use memblock apis for early memory allocations
Date: Fri, 8 Nov 2013 18:41:51 -0500
Message-ID: <1383954120-24368-16-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383954120-24368-1-git-send-email-santosh.shilimkar@ti.com>
References: <1383954120-24368-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to memblock interfaces for early memory allocator instead of
bootmem allocator. No functional change in beahvior than what it is
in current code from bootmem users points of view.

Archs already converted to NO_BOOTMEM now directly use memblock
interfaces instead of bootmem wrappers build on top of memblock. And the
archs which still uses bootmem, these new apis just fallback to exiting
bootmem APIs.

Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 lib/cpumask.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/cpumask.c b/lib/cpumask.c
index d327b87..44e492e 100644
--- a/lib/cpumask.c
+++ b/lib/cpumask.c
@@ -140,7 +140,7 @@ EXPORT_SYMBOL(zalloc_cpumask_var);
  */
 void __init alloc_bootmem_cpumask_var(cpumask_var_t *mask)
 {
-	*mask = alloc_bootmem(cpumask_size());
+	*mask = memblock_virt_alloc(cpumask_size());
 }
 
 /**
@@ -161,6 +161,6 @@ EXPORT_SYMBOL(free_cpumask_var);
  */
 void __init free_bootmem_cpumask_var(cpumask_var_t mask)
 {
-	free_bootmem(__pa(mask), cpumask_size());
+	memblock_free_early(__pa(mask), cpumask_size());
 }
 #endif
-- 
1.7.9.5

