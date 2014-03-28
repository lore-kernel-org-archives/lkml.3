Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbaC1RoI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 13:44:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51361 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbaC1RbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:31:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Peddell <klightspeed@killerwolves.net>,
        Jason Cooper <jason@lakedaemon.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 3.13 19/46] ARM: 7941/2: Fix incorrect FDT initrd parameter override
Date: Fri, 28 Mar 2014 10:32:03 -0700
Message-Id: <20140328173137.262946975@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140328173134.630198216@linuxfoundation.org>
References: <20140328173134.630198216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Peddell <klightspeed@killerwolves.net>

commit 4c235cb9e35407bdb4a2debeef4dc8721e8f91f2 upstream.

Commit 65939301acdb (arm: set initrd_start/initrd_end for fdt scan)
caused the FDT initrd_start and initrd_end to override the
phys_initrd_start and phys_initrd_size set by the initrd= kernel
parameter.  With this patch initrd_start and initrd_end will be
overridden if phys_initrd_start and phys_initrd_size are set by the
kernel initrd= parameter.

Fixes: 65939301acdb (arm: set initrd_start/initrd_end for fdt scan)

Signed-off-by: Ben Peddell <klightspeed@killerwolves.net>
Acked-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mm/init.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -345,10 +345,11 @@ void __init arm_memblock_init(struct mem
 #endif
 #ifdef CONFIG_BLK_DEV_INITRD
 	/* FDT scan will populate initrd_start */
-	if (initrd_start) {
+	if (initrd_start && !phys_initrd_size) {
 		phys_initrd_start = __virt_to_phys(initrd_start);
 		phys_initrd_size = initrd_end - initrd_start;
 	}
+	initrd_start = initrd_end = 0;
 	if (phys_initrd_size &&
 	    !memblock_is_region_memory(phys_initrd_start, phys_initrd_size)) {
 		pr_err("INITRD: 0x%08llx+0x%08lx is not a memory region - disabling initrd\n",


