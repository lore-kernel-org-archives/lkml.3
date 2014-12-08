Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbaLHPRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 10:17:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755981AbaLHPRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 10:17:04 -0500
Date: Mon, 8 Dec 2014 17:16:58 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v2 10/10] virtio_pci: rename virtio_pci -> virtio_pci_common
Message-ID: <1418051779-27748-11-git-send-email-mst@redhat.com>
References: <1418051779-27748-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418051779-27748-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kbuild does not seem to like it when we name source
files same as the module.
Let's rename virtio_pci -> virtio_pci_common,
and get rid of #include-ing c files.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/{virtio_pci.h => virtio_pci_common.h} | 4 ++--
 drivers/virtio/{virtio_pci.c => virtio_pci_common.c} | 2 +-
 drivers/virtio/virtio_pci_legacy.c                   | 2 +-
 drivers/virtio/Makefile                              | 1 +
 4 files changed, 5 insertions(+), 4 deletions(-)
 rename drivers/virtio/{virtio_pci.h => virtio_pci_common.h} (97%)
 rename drivers/virtio/{virtio_pci.c => virtio_pci_common.c} (99%)

diff --git a/drivers/virtio/virtio_pci.h b/drivers/virtio/virtio_pci_common.h
similarity index 97%
rename from drivers/virtio/virtio_pci.h
rename to drivers/virtio/virtio_pci_common.h
index fba383c..d840dad 100644
--- a/drivers/virtio/virtio_pci.h
+++ b/drivers/virtio/virtio_pci_common.h
@@ -1,5 +1,5 @@
-#ifndef _DRIVERS_VIRTIO_VIRTIO_PCI_H
-#define _DRIVERS_VIRTIO_VIRTIO_PCI_H
+#ifndef _DRIVERS_VIRTIO_VIRTIO_PCI_COMMON_H
+#define _DRIVERS_VIRTIO_VIRTIO_PCI_COMMON_H
 /*
  * Virtio PCI driver - APIs for common functionality for all device versions
  *
diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci_common.c
similarity index 99%
rename from drivers/virtio/virtio_pci.c
rename to drivers/virtio/virtio_pci_common.c
index 5d6bc77..953057d 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -17,7 +17,7 @@
  *
  */
 
-#include "virtio_pci_legacy.c"
+#include "virtio_pci_common.h"
 
 /* wait for pending irq handlers */
 void vp_synchronize_vectors(struct virtio_device *vdev)
diff --git a/drivers/virtio/virtio_pci_legacy.c b/drivers/virtio/virtio_pci_legacy.c
index 1ca4422..db00119 100644
--- a/drivers/virtio/virtio_pci_legacy.c
+++ b/drivers/virtio/virtio_pci_legacy.c
@@ -17,7 +17,7 @@
  *
  */
 
-#include "virtio_pci.h"
+#include "virtio_pci_common.h"
 
 /* Qumranet donated their vendor ID for devices 0x1000 thru 0x10FF. */
 static const struct pci_device_id virtio_pci_id_table[] = {
diff --git a/drivers/virtio/Makefile b/drivers/virtio/Makefile
index 9076635..bf5104b 100644
--- a/drivers/virtio/Makefile
+++ b/drivers/virtio/Makefile
@@ -1,4 +1,5 @@
 obj-$(CONFIG_VIRTIO) += virtio.o virtio_ring.o
 obj-$(CONFIG_VIRTIO_MMIO) += virtio_mmio.o
 obj-$(CONFIG_VIRTIO_PCI) += virtio_pci.o
+virtio_pci-y := virtio_pci_legacy.o virtio_pci_common.o
 obj-$(CONFIG_VIRTIO_BALLOON) += virtio_balloon.o
-- 
MST

