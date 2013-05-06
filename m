Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757855Ab3EFVAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 17:00:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59224 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756545Ab3EFUqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 16:46:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wang YanQing <udknight@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 076/115] ACPI: Fix wrong parameter passed to memblock_reserve
Date: Mon,  6 May 2013 13:45:12 -0700
Message-Id: <20130506203103.358845922@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506203055.537199268@linuxfoundation.org>
References: <20130506203055.537199268@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang YanQing <udknight@gmail.com>

commit a6432ded299726f123b93d0132fead200551535c upstream.

Commit 53aac44 (ACPI: Store valid ACPI tables passed via early initrd
in reserved memblock areas) introduced acpi_initrd_override() that
passes a wrong value as the second argument to memblock_reserve().

Namely, the second argument of memblock_reserve() is the size of the
region, not the address of the top of it, so make
acpi_initrd_override() pass the size in there as appropriate.

[rjw: Changelog]
Signed-off-by: Wang YanQing <udknight@gmail.com>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/osl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -641,7 +641,7 @@ void __init acpi_initrd_override(void *d
 	 * Both memblock_reserve and e820_add_region (via arch_reserve_mem_area)
 	 * works fine.
 	 */
-	memblock_reserve(acpi_tables_addr, acpi_tables_addr + all_tables_size);
+	memblock_reserve(acpi_tables_addr, all_tables_size);
 	arch_reserve_mem_area(acpi_tables_addr, all_tables_size);
 
 	p = early_ioremap(acpi_tables_addr, all_tables_size);


