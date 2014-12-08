Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787AbaLHPQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 10:16:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229AbaLHPQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 10:16:36 -0500
Date: Mon, 8 Dec 2014 17:16:33 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH v2 00/10] virtio_pci: split out legacy device support
Message-ID: <1418051779-27748-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry about sending two versions in such quick order -
it turns out v1 was broken on modular kernels,
so I'm sending v2 to make these configs testable as well.

virtio 1.0 support for virtio-pci isn't ready yet.
Therefore, this patchset doesn't make any functional changes.
Instead, this simply refactors virtio-pci, splitting legacy
device support code out to a separate file: virtio_pci_legacy.c

For virtio 1.0, all that's left is to add virtio_pci_modern.c
supporting
	get_features
	finalize_features
	get (config)
	set (config)
	get_status
	set_status
	reset
	setup_vq
	del_vq
	probe
	remove

Most notably, tricky MSI-X vector probing logic stays
in common file: virtio_pci.c. version-specific only has
to code setup/del functions for individual vqs.

Note: to keep patch size down, I avoid big file changes
and renames in the same patch, so I resort to
	#include "virtio_pci_legacy.c"
which is ugly, but is there only as an intermediate step.

Changes from v2:
	rename virtio_pci ->virtio_pci_common, to keep
	kbuild happy for modular builds.


Michael S. Tsirkin (10):
  virtio_pci: add isr field
  virtio_pci: fix coding style for structs
  virtio_pci: free up vq->priv
  virtio_pci: use priv for vq notification
  virtio_pci: delete vqs indirectly
  virtio_pci: setup vqs indirectly
  virtio_pci: setup config vector indirectly
  virtio_pci: split out legacy device support
  virtio_pci: update file descriptions and copyright
  virtio_pci: rename virtio_pci -> virtio_pci_common

 drivers/virtio/virtio_pci_common.h | 136 +++++++
 drivers/virtio/virtio_pci.c        | 806 -------------------------------------
 drivers/virtio/virtio_pci_common.c | 464 +++++++++++++++++++++
 drivers/virtio/virtio_pci_legacy.c | 326 +++++++++++++++
 drivers/virtio/Makefile            |   1 +
 5 files changed, 927 insertions(+), 806 deletions(-)
 create mode 100644 drivers/virtio/virtio_pci_common.h
 delete mode 100644 drivers/virtio/virtio_pci.c
 create mode 100644 drivers/virtio/virtio_pci_common.c
 create mode 100644 drivers/virtio/virtio_pci_legacy.c

-- 
MST

