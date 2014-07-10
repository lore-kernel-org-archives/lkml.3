Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbaGJIKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 04:10:38 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:39916 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbaGJIKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 04:10:31 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v2] Documentation: devres: Sort managed interfaces
Date: Thu, 10 Jul 2014 10:10:23 +0200
Message-Id: <1404979823-13234-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sort the list of managed interfaces and their lists of methods
alphabetically, to reduce the risk of merge conflicts and duplicates.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
I got annoyed by the merge conflicts when merging several for-next
branches a while ago, so I sorted the list after everything became
quiet.

v2:
  - Rebased against next-20140710
---
 Documentation/driver-model/devres.txt | 114 +++++++++++++++++-----------------
 1 file changed, 57 insertions(+), 57 deletions(-)

diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
index 034d32b00846..d14710b04439 100644
--- a/Documentation/driver-model/devres.txt
+++ b/Documentation/driver-model/devres.txt
@@ -233,68 +233,78 @@ certainly invest a bit more effort into libata core layer).
   6. List of managed interfaces
   -----------------------------
 
-MEM
-  devm_kmalloc()
-  devm_kzalloc()
-  devm_kmalloc_array()
-  devm_kcalloc()
-  devm_kfree()
-  devm_kmemdup()
-  devm_get_free_pages()
-  devm_free_pages()
+CLOCK
+  devm_clk_get()
+  devm_clk_put()
+
+DMA
+  dmam_alloc_coherent()
+  dmam_alloc_noncoherent()
+  dmam_declare_coherent_memory()
+  dmam_free_coherent()
+  dmam_free_noncoherent()
+  dmam_pool_create()
+  dmam_pool_destroy()
+
+GPIO
+  devm_gpiod_get()
+  devm_gpiod_get_index()
+  devm_gpiod_get_index_optional()
+  devm_gpiod_get_optional()
+  devm_gpiod_put()
 
 IIO
   devm_iio_device_alloc()
   devm_iio_device_free()
-  devm_iio_trigger_alloc()
-  devm_iio_trigger_free()
   devm_iio_device_register()
   devm_iio_device_unregister()
+  devm_iio_trigger_alloc()
+  devm_iio_trigger_free()
 
 IO region
-  devm_request_region()
-  devm_request_mem_region()
-  devm_release_region()
   devm_release_mem_region()
-
-IRQ
-  devm_request_irq()
-  devm_free_irq()
-
-DMA
-  dmam_alloc_coherent()
-  dmam_free_coherent()
-  dmam_alloc_noncoherent()
-  dmam_free_noncoherent()
-  dmam_declare_coherent_memory()
-  dmam_pool_create()
-  dmam_pool_destroy()
-
-PCI
-  pcim_enable_device()	: after success, all PCI ops become managed
-  pcim_pin_device()	: keep PCI device enabled after release
+  devm_release_region()
+  devm_request_mem_region()
+  devm_request_region()
 
 IOMAP
   devm_ioport_map()
   devm_ioport_unmap()
   devm_ioremap()
   devm_ioremap_nocache()
-  devm_iounmap()
   devm_ioremap_resource() : checks resource, requests memory region, ioremaps
+  devm_iounmap()
   pcim_iomap()
-  pcim_iounmap()
-  pcim_iomap_table()	: array of mapped addresses indexed by BAR
   pcim_iomap_regions()	: do request_region() and iomap() on multiple BARs
+  pcim_iomap_table()	: array of mapped addresses indexed by BAR
+  pcim_iounmap()
 
-REGULATOR
-  devm_regulator_get()
-  devm_regulator_put()
-  devm_regulator_bulk_get()
-  devm_regulator_register()
+IRQ
+  devm_free_irq()
+  devm_request_irq()
 
-CLOCK
-  devm_clk_get()
-  devm_clk_put()
+MDIO
+  devm_mdiobus_alloc()
+  devm_mdiobus_alloc_size()
+  devm_mdiobus_free()
+
+MEM
+  devm_free_pages()
+  devm_get_free_pages()
+  devm_kcalloc()
+  devm_kfree()
+  devm_kmalloc()
+  devm_kmalloc_array()
+  devm_kmemdup()
+  devm_kzalloc()
+
+PCI
+  pcim_enable_device()	: after success, all PCI ops become managed
+  pcim_pin_device()	: keep PCI device enabled after release
+
+PHY
+  devm_usb_get_phy()
+  devm_usb_put_phy()
 
 PINCTRL
   devm_pinctrl_get()
@@ -304,24 +314,14 @@ PWM
   devm_pwm_get()
   devm_pwm_put()
 
-PHY
-  devm_usb_get_phy()
-  devm_usb_put_phy()
+REGULATOR
+  devm_regulator_bulk_get()
+  devm_regulator_get()
+  devm_regulator_put()
+  devm_regulator_register()
 
 SLAVE DMA ENGINE
   devm_acpi_dma_controller_register()
 
 SPI
   devm_spi_register_master()
-
-GPIO
-  devm_gpiod_get()
-  devm_gpiod_get_index()
-  devm_gpiod_get_optional()
-  devm_gpiod_get_index_optional()
-  devm_gpiod_put()
-
-MDIO
-  devm_mdiobus_alloc()
-  devm_mdiobus_alloc_size()
-  devm_mdiobus_free()
-- 
1.9.1

