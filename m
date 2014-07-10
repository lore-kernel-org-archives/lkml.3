Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295AbaGJBGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 21:06:14 -0400
Received: from mail-ob0-f201.google.com ([209.85.214.201]:62793 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbaGJBF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 21:05:56 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Julius Werner <jwerner@chromium.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: linux-tegra@vger.kernel.org, Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH 3/4] xhci: Export symbols used by host-controller drivers
Date: Wed,  9 Jul 2014 18:05:49 -0700
Message-Id: <1404954350-26343-4-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1404954350-26343-1-git-send-email-abrestic@chromium.org>
References: <1404954350-26343-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for allowing the xHCI host controller drivers to be built
as separate modules, export symbols from the xHCI core that may be used
by the host controller drivers.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/usb/host/xhci-dbg.c | 1 +
 drivers/usb/host/xhci.c     | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/usb/host/xhci-dbg.c b/drivers/usb/host/xhci-dbg.c
index eb009a4..bb89175 100644
--- a/drivers/usb/host/xhci-dbg.c
+++ b/drivers/usb/host/xhci-dbg.c
@@ -594,3 +594,4 @@ void xhci_dbg_trace(struct xhci_hcd *xhci, void (*trace)(struct va_format *),
 	trace(&vaf);
 	va_end(args);
 }
+EXPORT_SYMBOL_GPL(xhci_dbg_trace);
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index f681087..4958a60 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -927,6 +927,7 @@ int xhci_suspend(struct xhci_hcd *xhci)
 
 	return rc;
 }
+EXPORT_SYMBOL_GPL(xhci_suspend);
 
 /*
  * start xHC (not bus-specific)
@@ -1078,6 +1079,7 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 
 	return retval;
 }
+EXPORT_SYMBOL_GPL(xhci_resume);
 #endif	/* CONFIG_PM */
 
 /*-------------------------------------------------------------------------*/
@@ -4872,6 +4874,7 @@ error:
 	kfree(xhci);
 	return retval;
 }
+EXPORT_SYMBOL_GPL(xhci_gen_setup);
 
 static const struct hc_driver xhci_hc_driver = {
 	.description =		"xhci-hcd",
-- 
2.0.0.526.g5318336

