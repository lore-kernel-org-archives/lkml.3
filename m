Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab3LSKxa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 05:53:30 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:52300 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab3LSKx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 05:53:29 -0500
Date: Thu, 19 Dec 2013 16:23:12 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Bjorn Helgaas <bhelgaas@google.com>, Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexander Gordeev <agordeev@redhat.com>, josh@joshtriplett.org
Subject: [PATCH] drivers: pci: Add prototype declarations of function in
 appropriate header
Message-ID: <20131219105312.GA23614@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add prototype declarations of functions arch_msi_mask_irq() and
arch_msix_mask_irq() to header file include/linux/msi.h.

This eliminates the following warning in msi.c:
drivers/pci/msi.c:202:12: warning: no previous prototype for ‘arch_msi_mask_irq’ [-Wmissing-prototypes]
drivers/pci/msi.c:232:12: warning: no previous prototype for ‘arch_msix_mask_irq’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 include/linux/msi.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/msi.h b/include/linux/msi.h
index 009b024..63b7d14 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -66,6 +66,8 @@ void default_teardown_msi_irqs(struct pci_dev *dev);
 void default_restore_msi_irqs(struct pci_dev *dev, int irq);
 u32 default_msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag);
 u32 default_msix_mask_irq(struct msi_desc *desc, u32 flag);
+u32 arch_msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag);
+u32 arch_msix_mask_irq(struct msi_desc *desc, u32 flag);
 
 struct msi_chip {
 	struct module *owner;
-- 
1.7.9.5

