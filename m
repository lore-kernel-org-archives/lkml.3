Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758954Ab3HOQFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 12:05:13 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:12350 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756994Ab3HOQFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 12:05:10 -0400
X-AuditID: cbfec7f5-b7f5f6d00000105f-0c-520cfc3356d8
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        sarah.a.sharp@linux.intel.com
Cc: dmitry.kasatkin@gmail.com
Subject: [PATCH 2/2] xhci:prevent "callbacks suppressed" when debug is not
 enabled
Date: Thu, 15 Aug 2013 19:04:55 +0300
Message-id: <70b3564625bbda6247cc5627041344fef8a762ae.1376582695.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.8.1.2
In-reply-to: <71bb3fcd9f1a99aa7bd8f6dd1fb6267173db51d2.1376582695.git.d.kasatkin@samsung.com>
References: <71bb3fcd9f1a99aa7bd8f6dd1fb6267173db51d2.1376582695.git.d.kasatkin@samsung.com>
In-reply-to: <71bb3fcd9f1a99aa7bd8f6dd1fb6267173db51d2.1376582695.git.d.kasatkin@samsung.com>
References: <71bb3fcd9f1a99aa7bd8f6dd1fb6267173db51d2.1376582695.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKJMWRmVeSWpSXmKPExsVy+t/xy7rGf3iCDP60a1t8WVpn0bx4PZvF
	5V1z2CyaT5xidmDx2DnrLrvHvJOBHvvnrmH3+LxJLoAlissmJTUnsyy1SN8ugStjyfIFbAXz
	uCvOdCY3ME7n7GLk4JAQMJHoajXuYuQEMsUkLtxbzwZiCwksZZS40WzXxcgFZHcySfS/b2YB
	SbAJ6ElsaP7BDmKLCMRKPDq/hBHEZhaQlehesRSsWVggRGLBr01g9SwCqhLb310Ci/MKxEkc
	PrCFDWKZgsTPyyfAbE6BeIk7HddZIRbHSXyZeIAVl/gERv4FjAyrGEVTS5MLipPSc430ihNz
	i0vz0vWS83M3MUKC6usOxqXHrA4xCnAwKvHwRrRxBwmxJpYVV+YeYpTgYFYS4f16jydIiDcl
	sbIqtSg/vqg0J7X4ECMTB6dUA+M55vgp66tOSSd+uVL5LGHpEcV5ukXtnxWn8mcGvWxWOcmk
	2fA/tNTeyIn34X2dkHLmi8W3Z/i83zg1Q9vtA7Nv1D2x+uOX3E5Olv/+2c2tiPWQ0Wu3w7+2
	/OvlCDYtDZRJ8vnVH7c2RvLG/kNqM9dEu9apKfMGynp73bmws81zWqHLM4vZ85VYijMSDbWY
	i4oTAddaNqMIAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When debug is not enabled and dev_dbg() will expand to nothing,
log might be flooded with "callbacks suppressed". If it was not
done on purpose, better to use dev_dbg_ratelimited() instead.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 drivers/usb/host/xhci-ring.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 5b08cd8..5298232 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -3060,8 +3060,7 @@ int xhci_queue_intr_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
 	 * to set the polling interval (once the API is added).
 	 */
 	if (xhci_interval != ep_interval) {
-		if (printk_ratelimit())
-			dev_dbg(&urb->dev->dev, "Driver uses different interval"
+		dev_dbg_ratelimited(&urb->dev->dev, "Driver uses different interval"
 					" (%d microframe%s) than xHCI "
 					"(%d microframe%s)\n",
 					ep_interval,
@@ -3849,8 +3848,7 @@ int xhci_queue_isoc_tx_prepare(struct xhci_hcd *xhci, gfp_t mem_flags,
 	 * to set the polling interval (once the API is added).
 	 */
 	if (xhci_interval != ep_interval) {
-		if (printk_ratelimit())
-			dev_dbg(&urb->dev->dev, "Driver uses different interval"
+		dev_dbg_ratelimited(&urb->dev->dev, "Driver uses different interval"
 					" (%d microframe%s) than xHCI "
 					"(%d microframe%s)\n",
 					ep_interval,
-- 
1.8.1.2

