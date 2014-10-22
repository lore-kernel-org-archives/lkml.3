Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbaJVPqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:46:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473AbaJVPqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:46:30 -0400
Date: Wed, 22 Oct 2014 18:50:05 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH RFC v2 00/14] linux: towards virtio-1 guest support
Message-ID: <1413992894-22976-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on patches by Cornelia and others, but
with an API that should allow better static checking of code,
and slightly more concervative changes in vring.

Cornelia Huck (4):
  virtio: allow transports to get avail/used addresses
  virtio_blk: use virtio v1.0 endian
  KVM: s390: virtio-ccw revision 1 SET_VQ
  KVM: s390: enable virtio-ccw revision 1

Michael S. Tsirkin (6):
  virtio: memory access APIs
  virtio_ring: switch to new memory access APIs
  virtio: add virtio 1.0 feature bit
  virtio: make endian-ness depend on virtio 1.0
  virtio_config: endian conversion for v1.0
  virtio: set FEATURES_OK

Rusty Russell (3):
  virtio: use u32, not bitmap for struct virtio_device's features
  virtio: add support for 64 bit features.
  virtio_net: use v1.0 endian.

Thomas Huth (1):
  KVM: s390: Set virtio-ccw transport revision

 include/linux/virtio.h                 |   6 +-
 include/linux/virtio_config.h          |  33 +++++--
 include/uapi/linux/virtio_config.h     |   9 +-
 include/uapi/linux/virtio_ring.h       |  49 +++++-----
 tools/virtio/linux/virtio.h            |  22 +----
 tools/virtio/linux/virtio_config.h     |   2 +-
 drivers/block/virtio_blk.c             |   4 +
 drivers/char/virtio_console.c          |   2 +-
 drivers/lguest/lguest_device.c         |  16 ++--
 drivers/net/virtio_net.c               |  31 ++++---
 drivers/remoteproc/remoteproc_virtio.c |   7 +-
 drivers/s390/kvm/kvm_virtio.c          |  10 +-
 drivers/s390/kvm/virtio_ccw.c          | 165 +++++++++++++++++++++++++++------
 drivers/virtio/virtio.c                |  47 ++++++----
 drivers/virtio/virtio_mmio.c           |  20 ++--
 drivers/virtio/virtio_pci.c            |   8 +-
 drivers/virtio/virtio_ring.c           | 109 +++++++++++++---------
 tools/virtio/virtio_test.c             |   5 +-
 tools/virtio/vringh_test.c             |  16 ++--
 include/uapi/linux/Kbuild              |   1 +
 20 files changed, 361 insertions(+), 201 deletions(-)

-- 
MST

