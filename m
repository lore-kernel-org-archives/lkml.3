Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab3LTP1E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 10:27:04 -0500
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:39660 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320Ab3LTP0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 10:26:41 -0500
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
To: fengguang.wu@intel.com
Cc: jim.epost@gmail.com, sfr@canb.auug.org.au, gregkh@linuxfoundation.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        kbuild-all@01.org, haver@linux.vnet.ibm.com
Subject: [PATCH 2/2] GenWQE: Replace dynamic_hex_dump with print_hex_dump_debug
Date: Fri, 20 Dec 2013 16:26:11 +0100
Message-Id: <1387553171-31469-2-git-send-email-haver@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <CA+r1Zhimt7Xusnc4kkkVqfoRhfZRnreMmZqaN7WP7rSpZ3XTvw@mail.gmail.com>
References: <CA+r1Zhimt7Xusnc4kkkVqfoRhfZRnreMmZqaN7WP7rSpZ3XTvw@mail.gmail.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13122015-6892-0000-0000-00000748334B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As requested by Greg, replacing the hexdump function from dynamic_debug.h
with one defined in printk.h. I hope I picked the right one.

Signed-off-by: Frank Haverkamp <haver@linux.vnet.ibm.com>
---
 drivers/misc/genwqe/genwqe_driver.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/misc/genwqe/genwqe_driver.h
+++ b/drivers/misc/genwqe/genwqe_driver.h
@@ -31,7 +31,7 @@
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
 #include <linux/platform_device.h>
-#include <linux/dynamic_debug.h>
+#include <linux/printk.h>
 
 #include <asm/byteorder.h>
 #include <linux/genwqe/genwqe_card.h>
@@ -69,7 +69,9 @@ static inline void genwqe_hexdump(struct
 
 	scnprintf(prefix, sizeof(prefix), "%s %s: ",
 		  GENWQE_DEVNAME, pci_name(pci_dev));
-	dynamic_hex_dump(prefix, DUMP_PREFIX_OFFSET, 16, 1, buff, size, true);
+
+	print_hex_dump_debug(prefix, DUMP_PREFIX_OFFSET, 16, 1, buff,
+			     size, true);
 }
 
 #endif	/* __GENWQE_DRIVER_H__ */

