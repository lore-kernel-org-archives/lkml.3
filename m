Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936567AbaFIJcy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:32:54 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59137 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936268AbaFIJ1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:27:08 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Liu Hua <sdu.liu@huawei.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 076/146] ARM: 8012/1: kdump: Avoid overflow when converting pfn to physaddr
Date: Mon,  9 Jun 2014 10:50:11 +0200
Message-Id: <2a714162f8873153edeab6df8c63befa48473337.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Hua <sdu.liu@huawei.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 8fad87bca7ac9737e413ba5f1656f1114a8c314d upstream.

When we configure CONFIG_ARM_LPAE=y, pfn << PAGE_SHIFT will
overflow if pfn >= 0x100000 in copy_oldmem_page.
So use __pfn_to_phys for converting.

Signed-off-by: Liu Hua <sdu.liu@huawei.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm/kernel/crash_dump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kernel/crash_dump.c b/arch/arm/kernel/crash_dump.c
index 90c50d4b43f7..5d1286d51154 100644
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
1.9.3

