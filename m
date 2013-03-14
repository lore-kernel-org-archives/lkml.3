Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab3CNV4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 17:56:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:51463 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245Ab3CNV4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 17:56:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH] vfio: include <linux/slab.h> for kmalloc
Date: Thu, 14 Mar 2013 22:56:43 +0100
Message-Id: <1363298204-8014-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363298204-8014-1-git-send-email-arnd@arndb.de>
References: <1363298204-8014-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:2S8UK4a3OWuR69bJAlgZUGs/fWNevL9vTTLkifrg5Yj
 yjPqOf15QogRSAojb4/BWzw1KfGHrt9ajWy8CGRT0Oic4bGonW
 gfAfPxavKp3iebHh4dI7WeEk1gwq769ZsVx1SyMwQClPsVeHAg
 +T8+MeOG+eJ2JNyWrD/y5D4AwFLxqGN66Jlk9menmplv8tR3o0
 pCOoeGhBWmGgRN4hRPFlsWW0dbfpyB5maGrg2+0tIUQGh3Whji
 wIb6dWpeDL50JZ9upkalKraiVszIbS0yw8lGf69xuOyB8sHnL5
 TLCBukP75KppmhTqLJiBGgtlCi54yVLNpZRCRWPvyk+8DE/OSW
 ZjkR/J2zF8/QnVscp0t5Un49XWThsok6o/50wbvDS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vfio drivers call kmalloc or kzalloc, but do not
include <linux/slab.h>, which causes build errors on
ARM.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org
---
Please apply for 3.9

 drivers/vfio/pci/vfio_pci_config.c | 1 +
 drivers/vfio/pci/vfio_pci_intrs.c  | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 964ff22..aeb00fc 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -27,6 +27,7 @@
 #include <linux/pci.h>
 #include <linux/uaccess.h>
 #include <linux/vfio.h>
+#include <linux/slab.h>
 
 #include "vfio_pci_private.h"
 
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 3639371..a965091 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -22,6 +22,7 @@
 #include <linux/vfio.h>
 #include <linux/wait.h>
 #include <linux/workqueue.h>
+#include <linux/slab.h>
 
 #include "vfio_pci_private.h"
 
-- 
1.8.1.2

