Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461Ab3BAUnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 15:43:18 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:21464 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756548Ab3BAUnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 15:43:15 -0500
Message-ID: <201302012043.r11KhFXi024365@farm-0021.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 1 Feb 2013 12:34:18 -0500
Subject: [PATCH] tile: revert pr_info to printk in <asm/io.h>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using pr_info in a header exposes us to potential trouble from
subsystems that define pr_fmt.  This change fixes:

  In file included from include/linux/scatterlist.h:10,
                   from include/scsi/scsi.h:12,
                   from drivers/infiniband/ulp/srp/ib_srp.c:46:
  arch/tile/include/asm/io.h: In function ‘ioport_map’:
  arch/tile/include/asm/io.h:296: error: expected ‘)’ before ‘PFX’

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/io.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/tile/include/asm/io.h b/arch/tile/include/asm/io.h
index 2a9b293..865e529 100644
--- a/arch/tile/include/asm/io.h
+++ b/arch/tile/include/asm/io.h
@@ -292,7 +292,7 @@ static inline long ioport_panic(void)
 
 static inline void __iomem *ioport_map(unsigned long port, unsigned int len)
 {
-	pr_info("ioport_map: mapping IO resources is unsupported on tile.\n");
+	printk("ioport_map: mapping IO resources is unsupported on tile.\n");
 	return NULL;
 }
 
-- 
1.7.10.3

