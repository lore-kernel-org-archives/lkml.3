Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348Ab3LRGg7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 01:36:59 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:60710 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab3LRGg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 01:36:58 -0500
Date: Wed, 18 Dec 2013 12:06:45 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Joerg Roedel <joro@8bytes.org>, iommu@lists.linux-foundation.org,
        josh@joshtriplett.org
Subject: [PATCH 3/3] drivers: iommu: Mark function eoi_ioapic_pin_remapped()
 as static in irq_remapping.c
Message-ID: <9550af5889a779ff889d4a4371097daaf42cf4a3.1387265905.git.rashika.kheria@gmail.com>
References: <6d0cb39e3d1128669e7740943efce3996ab0d8ab.1387265904.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6d0cb39e3d1128669e7740943efce3996ab0d8ab.1387265904.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark function eoi_ioapic_pin_remapped() as static in irq_remapping.c
because it is not used outside this file.

This eliminates the following warning in
irq_remapping.c:drivers/iommu/irq_remapping.c:153:6: warning: no
previous prototype for ‘eoi_ioapic_pin_remapped’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/iommu/irq_remapping.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 39f81ae..3b05d1b 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -150,7 +150,7 @@ static int irq_remapping_setup_msi_irqs(struct pci_dev *dev,
 		return do_setup_msix_irqs(dev, nvec);
 }
 
-void eoi_ioapic_pin_remapped(int apic, int pin, int vector)
+static void eoi_ioapic_pin_remapped(int apic, int pin, int vector)
 {
 	/*
 	 * Intr-remapping uses pin number as the virtual vector
-- 
1.7.9.5

