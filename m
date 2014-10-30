Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760613AbaJ3Qee (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 12:34:34 -0400
Received: from mail-oi0-f53.google.com ([209.85.218.53]:62548 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758867AbaJ3Qec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 12:34:32 -0400
MIME-Version: 1.0
Date: Fri, 31 Oct 2014 00:34:31 +0800
Message-ID: <CAHkaATTjqpySW2jH-X3g38BpP0AM-+xLsia-G7riit55WeCP8g@mail.gmail.com>
Subject: [PATCH] arm: use phys_addr_t to describe physical address
From: Min-Hua Chen <orca.chen@gmail.com>
To: Russell King <linux@arm.linux.org.uk>,
        Laura Abbott <lauraa@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Use phys_addr_t to describe physical_address. When LPAE
is enabled, physical address can be more than 32 bits, so
we have to use phys_addr_t to handle the case.

Signed-off-by: Min-Hua Chen <orca.chen@gmail.com>
---
 arch/arm/mm/mmu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 9f98cec..858aa11 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -1335,8 +1335,8 @@ static void __init kmap_init(void)
 static void __init map_lowmem(void)
 {
     struct memblock_region *reg;
-    unsigned long kernel_x_start = round_down(__pa(_stext), SECTION_SIZE);
-    unsigned long kernel_x_end = round_up(__pa(__init_end), SECTION_SIZE);
+    phys_addr_t kernel_x_start = round_down(__pa(_stext), SECTION_SIZE);
+    phys_addr_t kernel_x_end = round_up(__pa(__init_end), SECTION_SIZE);

     /* Map all the lowmem memory banks. */
     for_each_memblock(memory, reg) {
--
1.7.10.4

thanks,
Min-Hua
