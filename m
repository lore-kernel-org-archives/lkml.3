Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811Ab3JJP6g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:58:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52955 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757433Ab3JJPt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:49:26 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 070/104] USB: fix PM config symbol in uhci-hcd, ehci-hcd, and xhci-hcd
Date: Thu, 10 Oct 2013 08:41:58 -0700
Message-Id: <1381419752-29733-71-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit f875fdbf344b9fde207f66b392c40845dd7e5aa6 upstream.

Since uhci-hcd, ehci-hcd, and xhci-hcd support runtime PM, the .pm
field in their pci_driver structures should be protected by CONFIG_PM
rather than CONFIG_PM_SLEEP.  The corresponding change has already
been made for ohci-hcd.

Without this change, controllers won't do runtime suspend if system
suspend or hibernation isn't enabled.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/host/ehci-pci.c | 2 +-
 drivers/usb/host/uhci-pci.c | 2 +-
 drivers/usb/host/xhci-pci.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
index 170b939..4620cfc 100644
--- a/drivers/usb/host/ehci-pci.c
+++ b/drivers/usb/host/ehci-pci.c
@@ -413,7 +413,7 @@ static struct pci_driver ehci_pci_driver = {
 	.remove =	usb_hcd_pci_remove,
 	.shutdown = 	usb_hcd_pci_shutdown,
 
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_PM
 	.driver =	{
 		.pm =	&usb_hcd_pci_pm_ops
 	},
diff --git a/drivers/usb/host/uhci-pci.c b/drivers/usb/host/uhci-pci.c
index c300bd2f7..0f228c4 100644
--- a/drivers/usb/host/uhci-pci.c
+++ b/drivers/usb/host/uhci-pci.c
@@ -293,7 +293,7 @@ static struct pci_driver uhci_pci_driver = {
 	.remove =	usb_hcd_pci_remove,
 	.shutdown =	uhci_shutdown,
 
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_PM
 	.driver =	{
 		.pm =	&usb_hcd_pci_pm_ops
 	},
diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 76fb7d9..8233c91 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -344,7 +344,7 @@ static struct pci_driver xhci_pci_driver = {
 	/* suspend and resume implemented later */
 
 	.shutdown = 	usb_hcd_pci_shutdown,
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_PM
 	.driver = {
 		.pm = &usb_hcd_pci_pm_ops
 	},
-- 
1.8.1.2

