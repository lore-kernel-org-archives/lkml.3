Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243Ab3IYAUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:20:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39543 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756589Ab3IYAUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:20:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        kbuild test robot <fengguang.wu@intel.com>
Subject: [ 044/117] USB: fix build error when CONFIG_PM_SLEEP isnt enabled
Date: Tue, 24 Sep 2013 17:18:30 -0700
Message-Id: <20130925001745.648746669@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001740.833541979@linuxfoundation.org>
References: <20130925001740.833541979@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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

---
 include/linux/usb/hcd.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/usb/hcd.h
+++ b/include/linux/usb/hcd.h
@@ -411,7 +411,7 @@ extern int usb_hcd_pci_probe(struct pci_
 extern void usb_hcd_pci_remove(struct pci_dev *dev);
 extern void usb_hcd_pci_shutdown(struct pci_dev *dev);
 
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_PM
 extern const struct dev_pm_ops usb_hcd_pci_pm_ops;
 #endif
 #endif /* CONFIG_PCI */


