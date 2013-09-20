Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641Ab3ITUYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:24:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41612 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929Ab3ITUOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:14:23 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 43/93] USB: fix build error when CONFIG_PM_SLEEP isn't enabled
Date: Fri, 20 Sep 2013 13:08:38 -0700
Message-Id: <1379707768-1804-44-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/linux/usb/hcd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/usb/hcd.h b/include/linux/usb/hcd.h
index 0a78df5..40e8563 100644
--- a/include/linux/usb/hcd.h
+++ b/include/linux/usb/hcd.h
@@ -408,7 +408,7 @@ extern int usb_hcd_pci_probe(struct pci_dev *dev,
 extern void usb_hcd_pci_remove(struct pci_dev *dev);
 extern void usb_hcd_pci_shutdown(struct pci_dev *dev);
 
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_PM
 extern const struct dev_pm_ops usb_hcd_pci_pm_ops;
 #endif
 #endif /* CONFIG_PCI */
-- 
1.8.1.2

