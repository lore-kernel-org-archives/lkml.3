Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbaDSOeb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 10:34:31 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:53135 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbaDSOeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 10:34:23 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH v2 1/7] device: introduce per device dma_pfn_offset
Date: Sat, 19 Apr 2014 10:32:46 -0400
Message-ID: <1397917972-6293-2-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397917972-6293-1-git-send-email-santosh.shilimkar@ti.com>
References: <1397917972-6293-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On few architectures, there are few restrictions on DMAble area of system
RAM. That also means that devices needs to know about this restrictions so
that the dma_masks can be updated accordingly and dma address translation
helpers can add/subtract the dma offset.

In most of cases DMA addresses can be performed using offset value of
Bus address space relatively to physical address space as following:

PFN->DMA:  __pfn_to_phys(pfn + [-]dma_pfn_offset)
DMA->PFN:  __phys_to_pfn(dma_addr) + [-]dma_pfn_offset

So we introduce per device dma_pfn_offset which can be popullated
by architecture init code while creating the devices.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Olof Johansson <olof@lixom.net>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 include/linux/device.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/device.h b/include/linux/device.h
index 233bbbe..85a52d6 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -691,6 +691,7 @@ struct acpi_dev_node {
  * @coherent_dma_mask: Like dma_mask, but for alloc_coherent mapping as not all
  * 		hardware supports 64-bit addresses for consistent allocations
  * 		such descriptors.
+ * @dma_pfn_offset: offset of DMA memory range relatively of RAM
  * @dma_parms:	A low level driver may set these to teach IOMMU code about
  * 		segment limitations.
  * @dma_pools:	Dma pools (if dma'ble device).
@@ -756,6 +757,7 @@ struct device {
 					     not all hardware supports
 					     64 bit addresses for consistent
 					     allocations such descriptors. */
+	unsigned long	dma_pfn_offset;
 
 	struct device_dma_parameters *dma_parms;
 
-- 
1.7.9.5

