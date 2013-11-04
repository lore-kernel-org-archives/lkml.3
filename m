Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab3KDRIZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 12:08:25 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:44473 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab3KDRIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 12:08:22 -0500
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, gregkh@linuxfoundation.org, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de,
        haver@linux.vnet.ibm.com
Subject: [PATCH 2/9] GenWQE: Remove option to select name
Date: Mon,  4 Nov 2013 18:08:02 +0100
Message-Id: <1383584889-21594-3-git-send-email-haver@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1383584889-21594-1-git-send-email-haver@linux.vnet.ibm.com>
References: <1383584889-21594-1-git-send-email-haver@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110417-2966-0000-0000-0000093F3191
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Selecting interface names via configuration option is obsolete.

Signed-off-by: Frank Haverkamp <haver@linux.vnet.ibm.com>
---
 drivers/misc/genwqe/Kconfig        |   14 ++------------
 include/linux/genwqe/genwqe_card.h |    6 +-----
 2 files changed, 3 insertions(+), 17 deletions(-)

diff --git a/drivers/misc/genwqe/Kconfig b/drivers/misc/genwqe/Kconfig
index bbf137d..6069d8c 100644
--- a/drivers/misc/genwqe/Kconfig
+++ b/drivers/misc/genwqe/Kconfig
@@ -9,15 +9,5 @@ menuconfig GENWQE
 	default n
 	help
 	  Enables PCIe card driver for IBM GenWQE accelerators.
-          The user-space interface is described in
-          include/linux/genwqe/genwqe_card.h.
-
-if GENWQE
-
-config GENWQE_DEVNAME
-        string "Name for sysfs and device nodes"
-	default "genwqe"
-        help
-          Select alternate name for sysfs and device nodes.
-
-endif
+	  The user-space interface is described in
+	  include/linux/genwqe/genwqe_card.h.
diff --git a/include/linux/genwqe/genwqe_card.h b/include/linux/genwqe/genwqe_card.h
index 2c33db1..ffed142 100644
--- a/include/linux/genwqe/genwqe_card.h
+++ b/include/linux/genwqe/genwqe_card.h
@@ -41,11 +41,7 @@
 #endif
 
 /* Basename of sysfs, debugfs and /dev interfaces */
-#if defined(CONFIG_GENWQE_DEVNAME)
-#  define GENWQE_DEVNAME CONFIG_GENWQE_DEVNAME
-#else
-#  define GENWQE_DEVNAME "genwqe"
-#endif
+#define GENWQE_DEVNAME "genwqe"
 
 #define GENWQE_TYPE_ALTERA_230		0x00 /* GenWQE4 Stratix-IV-230 */
 #define GENWQE_TYPE_ALTERA_530		0x01 /* GenWQE4 Stratix-IV-530 */
-- 
1.7.1

