Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbaFDXYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:24:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41102 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255AbaFDXY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:24:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 3.10 100/103] iommu/amd: Fix interrupt remapping for aliased devices
Date: Wed,  4 Jun 2014 16:26:03 -0700
Message-Id: <20140604232550.096207059@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232546.704156131@linuxfoundation.org>
References: <20140604232546.704156131@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Williamson <alex.williamson@redhat.com>

commit e028a9e6b8a637af09ac4114083280df4a7045f1 upstream.

An apparent cut and paste error prevents the correct flags from being
set on the alias device resulting in MSI on conventional PCI devices
failing to work.  This also produces error events from the IOMMU like:

AMD-Vi: Event logged [INVALID_DEVICE_REQUEST device=00:14.4 address=0x000000fdf8000000 flags=0x0a00]

Where 14.4 is a PCIe-to-PCI bridge with a device behind it trying to
use MSI interrupts.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Joerg Roedel <joro@8bytes.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/amd_iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -3959,7 +3959,7 @@ static struct irq_remap_table *get_irq_t
 	iommu_flush_dte(iommu, devid);
 	if (devid != alias) {
 		irq_lookup_table[alias] = table;
-		set_dte_irq_entry(devid, table);
+		set_dte_irq_entry(alias, table);
 		iommu_flush_dte(iommu, alias);
 	}
 


