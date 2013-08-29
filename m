Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314Ab3H2Uxy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 16:53:54 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:42038 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756535Ab3H2Uxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 16:53:52 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lidza Louina <lidza.louina@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH -next] staging: dgap: Add missing #include <linux/slab.h>
Date: Thu, 29 Aug 2013 22:53:25 +0200
Message-Id: <1377809605-27788-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/staging/dgap/dgap_driver.c: In function ‘dgap_cleanup_module’:
drivers/staging/dgap/dgap_driver.c:423: error: implicit declaration of function ‘kfree’
drivers/staging/dgap/dgap_driver.c: In function ‘dgap_driver_kzmalloc’:
drivers/staging/dgap/dgap_driver.c:940: error: implicit declaration of function ‘kmalloc’
drivers/staging/dgap/dgap_driver.c:940: warning: initialization makes pointer from integer without a cast

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
http://kisskb.ellerman.id.au/kisskb/buildresult/9422860/
http://kisskb.ellerman.id.au/kisskb/buildresult/9419277/

 drivers/staging/dgap/dgap_driver.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/dgap/dgap_driver.c b/drivers/staging/dgap/dgap_driver.c
index 9f777e4..724a685 100644
--- a/drivers/staging/dgap/dgap_driver.c
+++ b/drivers/staging/dgap/dgap_driver.c
@@ -36,6 +36,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/delay.h>	/* For udelay */
+#include <linux/slab.h>
 #include <asm/uaccess.h>	/* For copy_from_user/copy_to_user */
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39)
-- 
1.7.9.5

