Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab3KGLfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 06:35:48 -0500
Received: from ozlabs.org ([203.10.76.45]:37248 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783Ab3KGLfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 06:35:46 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "LKML" <linux-kernel@vger.kernel.org>
Cc: Aaron Lu <aaron.lu@intel.com>
Cc: Amit Shah <amit.shah@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Paasch <christoph.paasch@uclouvain.be>
Cc: Heinz Graalfs <graalfs@linux.vnet.ibm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Pawel Moll <pawel.moll@arm.com>
Subject: [PULL] virtio-next
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 07 Nov 2013 21:57:17 +1030
Message-ID: <87eh6s5u5m.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d8524ae9d6f492a9c6db9f4d89c5f9b8782fa2d5:

  Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux (2013-09-22 19:51:49 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git tags/virtio-next-for-linus

for you to fetch changes up to cdd77e87eae52b7251acc5990207a1c4500a84ce:

  x86, asmlinkage, lguest: Pass in globals into assembler statement (2013-11-07 12:13:05 +1030)

----------------------------------------------------------------
Nothing really exciting: some groundwork for changing virtio endian, and
some robustness fixes for broken virtio devices, plus minor tweaks.

Cheers,
Rusty.

----------------------------------------------------------------
Aaron Lu (1):
      virtio: pm: use CONFIG_PM_SLEEP instead of CONFIG_PM

Andi Kleen (1):
      x86, asmlinkage, lguest: Pass in globals into assembler statement

Heinz Graalfs (9):
      virtio_ring: change host notification API
      virtio_ring: let virtqueue_{kick()/notify()} return a bool
      virtio_net: verify if virtqueue_kick() succeeded
      virtio_test: verify if virtqueue_kick() succeeded
      virtio_ring: add new function virtqueue_is_broken()
      virtio_blk: verify if queue is broken after virtqueue_get_buf()
      virtio_console: verify if queue is broken after virtqueue_get_buf()
      virtio_net: verify if queue is broken after virtqueue_get_buf()
      virtio_ring: adapt to notify() returning bool

Marc Zyngier (1):
      virtio: mmio: fix signature checking for BE guests

Rusty Russell (4):
      virtio_ring: plug kmemleak false positive.
      virtio_config: introduce size-based accessors.
      virtio: use size-based config accessors.
      virtio_config: remove virtio_config_val

 drivers/block/virtio_blk.c             |  83 ++++++++---------
 drivers/char/hw_random/virtio-rng.c    |   4 +-
 drivers/char/virtio_console.c          |  25 +++--
 drivers/lguest/lguest_device.c         |   3 +-
 drivers/lguest/x86/core.c              |   6 +-
 drivers/net/caif/caif_virtio.c         |  23 ++---
 drivers/net/virtio_net.c               |  44 +++++----
 drivers/remoteproc/remoteproc_virtio.c |   3 +-
 drivers/s390/kvm/kvm_virtio.c          |   8 +-
 drivers/s390/kvm/virtio_ccw.c          |   5 +-
 drivers/scsi/virtio_scsi.c             |  16 ++--
 drivers/virtio/virtio_balloon.c        |  14 ++-
 drivers/virtio/virtio_mmio.c           |   5 +-
 drivers/virtio/virtio_pci.c            |   3 +-
 drivers/virtio/virtio_ring.c           |  34 +++++--
 include/linux/virtio.h                 |   6 +-
 include/linux/virtio_config.h          | 161 +++++++++++++++++++++++++++------
 include/linux/virtio_ring.h            |   2 +-
 net/9p/trans_virtio.c                  |   9 +-
 tools/virtio/virtio_test.c             |   6 +-
 tools/virtio/vringh_test.c             |  13 ++-
 21 files changed, 307 insertions(+), 166 deletions(-)
