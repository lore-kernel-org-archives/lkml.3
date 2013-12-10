Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751094Ab3LJTaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 14:30:35 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33482 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707Ab3LJTad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 14:30:33 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH 2/2] mm/memblock: fix buld of "cris" arch
Date: Tue, 10 Dec 2013 14:29:58 -0500
Message-ID: <1386703798-26521-3-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386703798-26521-1-git-send-email-santosh.shilimkar@ti.com>
References: <1386703798-26521-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

The build of "criss" arch is broken after applying new memblock API
series.

In file included from arch/cris/mm/init.c:13:0:
include/linux/bootmem.h: In function 'memblock_virt_alloc':
include/linux/bootmem.h:229:55: error: 'KSEG_C' undeclared (first use in this function)
include/linux/bootmem.h:229:55: note: each undeclared identifier is reported only once for each function it appears in
include/linux/bootmem.h: In function 'memblock_virt_alloc_nopanic':
include/linux/bootmem.h:237:63: error: 'KSEG_C' undeclared (first use in this function)
include/linux/bootmem.h: In function 'memblock_virt_alloc_node':
include/linux/bootmem.h:250:27: error: 'KSEG_C' undeclared (first use in this function)
include/linux/bootmem.h: In function 'memblock_virt_alloc_node_nopanic':
include/linux/bootmem.h:258:28: error: 'KSEG_C' undeclared (first use in this function)

In file included from mm/bootmem.c:14:0:
include/linux/bootmem.h: In function 'memblock_virt_alloc':
include/linux/bootmem.h:229:55: error: 'KSEG_C' undeclared (first use in this function)
include/linux/bootmem.h:229:55: note: each undeclared identifier is reported only once for each function it appears in
include/linux/bootmem.h: In function 'memblock_virt_alloc_nopanic':
include/linux/bootmem.h:237:63: error: 'KSEG_C' undeclared (first use in this function)
include/linux/bootmem.h: In function 'memblock_virt_alloc_node':
include/linux/bootmem.h:250:27: error: 'KSEG_C' undeclared (first use in this function)

The "cris" arch defines memory parameters in a different manner than other
arch's and they are splitted between 2 headers: <asm/page.h> and <asm/mmu.h>

As result, now build is failed if "bootmem.h" included before
<asm/page.h> and <asm/mmu.h>. Hence, fix it by including additional
header in bootmem.h.

Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 include/linux/bootmem.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/bootmem.h b/include/linux/bootmem.h
index 1c9aa0e..2fae55d 100644
--- a/include/linux/bootmem.h
+++ b/include/linux/bootmem.h
@@ -5,6 +5,7 @@
 #define _LINUX_BOOTMEM_H
 
 #include <linux/mmzone.h>
+#include <linux/mm_types.h>
 #include <asm/dma.h>
 
 /*
-- 
1.7.9.5

