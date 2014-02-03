Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbaBCRik (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 12:38:40 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51236 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751912AbaBCRij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 12:38:39 -0500
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: linux-pci <linux-pci@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Liviu Dudau <liviu@dudau.co.uk>
Subject: [PATCH] pci: Makefile: Cleanup per-arch list of object files
Date: Mon,  3 Feb 2014 17:38:36 +0000
Message-Id: <1391449116-22276-1-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

setup-bus.o is now included unconditionally as of commit
7dc30303342562685392c8c7aa5194e98fd27625. Remove it from
the per-arch list of object files.

Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
---
 drivers/pci/Makefile | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index 17d2b07..e2501ac 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -33,21 +33,15 @@ obj-$(CONFIG_PCI_IOV) += iov.o
 #
 # Some architectures use the generic PCI setup functions
 #
-obj-$(CONFIG_X86) += setup-bus.o
-obj-$(CONFIG_ALPHA) += setup-bus.o setup-irq.o
-obj-$(CONFIG_ARM) += setup-bus.o setup-irq.o
-obj-$(CONFIG_UNICORE32) += setup-bus.o setup-irq.o
-obj-$(CONFIG_PARISC) += setup-bus.o
-obj-$(CONFIG_SUPERH) += setup-bus.o setup-irq.o
-obj-$(CONFIG_PPC) += setup-bus.o
-obj-$(CONFIG_FRV) += setup-bus.o
-obj-$(CONFIG_MIPS) += setup-bus.o setup-irq.o
+obj-$(CONFIG_ALPHA) += setup-irq.o
+obj-$(CONFIG_ARM) += setup-irq.o
+obj-$(CONFIG_UNICORE32) += setup-irq.o
+obj-$(CONFIG_SUPERH) += setup-irq.o
+obj-$(CONFIG_MIPS) += setup-irq.o
 obj-$(CONFIG_X86_VISWS) += setup-irq.o
-obj-$(CONFIG_MN10300) += setup-bus.o
-obj-$(CONFIG_MICROBLAZE) += setup-bus.o
-obj-$(CONFIG_TILE) += setup-bus.o setup-irq.o
-obj-$(CONFIG_SPARC_LEON) += setup-bus.o setup-irq.o
-obj-$(CONFIG_M68K) += setup-bus.o setup-irq.o
+obj-$(CONFIG_TILE) += setup-irq.o
+obj-$(CONFIG_SPARC_LEON) += setup-irq.o
+obj-$(CONFIG_M68K) += setup-irq.o
 
 #
 # ACPI Related PCI FW Functions
-- 
1.8.5.3

