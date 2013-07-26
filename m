Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760Ab3GZMhP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 08:37:15 -0400
Received: from multi.imgtec.com ([194.200.65.239]:59671 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757916Ab3GZMhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 08:37:13 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [PATCH] usb: xhci: add missing dma-mapping.h includes
Date: Fri, 26 Jul 2013 13:34:43 +0100
Message-ID: <1374842083-5935-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_07_26_13_37_12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A randconfig build hit the following build errors because xhci.c and
xhci-mem.c use dma mapping functions but don't include
<linux/dma-mapping.h>. Add the missing includes to fix the build errors.

drivers/usb/host/xhci.c In function 'xhci_gen_setup':
drivers/usb/host/xhci.c +4872 : error: implicit declaration of function 'dma_set_mask'
drivers/usb/host/xhci.c +4872 : error: implicit declaration of function 'DMA_BIT_MASK'

drivers/usb/host/xhci-mem.c In function 'xhci_free_stream_ctx':
drivers/usb/host/xhci-mem.c +435 : error: implicit declaration of function 'dma_free_coherent'
drivers/usb/host/xhci-mem.c In function 'xhci_alloc_stream_ctx':
drivers/usb/host/xhci-mem.c +463 : error: implicit declaration of function 'dma_alloc_coherent'

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
---
 drivers/usb/host/xhci-mem.c | 1 +
 drivers/usb/host/xhci.c     | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index fbf75e5..3e27d92 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -24,6 +24,7 @@
 #include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/dmapool.h>
+#include <linux/dma-mapping.h>
 
 #include "xhci.h"
 
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index d8f640b..247020c 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -27,6 +27,7 @@
 #include <linux/moduleparam.h>
 #include <linux/slab.h>
 #include <linux/dmi.h>
+#include <linux/dma-mapping.h>
 
 #include "xhci.h"
 
-- 
1.8.1.2


