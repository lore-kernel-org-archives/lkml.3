Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933954Ab3GWS5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 14:57:53 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:59664 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933733Ab3GWS5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 14:57:52 -0400
From: Olof Johansson <olof@lixom.net>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH] usb: xhci: Mark two functions __maybe_unused
Date: Tue, 23 Jul 2013 11:58:20 -0700
Message-Id: <1374605900-29700-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resolves the following build warnings:
drivers/usb/host/xhci.c:332:13: warning: 'xhci_msix_sync_irqs' defined but not used [-Wunused-function]
drivers/usb/host/xhci.c:3901:12: warning: 'xhci_change_max_exit_latency' defined but not used [-Wunused-function]

These functions are not always used, and since they're marked static
they will produce build warnings:
- xhci_msix_sync_irqs is only used with CONFIG_PCI.
- xhci_change_max_exit_latency is a little more complicated with
  dependencies on CONFIG_PM and CONFIG_PM_RUNTIME.

Instead of building a bigger maze of ifdefs in this code, I've just
marked both with __maybe_unused.

Signed-off-by: Olof Johansson <olof@lixom.net>
---

Sarah,

I guess taste might differ on ifdef vs __maybe_unused, let me know this
is not to your liking.

Thanks,

-Olof

 drivers/usb/host/xhci.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 2c49f00..87ae8cd 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -329,7 +329,7 @@ static void xhci_cleanup_msix(struct xhci_hcd *xhci)
 	return;
 }
 
-static void xhci_msix_sync_irqs(struct xhci_hcd *xhci)
+static void __maybe_unused xhci_msix_sync_irqs(struct xhci_hcd *xhci)
 {
 	int i;
 
@@ -3898,7 +3898,7 @@ int xhci_find_raw_port_number(struct usb_hcd *hcd, int port1)
  * Issue an Evaluate Context command to change the Maximum Exit Latency in the
  * slot context.  If that succeeds, store the new MEL in the xhci_virt_device.
  */
-static int xhci_change_max_exit_latency(struct xhci_hcd *xhci,
+static int __maybe_unused xhci_change_max_exit_latency(struct xhci_hcd *xhci,
 			struct usb_device *udev, u16 max_exit_latency)
 {
 	struct xhci_virt_device *virt_dev;
-- 
1.7.10.4

