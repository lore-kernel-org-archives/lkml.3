Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217Ab3JKKn0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:43:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58555 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757901Ab3JKKnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:43:17 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 045/100] USB: fix PM config symbol in uhci-hcd, ehci-hcd, and xhci-hcd
Date: Fri, 11 Oct 2013 11:41:15 +0100
Message-Id: <1381488130-30235-46-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/host/ehci-pci.c | 2 +-
 drivers/usb/host/uhci-pci.c | 2 +-
 drivers/usb/host/xhci-pci.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
index 0909783..3302c27 100644
--- a/drivers/usb/host/ehci-pci.c
+++ b/drivers/usb/host/ehci-pci.c
@@ -549,7 +549,7 @@ static struct pci_driver ehci_pci_driver = {
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
index be08444..5e3ef3e 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -343,7 +343,7 @@ static struct pci_driver xhci_pci_driver = {
 	/* suspend and resume implemented later */
 
 	.shutdown = 	usb_hcd_pci_shutdown,
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_PM
 	.driver = {
 		.pm = &usb_hcd_pci_pm_ops
 	},
-- 
1.8.3.2

