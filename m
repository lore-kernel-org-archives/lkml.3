Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbaHSRba (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 13:31:30 -0400
Received: from mail-ig0-f202.google.com ([209.85.213.202]:54591 "EHLO
	mail-ig0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997AbaHSRb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 13:31:27 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Julius Werner <jwerner@chromium.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH v3 3/4] xhci: Export symbols used by host-controller drivers
Date: Tue, 19 Aug 2014 10:01:51 -0700
Message-Id: <1408467712-27497-4-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1408467712-27497-1-git-send-email-abrestic@chromium.org>
References: <1408467712-27497-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for allowing the xHCI host controller drivers to be built
as separate modules, export symbols from the xHCI core that may be used
by the host controller drivers.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
Changes from v2:
 - exported xhci_dbg_quirks tracepoint
Changes from v1:
 - exported xhci_run()
---
 drivers/usb/host/xhci-dbg.c   | 1 +
 drivers/usb/host/xhci-trace.c | 2 ++
 drivers/usb/host/xhci.c       | 4 ++++
 3 files changed, 7 insertions(+)

diff --git a/drivers/usb/host/xhci-dbg.c b/drivers/usb/host/xhci-dbg.c
index eb009a4..bb89175 100644
--- a/drivers/usb/host/xhci-dbg.c
+++ b/drivers/usb/host/xhci-dbg.c
@@ -594,3 +594,4 @@ void xhci_dbg_trace(struct xhci_hcd *xhci, void (*trace)(struct va_format *),
 	trace(&vaf);
 	va_end(args);
 }
+EXPORT_SYMBOL_GPL(xhci_dbg_trace);
diff --git a/drivers/usb/host/xhci-trace.c b/drivers/usb/host/xhci-trace.c
index 7cf30c8..367b630 100644
--- a/drivers/usb/host/xhci-trace.c
+++ b/drivers/usb/host/xhci-trace.c
@@ -13,3 +13,5 @@
 
 #define CREATE_TRACE_POINTS
 #include "xhci-trace.h"
+
+EXPORT_TRACEPOINT_SYMBOL_GPL(xhci_dbg_quirks);
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index a5cd831..edfc96f 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -653,6 +653,7 @@ int xhci_run(struct usb_hcd *hcd)
 			"Finished xhci_run for USB2 roothub");
 	return 0;
 }
+EXPORT_SYMBOL_GPL(xhci_run);
 
 static void xhci_only_stop_hcd(struct usb_hcd *hcd)
 {
@@ -927,6 +928,7 @@ int xhci_suspend(struct xhci_hcd *xhci)
 
 	return rc;
 }
+EXPORT_SYMBOL_GPL(xhci_suspend);
 
 /*
  * start xHC (not bus-specific)
@@ -1078,6 +1080,7 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 
 	return retval;
 }
+EXPORT_SYMBOL_GPL(xhci_resume);
 #endif	/* CONFIG_PM */
 
 /*-------------------------------------------------------------------------*/
@@ -4892,6 +4895,7 @@ error:
 	kfree(xhci);
 	return retval;
 }
+EXPORT_SYMBOL_GPL(xhci_gen_setup);
 
 static const struct hc_driver xhci_hc_driver = {
 	.description =		"xhci-hcd",
-- 
2.1.0.rc2.206.gedb03e5

