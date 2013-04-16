Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964873Ab3DPBob (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 21:44:31 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:36095 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934863Ab3DPBoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 21:44:30 -0400
Date: Tue, 16 Apr 2013 09:44:11 +0800
From: Wang YanQing <udknight@gmail.com>
To: rafael.j.wysocki@intel.com
Cc: yinghai@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH]drivers:acpi: Fix wrong parameter passed to memblock_reserve
Message-ID: <20130416014411.GA14671@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	rafael.j.wysocki@intel.com, yinghai@kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The parameter of memblock_reserve is start address,
and size, not address range.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 drivers/acpi/osl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 586e7e9..bcb7a3b 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -641,7 +641,7 @@ void __init acpi_initrd_override(void *data, size_t size)
 	 * Both memblock_reserve and e820_add_region (via arch_reserve_mem_area)
 	 * works fine.
 	 */
-	memblock_reserve(acpi_tables_addr, acpi_tables_addr + all_tables_size);
+	memblock_reserve(acpi_tables_addr, all_tables_size);
 	arch_reserve_mem_area(acpi_tables_addr, all_tables_size);
 
 	p = early_ioremap(acpi_tables_addr, all_tables_size);
-- 
1.7.12.4.dirty
