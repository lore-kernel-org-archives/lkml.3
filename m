Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423064Ab3DFN4f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 09:56:35 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:61715 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422923Ab3DFN4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 09:56:31 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, David Rientjes <rientjes@google.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        David Howells <dhowells@redhat.com>, Mark Salter <msalter@redhat.com>,
        Jianguo Wu <wujianguo@huawei.com>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
Subject: [PATCH v4, part3 06/15] mm, powertv: use free_reserved_area() to simplify code
Date: Sat,  6 Apr 2013 21:55:00 +0800
Message-Id: <1365256509-29024-7-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365256509-29024-1-git-send-email-jiang.liu@huawei.com>
References: <1365256509-29024-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use common help function free_reserved_area() to simplify code.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
---
 arch/mips/powertv/asic/asic_devices.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/arch/mips/powertv/asic/asic_devices.c b/arch/mips/powertv/asic/asic_devices.c
index d38b095..9f64c23 100644
--- a/arch/mips/powertv/asic/asic_devices.c
+++ b/arch/mips/powertv/asic/asic_devices.c
@@ -529,17 +529,8 @@ EXPORT_SYMBOL(asic_resource_get);
  */
 void platform_release_memory(void *ptr, int size)
 {
-	unsigned long addr;
-	unsigned long end;
-
-	addr = ((unsigned long)ptr + (PAGE_SIZE - 1)) & PAGE_MASK;
-	end = ((unsigned long)ptr + size) & PAGE_MASK;
-
-	for (; addr < end; addr += PAGE_SIZE) {
-		ClearPageReserved(virt_to_page(__va(addr)));
-		init_page_count(virt_to_page(__va(addr)));
-		free_page((unsigned long)__va(addr));
-	}
+	free_reserved_area((unsigned long)ptr, (unsigned long)(ptr + size),
+			   -1, NULL);
 }
 EXPORT_SYMBOL(platform_release_memory);
 
-- 
1.7.9.5

