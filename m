Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbaBSKSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 05:18:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009AbaBSKNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 05:13:43 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-pci@vger.kernel.org
Subject: [PATCH] timberdale: Use pci_enable_msix_range() instead of pci_enable_msix()
Date: Wed, 19 Feb 2014 11:15:23 +0100
Message-Id: <1392804931-30671-3-git-send-email-agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: linux-pci@vger.kernel.org
---
 drivers/mfd/timberdale.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/timberdale.c b/drivers/mfd/timberdale.c
index 2bc5cfb..c2bc6d7 100644
--- a/drivers/mfd/timberdale.c
+++ b/drivers/mfd/timberdale.c
@@ -715,8 +715,9 @@ static int timb_probe(struct pci_dev *dev,
 	for (i = 0; i < TIMBERDALE_NR_IRQS; i++)
 		msix_entries[i].entry = i;
 
-	err = pci_enable_msix(dev, msix_entries, TIMBERDALE_NR_IRQS);
-	if (err) {
+	err = pci_enable_msix_range(dev, msix_entries,
+				    TIMBERDALE_NR_IRQS, TIMBERDALE_NR_IRQS);
+	if (err < 0) {
 		dev_err(&dev->dev,
 			"MSI-X init failed: %d, expected entries: %d\n",
 			err, TIMBERDALE_NR_IRQS);
-- 
1.7.7.6

