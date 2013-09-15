Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022Ab3IOJkD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 05:40:03 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:51322 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab3IOJkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 05:40:01 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] powerpc: Make add_system_ram_resources() __init
Date: Sun, 15 Sep 2013 11:39:36 +0200
Message-Id: <1379237976-3241-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add_system_ram_resources() is a subsys_initcall.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/powerpc/mm/mem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 1cf9c5b..25e0f26 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -498,7 +498,7 @@ void update_mmu_cache(struct vm_area_struct *vma, unsigned long address,
  * System memory should not be in /proc/iomem but various tools expect it
  * (eg kdump).
  */
-static int add_system_ram_resources(void)
+static int __init add_system_ram_resources(void)
 {
 	struct memblock_region *reg;
 
-- 
1.7.9.5

