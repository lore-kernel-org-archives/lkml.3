Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814AbaGHTjb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:39:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54135 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755691AbaGHTIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Russell King" <rmk+kernel@arm.linux.org.uk>,
        "Liu Hua" <sdu.liu@huawei.com>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.674616034@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 120/125] ARM: 8012/1: kdump: Avoid overflow when
 converting pfn to physaddr
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Hua <sdu.liu@huawei.com>

commit 8fad87bca7ac9737e413ba5f1656f1114a8c314d upstream.

When we configure CONFIG_ARM_LPAE=y, pfn << PAGE_SHIFT will
overflow if pfn >= 0x100000 in copy_oldmem_page.
So use __pfn_to_phys for converting.

Signed-off-by: Liu Hua <sdu.liu@huawei.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/kernel/crash_dump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/kernel/crash_dump.c
+++ b/arch/arm/kernel/crash_dump.c
@@ -39,7 +39,7 @@ ssize_t copy_oldmem_page(unsigned long p
 	if (!csize)
 		return 0;
 
-	vaddr = ioremap(pfn << PAGE_SHIFT, PAGE_SIZE);
+	vaddr = ioremap(__pfn_to_phys(pfn), PAGE_SIZE);
 	if (!vaddr)
 		return -ENOMEM;
 

