Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab3JCETH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:19:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47187 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756030Ab3JCETD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:19:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 31/57] USB: fix PM config symbol in uhci-hcd, ehci-hcd, and xhci-hcd
Date: Wed,  2 Oct 2013 21:08:57 -0700
Message-Id: <20131003040638.733950927@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040636.600441214@linuxfoundation.org>
References: <20131003040636.600441214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/host/ehci-pci.c |    2 +-
 drivers/usb/host/uhci-pci.c |    2 +-
 drivers/usb/host/xhci-pci.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/host/ehci-pci.c
+++ b/drivers/usb/host/ehci-pci.c
@@ -403,7 +403,7 @@ static struct pci_driver ehci_pci_driver
 	.remove =	usb_hcd_pci_remove,
 	.shutdown = 	usb_hcd_pci_shutdown,
 
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_PM
 	.driver =	{
 		.pm =	&usb_hcd_pci_pm_ops
 	},
--- a/drivers/usb/host/uhci-pci.c
+++ b/drivers/usb/host/uhci-pci.c
@@ -293,7 +293,7 @@ static struct pci_driver uhci_pci_driver
 	.remove =	usb_hcd_pci_remove,
 	.shutdown =	uhci_shutdown,
 
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_PM
 	.driver =	{
 		.pm =	&usb_hcd_pci_pm_ops
 	},
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -345,7 +345,7 @@ static struct pci_driver xhci_pci_driver
 	/* suspend and resume implemented later */
 
 	.shutdown = 	usb_hcd_pci_shutdown,
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_PM
 	.driver = {
 		.pm = &usb_hcd_pci_pm_ops
 	},


