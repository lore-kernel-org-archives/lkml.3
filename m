Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963AbaAGC5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 21:57:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:3162 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756395AbaAGC5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 21:57:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,616,1384329600"; 
   d="scan'208";a="434855194"
From: David Cohen <david.a.cohen@linux.intel.com>
To: sarah.a.sharp@linux.intel.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH v2] usb/xhci: fix compilation warning when !CONFIG_PCI && !CONFIG_PM
Date: Mon,  6 Jan 2014 19:02:19 -0800
Message-Id: <1389063739-6028-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389059068-18491-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1389059068-18491-1-git-send-email-david.a.cohen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_PCI and CONFIG_PM are not selected, xhci.c gets this
warning:
drivers/usb/host/xhci.c:409:13: warning: ‘xhci_msix_sync_irqs’ defined
but not used [-Wunused-function]

It happens due to lack of __maybe_unused flag on xhci_msix_sync_irqs()
function in case of !CONFIG_PCI.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---

Change v1 -> v2:
 - xhci_msix_sync_irqs() already uses __maybe_unused flag when CONFIG_PCI is
   set. Proper solution is to add same flag when !CONFIG_PCI instead of define
   function as inline.

 drivers/usb/host/xhci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 4265b48856f6..ed6b717b8ee1 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -406,7 +406,7 @@ static void xhci_cleanup_msix(struct xhci_hcd *xhci)
 {
 }
 
-static void xhci_msix_sync_irqs(struct xhci_hcd *xhci)
+static void __maybe_unused xhci_msix_sync_irqs(struct xhci_hcd *xhci)
 {
 }
 
-- 
1.8.4.2

