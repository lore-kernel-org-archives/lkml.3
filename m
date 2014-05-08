Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbaEHQPy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:15:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:34560 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755231AbaEHQPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:15:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1010,1389772800"; 
   d="scan'208";a="535979595"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: <gregkh@linuxfoundation.org>
Cc: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sarah.a.sharp@linux.intel.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 04/10] usb: xhci: Use IS_ENABLED() macro
Date: Thu,  8 May 2014 19:25:57 +0300
Message-Id: <1399566363-25837-5-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399566363-25837-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1399566363-25837-1-git-send-email-mathias.nyman@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Using the IS_ENABLED() macro can make the code shorter and easier to read.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 4746816..cc67c76 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1738,8 +1738,7 @@ static inline int xhci_register_pci(void) { return 0; }
 static inline void xhci_unregister_pci(void) {}
 #endif
 
-#if defined(CONFIG_USB_XHCI_PLATFORM) \
-	|| defined(CONFIG_USB_XHCI_PLATFORM_MODULE)
+#if IS_ENABLED(CONFIG_USB_XHCI_PLATFORM)
 int xhci_register_plat(void);
 void xhci_unregister_plat(void);
 #else
-- 
1.8.3.2

