Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934904AbaKLBrE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:47:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60713 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933135AbaKLBrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:47:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jeff Epler <jepler@unpythonic.net>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 3.14 176/203] PCI: Rename sysfs enabled file back to enable
Date: Wed, 12 Nov 2014 10:17:26 +0900
Message-Id: <20141112011550.758903120@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit d8e7d53a2fc14e0830ab728cb84ee19933d3ac8d upstream.

Back in commit 5136b2da770d ("PCI: convert bus code to use dev_groups"),
I misstyped the 'enable' sysfs filename as 'enabled', which broke the
userspace API.  This patch fixes that issue by renaming the file back.

Fixes: 5136b2da770d ("PCI: convert bus code to use dev_groups")
Reported-by: Jeff Epler <jepler@unpythonic.net>
Tested-by: Jeff Epler <jepler@unpythonic.net>	# on v3.14-rt
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

---
 drivers/pci/pci-sysfs.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -186,9 +186,9 @@ static ssize_t modalias_show(struct devi
 }
 static DEVICE_ATTR_RO(modalias);
 
-static ssize_t enabled_store(struct device *dev,
-			     struct device_attribute *attr, const char *buf,
-			     size_t count)
+static ssize_t enable_store(struct device *dev,
+			    struct device_attribute *attr, const char *buf,
+			    size_t count)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	unsigned long val;
@@ -212,15 +212,15 @@ static ssize_t enabled_store(struct devi
 	return result < 0 ? result : count;
 }
 
-static ssize_t enabled_show(struct device *dev,
-			    struct device_attribute *attr, char *buf)
+static ssize_t enable_show(struct device *dev,
+			   struct device_attribute *attr, char *buf)
 {
 	struct pci_dev *pdev;
 
 	pdev = to_pci_dev (dev);
 	return sprintf (buf, "%u\n", atomic_read(&pdev->enable_cnt));
 }
-static DEVICE_ATTR_RW(enabled);
+static DEVICE_ATTR_RW(enable);
 
 #ifdef CONFIG_NUMA
 static ssize_t
@@ -526,7 +526,7 @@ static struct attribute *pci_dev_attrs[]
 #endif
 	&dev_attr_dma_mask_bits.attr,
 	&dev_attr_consistent_dma_mask_bits.attr,
-	&dev_attr_enabled.attr,
+	&dev_attr_enable.attr,
 	&dev_attr_broken_parity_status.attr,
 	&dev_attr_msi_bus.attr,
 #if defined(CONFIG_PM_RUNTIME) && defined(CONFIG_ACPI)


