Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662AbaKFXBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:01:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58897 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797AbaKFWmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:42:38 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 156/162] PCI: Rename sysfs 'enabled' file back to 'enable'
Date: Thu,  6 Nov 2014 14:37:00 -0800
Message-Id: <1415313426-9622-157-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/pci/pci-sysfs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 21ba076..6a02775 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -186,7 +186,7 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RO(modalias);
 
-static ssize_t enabled_store(struct device *dev,
+static ssize_t enable_store(struct device *dev,
 			     struct device_attribute *attr, const char *buf,
 			     size_t count)
 {
@@ -212,7 +212,7 @@ static ssize_t enabled_store(struct device *dev,
 	return result < 0 ? result : count;
 }
 
-static ssize_t enabled_show(struct device *dev,
+static ssize_t enable_show(struct device *dev,
 			    struct device_attribute *attr, char *buf)
 {
 	struct pci_dev *pdev;
@@ -220,7 +220,7 @@ static ssize_t enabled_show(struct device *dev,
 	pdev = to_pci_dev (dev);
 	return sprintf (buf, "%u\n", atomic_read(&pdev->enable_cnt));
 }
-static DEVICE_ATTR_RW(enabled);
+static DEVICE_ATTR_RW(enable);
 
 #ifdef CONFIG_NUMA
 static ssize_t
@@ -531,7 +531,7 @@ static struct attribute *pci_dev_attrs[] = {
 #endif
 	&dev_attr_dma_mask_bits.attr,
 	&dev_attr_consistent_dma_mask_bits.attr,
-	&dev_attr_enabled.attr,
+	&dev_attr_enable.attr,
 	&dev_attr_broken_parity_status.attr,
 	&dev_attr_msi_bus.attr,
 #if defined(CONFIG_PM_RUNTIME) && defined(CONFIG_ACPI)
-- 
1.9.1

