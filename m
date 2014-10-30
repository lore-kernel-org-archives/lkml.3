Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759099AbaJ3Qbl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 12:31:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35846 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758128AbaJ3Qbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 12:31:39 -0400
Date: Thu, 30 Oct 2014 09:30:28 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Jeff Epler <jepler@unpythonic.net>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] PCI: fix name of 'enable' sysfs file
Message-ID: <20141030163028.GA22250@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Back in commit 5136b2da770d ("PCI: convert bus code to use dev_groups"),
I misstyped the 'enable' sysfs file as 'enabled', which broke the
userspace api.  This patch fixes that issue by renaming the file back.

Reported-by: Jeff Epler <jepler@unpythonic.net>
Cc: stable <stable@vger.kernel.org> # 3.13
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

Jeff, if you could test this to make sure I got it right, that would be
great.  Again, sorry about this, it was a dumb typo on my part.

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 92b6d9ab00e4..2c6643fdc0cf 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -185,7 +185,7 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RO(modalias);
 
-static ssize_t enabled_store(struct device *dev, struct device_attribute *attr,
+static ssize_t enable_store(struct device *dev, struct device_attribute *attr,
 			     const char *buf, size_t count)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
@@ -210,7 +210,7 @@ static ssize_t enabled_store(struct device *dev, struct device_attribute *attr,
 	return result < 0 ? result : count;
 }
 
-static ssize_t enabled_show(struct device *dev, struct device_attribute *attr,
+static ssize_t enable_show(struct device *dev, struct device_attribute *attr,
 			    char *buf)
 {
 	struct pci_dev *pdev;
@@ -218,7 +218,7 @@ static ssize_t enabled_show(struct device *dev, struct device_attribute *attr,
 	pdev = to_pci_dev(dev);
 	return sprintf(buf, "%u\n", atomic_read(&pdev->enable_cnt));
 }
-static DEVICE_ATTR_RW(enabled);
+static DEVICE_ATTR_RW(enable);
 
 #ifdef CONFIG_NUMA
 static ssize_t numa_node_show(struct device *dev, struct device_attribute *attr,
@@ -563,7 +563,7 @@ static struct attribute *pci_dev_attrs[] = {
 #endif
 	&dev_attr_dma_mask_bits.attr,
 	&dev_attr_consistent_dma_mask_bits.attr,
-	&dev_attr_enabled.attr,
+	&dev_attr_enable.attr,
 	&dev_attr_broken_parity_status.attr,
 	&dev_attr_msi_bus.attr,
 #if defined(CONFIG_PM_RUNTIME) && defined(CONFIG_ACPI)
