Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab3JUIvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:51:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39444 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753535Ab3JUIvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:51:17 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alan Stern" <stern@rowland.harvard.edu>,
        "kbuild test robot" <fengguang.wu@intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.203511902@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 041/149] USB: fix build error when CONFIG_PM_SLEEP
 isn't enabled
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 9d8924297cd9c256c23c02abae40202563452453 upstream.

This patch fixes a build error that occurs when CONFIG_PM is enabled
and CONFIG_PM_SLEEP isn't:

>> drivers/usb/host/ohci-pci.c:294:10: error: 'usb_hcd_pci_pm_ops' undeclared here (not in a function)
      .pm = &usb_hcd_pci_pm_ops

Since the usb_hcd_pci_pm_ops structure is defined and used when
CONFIG_PM is enabled, its declaration should not be protected by
CONFIG_PM_SLEEP.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/usb/hcd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/usb/hcd.h
+++ b/include/linux/usb/hcd.h
@@ -395,7 +395,7 @@ extern int usb_hcd_pci_probe(struct pci_
 extern void usb_hcd_pci_remove(struct pci_dev *dev);
 extern void usb_hcd_pci_shutdown(struct pci_dev *dev);
 
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_PM
 extern const struct dev_pm_ops usb_hcd_pci_pm_ops;
 #endif
 #endif /* CONFIG_PCI */

