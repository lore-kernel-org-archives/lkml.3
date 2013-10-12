Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab3JLWAS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 18:00:18 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36958 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753499Ab3JLV76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 17:59:58 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <tj@kernel.org>, <yinghai@kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <grygorii.strashko@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC 10/23] mm/printk: Use memblock apis for early memory allocations
Date: Sat, 12 Oct 2013 17:58:53 -0400
Message-ID: <1381615146-20342-11-git-send-email-santosh.shilimkar@ti.com>
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

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 kernel/printk/printk.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index b4e8500..8624466 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -757,14 +757,10 @@ void __init setup_log_buf(int early)
 		return;
 
 	if (early) {
-		unsigned long mem;
-
-		mem = memblock_alloc(new_log_buf_len, PAGE_SIZE);
-		if (!mem)
-			return;
-		new_log_buf = __va(mem);
+		new_log_buf =
+			memblock_early_alloc_pages_nopanic(new_log_buf_len);
 	} else {
-		new_log_buf = alloc_bootmem_nopanic(new_log_buf_len);
+		new_log_buf = memblock_early_alloc_nopanic(new_log_buf_len);
 	}
 
 	if (unlikely(!new_log_buf)) {
-- 
1.7.9.5

