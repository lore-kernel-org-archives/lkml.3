Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810Ab3FZD5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 23:57:34 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:46342 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab3FZD5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 23:57:33 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: gregkh@linuxfoundation.org, joe@perches.com, davem@davemloft.net,
        rafael.j.wysocki@intel.com, jbaron@redhat.com,
        linux-kernel@vger.kernel.org
Cc: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] driver core: device.h: fix doc compilation warnings
Date: Wed, 26 Jun 2013 05:57:06 +0200
Message-Id: <1372219026-23418-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the below 3 warnings running "make htmldocs",
by adding descriptions for recently added structure members:

DOCPROC Documentation/DocBook/device-drivers.xml
Warning(/work/git.free-electrons.com/users/michael-opdenacker/linux//include/linux/device.h:116): No description found for parameter 'lock_key'
Warning(/work/git.free-electrons.com/users/michael-opdenacker/linux//include/linux/device.h:723): No description found for parameter 'cma_area'
Warning(/work/git.free-electrons.com/users/michael-opdenacker/linux//include/linux/device.h:723): No description found for parameter 'iommu_group'

Don't hesitate to propose better descriptions!

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 include/linux/device.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/device.h b/include/linux/device.h
index c0a1261..9d4835a 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -80,6 +80,7 @@ extern void bus_remove_file(struct bus_type *, struct bus_attribute *);
  *              bus-specific setup
  * @p:		The private data of the driver core, only the driver core can
  *		touch this.
+ * @lock_key:	Lock class key for use by the lock validator
  *
  * A bus is a channel between the processor and one or more devices. For the
  * purposes of the device model, all devices are connected via a bus, even if
@@ -635,6 +636,7 @@ struct acpi_dev_node {
  * 		segment limitations.
  * @dma_pools:	Dma pools (if dma'ble device).
  * @dma_mem:	Internal for coherent mem override.
+ * @cma_area:	Contiguous memory area for dma allocations
  * @archdata:	For arch-specific additions.
  * @of_node:	Associated device tree node.
  * @acpi_node:	Associated ACPI device node.
@@ -648,6 +650,7 @@ struct acpi_dev_node {
  * @release:	Callback to free the device after all references have
  * 		gone away. This should be set by the allocator of the
  * 		device (i.e. the bus driver that discovered the device).
+ * @iommu_group: IOMMU group the device belongs to.
  *
  * At the lowest level, every device in a Linux system is represented by an
  * instance of struct device. The device structure contains the information
-- 
1.8.1.2

