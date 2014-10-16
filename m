Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbaJPXQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 19:16:13 -0400
Received: from ozlabs.org ([103.22.144.67]:58226 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097AbaJPXQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 19:16:06 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "LKML" <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>
Cc: Amit Shah <amit.shah@redhat.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PULL] More virtio fun
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 17 Oct 2014 09:41:26 +1030
Message-ID: <87r3y7a9up.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 7ec62d421bdf29cb31101ae2689f7f3a9906289a:

  Merge branch 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs (2014-09-10 14:04:17 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git tags/virtio-next-for-linus

for you to fetch changes up to 1bbc26062754b012656d34103215f7552e02b999:

  virtio-rng: refactor probe error handling (2014-10-15 10:25:14 +1030)

----------------------------------------------------------------
One cc: stable commit, the rest are a series of minor cleanups which have
been sitting in MST's tree during my vacation.  I changed a function name
and made one trivial change, then they spent two days in linux-next.

Thanks,
Rusty.

----------------------------------------------------------------
Michael S. Tsirkin (24):
      virtio_pci: fix virtio spec compliance on restore
      virtio: unify config_changed handling
      virtio-pci: move freeze/restore to virtio core
      virtio: defer config changed notifications
      virtio_blk: drop config_enable
      virtio-blk: drop config_mutex
      virtio_net: drop config_enable
      virtio-net: drop config_mutex
      virtio_net: minor cleanup
      virtio: add API to enable VQs early
      virtio_net: enable VQs early
      virtio_blk: enable VQs early
      virtio_console: enable VQs early
      9p/trans_virtio: enable VQs early
      virtio_net: fix use after free on allocation failure
      virtio_scsi: move kick event out from virtscsi_init
      virtio_blk: enable VQs early on restore
      virtio_scsi: enable VQs early on restore
      virtio_console: enable VQs early on restore
      virtio_net: enable VQs early on restore
      virtio_scsi: fix race on device removal
      virtio_balloon: enable VQs early on restore
      virtio_scsi: drop scan callback
      virtio-rng: refactor probe error handling

Paolo Bonzini (1):
      virito_scsi: use freezable WQ for events

 drivers/block/virtio_blk.c          |  40 ++++----------
 drivers/char/hw_random/virtio-rng.c |  15 +++---
 drivers/char/virtio_console.c       |   4 ++
 drivers/misc/mic/card/mic_virtio.c  |   6 +--
 drivers/net/virtio_net.c            |  44 +++++----------
 drivers/s390/kvm/kvm_virtio.c       |   9 +---
 drivers/s390/kvm/virtio_ccw.c       |   6 +--
 drivers/scsi/virtio_scsi.c          |  42 +++++++++------
 drivers/virtio/virtio.c             | 103 ++++++++++++++++++++++++++++++++++++
 drivers/virtio/virtio_balloon.c     |   2 +
 drivers/virtio/virtio_mmio.c        |   7 +--
 drivers/virtio/virtio_pci.c         |  33 ++----------
 include/linux/virtio.h              |  14 +++++
 include/linux/virtio_config.h       |  17 ++++++
 net/9p/trans_virtio.c               |   2 +
 15 files changed, 207 insertions(+), 137 deletions(-)
