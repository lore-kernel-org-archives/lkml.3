Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbaCRK1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 06:27:25 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:37654 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793AbaCRK1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 06:27:22 -0400
From: Liu Hua <sdu.liu@huawei.com>
To: <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <peifeiyue@huawei.com>, <wangnan0@huawei.com>,
        Liu Hua <sdu.liu@huawei.com>
Subject: [PATCH] ARM: kdump: Avoid overflow when converting pfn to physaddr
Date: Tue, 18 Mar 2014 18:20:42 +0800
Message-ID: <1395138042-62364-1-git-send-email-sdu.liu@huawei.com>
X-Mailer: git-send-email 1.8.5.5.dirty
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we configure CONFIG_LPAE=y, pfn << PAGE_SHIFT will
overflow if pfn >= 0x100000 in copy_oldmem_page.

So use __pfn_to_phys for converting.

Signed-off-by: Liu Hua <sdu.liu@huawei.com>
---
 arch/arm/kernel/crash_dump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kernel/crash_dump.c b/arch/arm/kernel/crash_dump.c
index 90c50d4..5d1286d 100644
--- a/arch/arm/kernel/crash_dump.c
+++ b/arch/arm/kernel/crash_dump.c
@@ -39,7 +39,7 @@ ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
 	if (!csize)
 		return 0;
 
-	vaddr = ioremap(pfn << PAGE_SHIFT, PAGE_SIZE);
+	vaddr = ioremap(__pfn_to_phys(pfn), PAGE_SIZE);
 	if (!vaddr)
 		return -ENOMEM;
 
-- 
1.8.5.5.dirty

