Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbaBLKds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 05:33:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbaBLKdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 05:33:46 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, linux-pci@vger.kernel.org
Subject: [PATCH] PCI/MSI: Fix cut-and-paste errors in documentation
Date: Wed, 12 Feb 2014 11:35:25 +0100
Message-Id: <1392201325-11173-1-git-send-email-agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function pci_enable_msi_range() is used in examples where
pci_enable_msix_range() should have been used instead.

Reported-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org
Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 Documentation/PCI/MSI-HOWTO.txt |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/PCI/MSI-HOWTO.txt b/Documentation/PCI/MSI-HOWTO.txt
index a8d0100..43c5a5f 100644
--- a/Documentation/PCI/MSI-HOWTO.txt
+++ b/Documentation/PCI/MSI-HOWTO.txt
@@ -257,8 +257,8 @@ possible, likely up to the limit returned by pci_msix_vec_count() function:
 
 static int foo_driver_enable_msix(struct foo_adapter *adapter, int nvec)
 {
-	return pci_enable_msi_range(adapter->pdev, adapter->msix_entries,
-				    1, nvec);
+	return pci_enable_msix_range(adapter->pdev, adapter->msix_entries,
+				     1, nvec);
 }
 
 Note the value of 'minvec' parameter is 1.  As 'minvec' is inclusive,
@@ -269,8 +269,8 @@ In this case the function could look like this:
 
 static int foo_driver_enable_msix(struct foo_adapter *adapter, int nvec)
 {
-	return pci_enable_msi_range(adapter->pdev, adapter->msix_entries,
-				    FOO_DRIVER_MINIMUM_NVEC, nvec);
+	return pci_enable_msix_range(adapter->pdev, adapter->msix_entries,
+				     FOO_DRIVER_MINIMUM_NVEC, nvec);
 }
 
 4.3.1.2 Exact number of MSI-X interrupts
@@ -282,8 +282,8 @@ parameters:
 
 static int foo_driver_enable_msix(struct foo_adapter *adapter, int nvec)
 {
-	return pci_enable_msi_range(adapter->pdev, adapter->msix_entries,
-				    nvec, nvec);
+	return pci_enable_msix_range(adapter->pdev, adapter->msix_entries,
+				     nvec, nvec);
 }
 
 4.3.1.3 Specific requirements to the number of MSI-X interrupts
-- 
1.7.7.6

