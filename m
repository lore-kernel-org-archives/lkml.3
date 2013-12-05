Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab3LELnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 06:43:13 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:11819 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab3LELnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 06:43:10 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH 2/3] iommu/fsl_pamu: Use dev_is_pci() to check whether it is pci device
Date: Thu, 5 Dec 2013 19:42:49 +0800
Message-ID: <1386243769-22672-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use PCI standard marco dev_is_pci() instead of directly compare
pci_bus_type to check whether it is pci device.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/iommu/fsl_pamu_domain.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/fsl_pamu_domain.c b/drivers/iommu/fsl_pamu_domain.c
index c857c30..93072ba 100644
--- a/drivers/iommu/fsl_pamu_domain.c
+++ b/drivers/iommu/fsl_pamu_domain.c
@@ -691,7 +691,7 @@ static int fsl_pamu_attach_device(struct iommu_domain *domain,
 	 * Use LIODN of the PCI controller while attaching a
 	 * PCI device.
 	 */
-	if (dev->bus == &pci_bus_type) {
+	if (dev_is_pci(dev)) {
 		pdev = to_pci_dev(dev);
 		pci_ctl = pci_bus_to_host(pdev->bus);
 		/*
@@ -729,7 +729,7 @@ static void fsl_pamu_detach_device(struct iommu_domain *domain,
 	 * Use LIODN of the PCI controller while detaching a
 	 * PCI device.
 	 */
-	if (dev->bus == &pci_bus_type) {
+	if (dev_is_pci(dev)) {
 		pdev = to_pci_dev(dev);
 		pci_ctl = pci_bus_to_host(pdev->bus);
 		/*
@@ -1056,7 +1056,7 @@ static int fsl_pamu_add_device(struct device *dev)
 	 * For platform devices we allocate a separate group for
 	 * each of the devices.
 	 */
-	if (dev->bus == &pci_bus_type) {
+	if (dev_is_pci(dev)) {
 		pdev = to_pci_dev(dev);
 		/* Don't create device groups for virtual PCI bridges */
 		if (pdev->subordinate)
-- 
1.7.1


