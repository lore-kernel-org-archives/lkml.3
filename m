Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbaJWQU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 12:20:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757AbaJWQU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 12:20:26 -0400
Date: Thu, 23 Oct 2014 19:24:01 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH RFC v4 00/17] linux: towards virtio-1 guest support
Message-ID: <1414081380-14623-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on patches by Cornelia Rusty and others, but
with an API that should allow better static checking of code,
and slightly more concervative changes in vring,net and blk.

Based on patches by Cornelia and others, but
with an API that should allow better static checking of code,
slightly more concervative changes in vring and drivers,
and compatibility for existing drivers so that
this series be applied before all drivers are converted.

virtio drivers now pass sparse without warnings.

Cornelia Huck (3):
  virtio: allow transports to get avail/used addresses
  KVM: s390: virtio-ccw revision 1 SET_VQ
  KVM: s390: enable virtio-ccw revision 1

Michael S. Tsirkin (11):
  virtio: memory access APIs
  virtio_ring: switch to new memory access APIs
  virtio: add virtio 1.0 feature bit
  virtio: make endian-ness depend on virtio 1.0
  virtio_config: endian conversion for v1.0
  virtio: set FEATURES_OK
  virtio: simplify feature bit handling
  virtio: add legacy feature table support
  virtio_net: v1.0 support
  virtio_blk: v1.0 support
  KVM: s390 allow virtio_ccw status writes to fail

Rusty Russell (2):
  virtio: use u32, not bitmap for struct virtio_device's features
  virtio: add support for 64 bit features.

Thomas Huth (1):
  KVM: s390: Set virtio-ccw transport revision

 include/linux/virtio.h                 |  10 +-
 include/linux/virtio_byteorder.h       |  59 +++++++++++
 include/linux/virtio_config.h          |  59 +++++++++--
 include/uapi/linux/virtio_blk.h        |  15 +--
 include/uapi/linux/virtio_config.h     |   9 +-
 include/uapi/linux/virtio_net.h        |  15 +--
 include/uapi/linux/virtio_ring.h       |  45 ++++-----
 include/uapi/linux/virtio_types.h      |  48 +++++++++
 tools/virtio/linux/virtio.h            |  22 +----
 tools/virtio/linux/virtio_config.h     |   2 +-
 drivers/block/virtio_blk.c             |  85 +++++++++-------
 drivers/char/virtio_console.c          |   2 +-
 drivers/lguest/lguest_device.c         |  16 +--
 drivers/net/virtio_net.c               |  34 ++++---
 drivers/remoteproc/remoteproc_virtio.c |   7 +-
 drivers/s390/kvm/kvm_virtio.c          |  10 +-
 drivers/s390/kvm/virtio_ccw.c          | 172 +++++++++++++++++++++++++++------
 drivers/virtio/virtio.c                |  67 +++++++++----
 drivers/virtio/virtio_mmio.c           |  20 ++--
 drivers/virtio/virtio_pci.c            |   8 +-
 drivers/virtio/virtio_ring.c           | 107 +++++++++++---------
 tools/virtio/virtio_test.c             |   5 +-
 tools/virtio/vringh_test.c             |  16 +--
 include/uapi/linux/Kbuild              |   1 +
 24 files changed, 584 insertions(+), 250 deletions(-)
 create mode 100644 include/linux/virtio_byteorder.h
 create mode 100644 include/uapi/linux/virtio_types.h

-- 
MST

