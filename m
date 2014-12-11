Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758742AbaLKThd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 14:37:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250AbaLKThc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 14:37:32 -0500
Date: Thu, 11 Dec 2014 21:37:22 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, cornelia.huck@de.ibm.com
Subject: [PATCH RFC 0/5] virtio_pci: modern driver
Message-ID: <1418326570-9541-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on Rusty's patches.
Coding style and funny jokes are his.
Bugs and a star wars reference (should be easy to spot) are mine.
Untested, but useful as basis for beginning the qemu work.

TODO:
= 	simplify probing: use a common probe function, probe with modern driver
	first, if that fails - probe with legacy driver.
BUGS:   ATM legacy driver can win and drive a transitional device
        Until this is fixed, to test, disable transitional mode in device

More ideas (optional):
=	allow disabling legacy driver
=	support shared IRQ for config, read ISR
=	allocate VQ ring in chunks, good for large rings
=	use less meory for small VQ ring in chunks, good for large rings

General TODOs:
=	add config generation support
=	move alloc_virtqueue_pages to virtio core, reuse in e.g. ccw

Michael S Tsirkin (1):
  pci: add pci_iomap_range

Michael S. Tsirkin (2):
  virtio_pci: add VIRTIO_PCI_NO_LEGACY
  virtio_pci: modern driver

Rusty Russell (2):
  virtio-pci: define layout for virtio 1.0
  virtio_pci: macros for PCI layout offsets.

 drivers/virtio/virtio_pci_common.h |  23 +-
 include/asm-generic/pci_iomap.h    |   5 +
 include/uapi/linux/virtio_pci.h    | 106 ++++++-
 drivers/virtio/virtio_pci_modern.c | 621 +++++++++++++++++++++++++++++++++++++
 lib/pci_iomap.c                    |  46 ++-
 drivers/virtio/Makefile            |   2 +-
 6 files changed, 788 insertions(+), 15 deletions(-)
 create mode 100644 drivers/virtio/virtio_pci_modern.c

-- 
MST

