Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147Ab3GYUDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 16:03:00 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:48822 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576Ab3GYUC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 16:02:58 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: H Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH -next] staging: comedi: Add missing #include <linux/slab.h>
Date: Thu, 25 Jul 2013 22:02:48 +0200
Message-Id: <1374782568-3641-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparc64 allmodconfig:

drivers/staging/comedi/drivers/addi_apci_2032.c: In function 'apci2032_auto_attach':
drivers/staging/comedi/drivers/addi_apci_2032.c:328:3: error: implicit declaration of function 'kzalloc' [-Werror=implicit-function-declaration]
drivers/staging/comedi/drivers/addi_apci_2032.c:328:11: warning: assignment makes pointer from integer without a cast [enabled by default]
drivers/staging/comedi/drivers/addi_apci_2032.c: In function 'apci2032_detach':
drivers/staging/comedi/drivers/addi_apci_2032.c:350:3: error: implicit declaration of function 'kfree' [-Werror=implicit-function-declaration]

drivers/staging/comedi/drivers/amplc_pci224.c: In function 'pci224_attach_common':
drivers/staging/comedi/drivers/amplc_pci224.c:1289:2: error: implicit declaration of function 'kmalloc' [-Werror=implicit-function-declaration]
drivers/staging/comedi/drivers/amplc_pci224.c:1289:23: warning: assignment makes pointer from integer without a cast [enabled by default]
drivers/staging/comedi/drivers/amplc_pci224.c:1296:24: warning: assignment makes pointer from integer without a cast [enabled by default]
drivers/staging/comedi/drivers/amplc_pci224.c:1303:25: warning: assignment makes pointer from integer without a cast [enabled by default]
drivers/staging/comedi/drivers/amplc_pci224.c:1348:42: warning: assignment makes pointer from integer without a cast [enabled by default]
drivers/staging/comedi/drivers/amplc_pci224.c: In function 'pci224_detach':
drivers/staging/comedi/drivers/amplc_pci224.c:1474:3: error: implicit declaration of function 'kfree' [-Werror=implicit-function-declaration]

Introduced by commit 0bdab509bf9c6d838dc0a3b1d68bbf841fc20b5a ("staging:
comedi: use comedi_alloc_devpriv()"), which removed some inclusions of
<linux/slab.h>.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
http://kisskb.ellerman.id.au/kisskb/buildresult/9187516/
http://kisskb.ellerman.id.au/kisskb/buildresult/9186576/

 drivers/staging/comedi/drivers/addi_apci_2032.c |    1 +
 drivers/staging/comedi/drivers/amplc_pci224.c   |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/staging/comedi/drivers/addi_apci_2032.c b/drivers/staging/comedi/drivers/addi_apci_2032.c
index cb5d26a..6b0ea16 100644
--- a/drivers/staging/comedi/drivers/addi_apci_2032.c
+++ b/drivers/staging/comedi/drivers/addi_apci_2032.c
@@ -25,6 +25,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/interrupt.h>
+#include <linux/slab.h>
 
 #include "../comedidev.h"
 #include "addi_watchdog.h"
diff --git a/drivers/staging/comedi/drivers/amplc_pci224.c b/drivers/staging/comedi/drivers/amplc_pci224.c
index 2fc56c4..179de53 100644
--- a/drivers/staging/comedi/drivers/amplc_pci224.c
+++ b/drivers/staging/comedi/drivers/amplc_pci224.c
@@ -101,6 +101,7 @@ Caveats:
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/interrupt.h>
+#include <linux/slab.h>
 
 #include "../comedidev.h"
 
-- 
1.7.9.5

