Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511AbaJAMA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 08:00:27 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:58205 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbaJAMAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 08:00:24 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] vfio/pci: Add missing linux/irq.h include
Date: Wed,  1 Oct 2014 14:00:18 +0200
Message-Id: <1412164818-18211-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

This code uses the irq_get_msi_desc() function whose prototype is in
linux/irq.h. Include this header to fix a build failure.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index a068bb0d69e5..d6f097b0e0e3 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -15,6 +15,7 @@
 
 #include <linux/device.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <linux/eventfd.h>
 #include <linux/msi.h>
 #include <linux/pci.h>
-- 
2.1.0

