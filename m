Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200Ab3HMDDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 23:03:19 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:60605 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756352Ab3HMDDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 23:03:18 -0400
Message-ID: <5209A173.3090600@huawei.com>
Date: Tue, 13 Aug 2013 11:01:07 +0800
From: Jianguo Wu <wujianguo@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, <tglx@linutronix.de>
CC: <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, <linux-mm@kvack.org>, <wangchen@cn.fujitsu.com>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH] mm: remove unnecessary variable idx0 in __early_ioremap()
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.216]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit 8827247ffcc(x86: don't define __this_fixmap_does_not_exist()),
variable idx0 is no longer needed, so just remove it.

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
---
 arch/x86/mm/ioremap.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 0215e2c..799580c 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -487,7 +487,7 @@ __early_ioremap(resource_size_t phys_addr, unsigned long size, pgprot_t prot)
 	unsigned long offset;
 	resource_size_t last_addr;
 	unsigned int nrpages;
-	enum fixed_addresses idx0, idx;
+	enum fixed_addresses idx;
 	int i, slot;
 
 	WARN_ON(system_state != SYSTEM_BOOTING);
@@ -540,8 +540,7 @@ __early_ioremap(resource_size_t phys_addr, unsigned long size, pgprot_t prot)
 	/*
 	 * Ok, go for it..
 	 */
-	idx0 = FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*slot;
-	idx = idx0;
+	idx = FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*slot;
 	while (nrpages > 0) {
 		early_set_fixmap(idx, phys_addr, prot);
 		phys_addr += PAGE_SIZE;
-- 
1.7.1


