Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab3HEWIt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:08:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:14501 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755106Ab3HEWIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:08:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,821,1367996400"; 
   d="scan'208";a="278103050"
From: Andi Kleen <andi@firstfloor.org>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        balbi@ti.com
Subject: [PATCH] dwc3: Only build debugfs when DWC3_GADGET/DUAL_ROLE is enabled
Date: Mon,  5 Aug 2013 15:08:43 -0700
Message-Id: <1375740523-7573-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Fix (randconfig) build problem with DEBUG_FS on

Cc: balbi@ti.com
Cc: linux-usb@vger.kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/usb/dwc3/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc3/Makefile b/drivers/usb/dwc3/Makefile
index 0c7ac92..2c7b55f 100644
--- a/drivers/usb/dwc3/Makefile
+++ b/drivers/usb/dwc3/Makefile
@@ -13,8 +13,8 @@ ifneq ($(filter y,$(CONFIG_USB_DWC3_GADGET) $(CONFIG_USB_DWC3_DUAL_ROLE)),)
 	dwc3-y				+= gadget.o ep0.o
 endif
 
-ifneq ($(CONFIG_DEBUG_FS),)
-	dwc3-y				+= debugfs.o
+ifneq ($(filter y,$(CONFIG_USB_DWC3_GADGET) $(CONFIG_USB_DWC3_DUAL_ROLE)),)
+	dwc3-$(CONFIG_DEBUG_FS)		+= debugfs.o
 endif
 
 ##
-- 
1.8.3.1

