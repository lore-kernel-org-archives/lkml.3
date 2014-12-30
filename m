Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468AbaL3Qfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 11:35:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbaL3Qfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 11:35:39 -0500
Date: Tue, 30 Dec 2014 18:35:30 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, cornelia.huck@de.ibm.com
Subject: [PATCH RFC v2 0/7] virtio-pci: towards virtio 1.0 guest support
Message-ID: <1419957310-26009-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is only very lightly tested, and I'll probably split it up and do minor
changes for ease of review, but I thought I'd post it now that it actually
works.

Michael S Tsirkin (2):
  pci: add pci_iomap_range
  s390: add pci_iomap_range

Michael S. Tsirkin (4):
  mn10300: drop dead code
  virtio_pci: modern driver
  virtio_pci: macros for PCI layout offsets.
  virtio_pci: drop virtio_config dependency

Rusty Russell (1):
  virtio-pci: define layout for virtio 1.0

 arch/s390/include/asm/pci_io.h        |   1 +
 drivers/virtio/virtio_pci_common.h    |  29 +-
 include/asm-generic/pci_iomap.h       |  10 +
 include/uapi/linux/virtio_pci.h       |  94 ++++-
 arch/mn10300/unit-asb2305/pci-iomap.c |  35 --
 arch/s390/pci/pci.c                   |  34 +-
 drivers/virtio/virtio_pci_common.c    |  13 +-
 drivers/virtio/virtio_pci_modern.c    | 708 ++++++++++++++++++++++++++++++++++
 lib/pci_iomap.c                       |  35 +-
 drivers/virtio/Makefile               |   2 +-
 10 files changed, 908 insertions(+), 53 deletions(-)
 delete mode 100644 arch/mn10300/unit-asb2305/pci-iomap.c
 create mode 100644 drivers/virtio/virtio_pci_modern.c

-- 
MST

