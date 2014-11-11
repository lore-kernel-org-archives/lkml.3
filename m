Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075AbaKKLNm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:13:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57941 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541AbaKKLLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:11:39 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 163/170] PCI: Rename sysfs 'enabled' file back to 'enable'
Date: Tue, 11 Nov 2014 11:08:42 +0000
Message-Id: <1415704129-12709-164-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/pci/pci-sysfs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 76ef7914c9aa..6d04771e4903 100644
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
@@ -564,7 +564,7 @@ static struct attribute *pci_dev_attrs[] = {
 #endif
 	&dev_attr_dma_mask_bits.attr,
 	&dev_attr_consistent_dma_mask_bits.attr,
-	&dev_attr_enabled.attr,
+	&dev_attr_enable.attr,
 	&dev_attr_broken_parity_status.attr,
 	&dev_attr_msi_bus.attr,
 #if defined(CONFIG_PM_RUNTIME) && defined(CONFIG_ACPI)
-- 
2.1.0

