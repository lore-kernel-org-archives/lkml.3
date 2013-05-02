Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867Ab3EBA1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 20:27:47 -0400
Received: from ozlabs.org ([203.10.76.45]:55539 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845Ab3EBA1m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 20:27:42 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "lkml" <linux-kernel@vger.kernel.org>
Cc: Amit Shah <amit.shah@redhat.com>
Cc: Amos Kong <kongjianjun@gmail.com>
Cc: Asias He <asias@redhat.com>
Cc: Cosmin Paraschiv <csmnprschv@gmail.com>
Cc: Daniel Baluta <dbaluta@ixiacom.com>
Cc: Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Erwan Yvin <erwan.yvin@stericsson.com>
Cc: Mateusz Guzik <mguzik@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Milos Vyletel <milos.vyletel@sde.cz>
Cc: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Paul Bolle <pebolle@tiscali.nl>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Sjur Brendeland <sjur.brandeland@stericsson.com>
Cc: Venkatesh Srinivas <venkateshs@google.com>
Cc: Vikram Arv <vikram.arv@stericsson.com>
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: [PULL] virtio & lguest
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 02 May 2013 09:42:02 +0930
Message-ID: <87fvy6qlyl.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6dbe51c251a327e012439c4772097a13df43c5b8:

  Linux 3.9-rc1 (2013-03-03 15:11:05 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git tags/virtio-next-for-linus

for you to fetch changes up to 01d779a14ef800b74684d9692add4944df052461:

  caif_virtio: Remove bouncing email addresses (2013-05-01 11:59:15 +0930)

----------------------------------------------------------------
Lots of virtio work which wasn't quite ready for last merge window.  Plus
I dived into lguest again, reworking the pagetable code so we can move
the switcher page: our fixmaps sometimes take more than 2MB now...

Cheers,
Rusty.

----------------------------------------------------------------
Amit Shah (1):
      virtio: console: replace EMFILE with EBUSY for already-open port

Amos Kong (1):
      MAINTAINERS: add missing entries for virtio

Cosmin Paraschiv (1):
      lguest: improve code readability in lg_cpu_start.

Erwan Yvin (1):
      caif_virtio: Introduce caif over virtio

Michael S. Tsirkin (1):
      tools/virtio: fix build for 3.8

Milos Vyletel (1):
      virtio-blk: emit udev event when device is resized

Paolo Bonzini (7):
      scatterlist: introduce sg_unmark_end
      virtio-blk: reorganize virtblk_add_req
      virtio-blk: use virtqueue_add_sgs on bio path
      virtio-blk: use virtqueue_add_sgs on req path
      virtio-scsi: pass struct virtio_scsi to virtqueue completion function
      virtio-scsi: push vq lock/unlock into virtscsi_vq_done
      virtio-scsi: introduce multiqueue support

Paul Bolle (1):
      virtio: do not export "u16" and "u64" to userspace

Rusty Russell (31):
      Remove Documentation/virtual/virtio-spec.txt
      virtio_ring: expose virtio barriers for use in vringh.
      tools/virtio: separate headers more.
      vringh: host-side implementation of virtio rings.
      tools/virtio: add vring_test.
      virtio_ring: virtqueue_add_sgs, to add multiple sgs.
      virtio_ring: virtqueue_add_outbuf / virtqueue_add_inbuf.
      tools/virtio: make vringh_test use inbuf/outbuf.
      virtio_blk: remove nents member.
      virtio_scsi: use virtqueue_add_inbuf() for virtscsi_kick_event.
      virtio_net: use virtqueue_add_sgs[] for command buffers.
      virtio_net: use simplified virtqueue accessors.
      virtio_rng: use simplified virtqueue accessors.
      virtio_console: use simplified virtqueue accessors.
      caif_virtio: use simplified virtqueue accessors.
      virtio_rpmsg_bus: use simplified virtqueue accessors.
      virtio_balloon: use simplified virtqueue accessors.
      9p/trans_virtio.c: use virtio_add_sgs[]
      tools/virtio: remove virtqueue_add_buf() from tests.
      lguest: prepare to make SWITCHER_ADDR a variable.
      lguest: check vaddr not pgd for Switcher protection.
      lguest: remove RESERVE_MEM constant.
      lguest: rename switcher_page to switcher_pages.
      lguest: assume Switcher text is a single page.
      lguest: make check_gpte et. al return bool.
      lguest: extract shadow PTE walking / allocating.
      lguest: expost switcher_pages array (as lg_switcher_pages).
      lguest: don't share Switcher PTE pages between guests.
      lguest: map Switcher text whenever we allocate a new pagetable.
      lguest: cache last cpu we ran on.
      lguest: map Switcher below fixmap.

Sasha Levin (1):
      virtio-net: fill only rx queues which are being used

Sjur Brændeland (4):
      virtio: Introduce vringh wrappers in virtio_config
      caif_virtio: Use vringh_notify_enable correctly
      caif_virtio: Check that vringh_config is not null
      caif_virtio: Remove bouncing email addresses

Wanlong Gao (5):
      lguest: fix paths in comments
      virtio-scsi: use pr_err() instead of printk()
      virtio-scsi: use virtqueue_add_sgs for command buffers
      virtio-scsi: redo allocation of target data
      virtio-scsi: reset virtqueue affinity when doing cpu hotplug

Wei Yongjun (2):
      caif_virtio: fix error return code in cfv_create_genpool()
      virtio_console: make local symbols static

 Documentation/virtual/00-INDEX          |    3 -
 Documentation/virtual/virtio-spec.txt   | 3210 -------------------------------
 MAINTAINERS                             |    1 +
 arch/x86/include/asm/lguest.h           |   17 +-
 block/blk-integrity.c                   |    2 +-
 block/blk-merge.c                       |    2 +-
 drivers/Makefile                        |    2 +-
 drivers/block/virtio_blk.c              |  148 +-
 drivers/char/hw_random/virtio-rng.c     |    2 +-
 drivers/char/virtio_console.c           |   14 +-
 drivers/lguest/Kconfig                  |    5 +-
 drivers/lguest/core.c                   |   67 +-
 drivers/lguest/lg.h                     |    6 +-
 drivers/lguest/lguest_user.c            |    6 +-
 drivers/lguest/page_tables.c            |  567 +++---
 drivers/lguest/x86/core.c               |    7 +-
 drivers/net/caif/Kconfig                |   14 +
 drivers/net/caif/Makefile               |    3 +
 drivers/net/caif/caif_virtio.c          |  790 ++++++++
 drivers/net/virtio_net.c                |   77 +-
 drivers/rpmsg/virtio_rpmsg_bus.c        |    8 +-
 drivers/scsi/virtio_scsi.c              |  487 +++--
 drivers/vhost/Kconfig                   |    8 +
 drivers/vhost/Kconfig.tcm               |    1 +
 drivers/vhost/Makefile                  |    2 +
 drivers/vhost/test.c                    |    4 +-
 drivers/vhost/vringh.c                  | 1007 ++++++++++
 drivers/virtio/virtio_balloon.c         |    6 +-
 drivers/virtio/virtio_ring.c            |  297 ++-
 include/linux/scatterlist.h             |   16 +
 include/linux/virtio.h                  |   20 +
 include/linux/virtio_caif.h             |   24 +
 include/linux/virtio_ring.h             |   57 +
 include/linux/vringh.h                  |  225 +++
 include/uapi/linux/virtio_balloon.h     |    4 +-
 include/uapi/linux/virtio_ids.h         |    1 +
 net/9p/trans_virtio.c                   |   48 +-
 tools/lguest/lguest.txt                 |    2 +-
 tools/virtio/Makefile                   |   10 +-
 tools/virtio/asm/barrier.h              |   14 +
 tools/virtio/linux/bug.h                |   10 +
 tools/virtio/linux/err.h                |   26 +
 tools/virtio/linux/export.h             |    5 +
 tools/virtio/linux/irqreturn.h          |    1 +
 tools/virtio/linux/kernel.h             |  112 ++
 tools/virtio/linux/module.h             |    1 +
 tools/virtio/linux/printk.h             |    4 +
 tools/virtio/linux/ratelimit.h          |    4 +
 tools/virtio/linux/scatterlist.h        |  189 ++
 tools/virtio/linux/types.h              |   28 +
 tools/virtio/linux/uaccess.h            |   50 +
 tools/virtio/linux/uio.h                |    3 +
 tools/virtio/linux/virtio.h             |  171 +-
 tools/virtio/linux/virtio_config.h      |    6 +
 tools/virtio/linux/virtio_ring.h        |    1 +
 tools/virtio/linux/vringh.h             |    1 +
 tools/virtio/uapi/linux/uio.h           |    1 +
 tools/virtio/uapi/linux/virtio_config.h |    1 +
 tools/virtio/uapi/linux/virtio_ring.h   |    4 +
 tools/virtio/virtio_test.c              |   13 +-
 tools/virtio/vringh_test.c              |  741 +++++++
 61 files changed, 4482 insertions(+), 4074 deletions(-)
 delete mode 100644 Documentation/virtual/virtio-spec.txt
 create mode 100644 drivers/net/caif/caif_virtio.c
 create mode 100644 drivers/vhost/vringh.c
 create mode 100644 include/linux/virtio_caif.h
 create mode 100644 include/linux/vringh.h
 create mode 100644 tools/virtio/asm/barrier.h
 create mode 100644 tools/virtio/linux/bug.h
 create mode 100644 tools/virtio/linux/err.h
 create mode 100644 tools/virtio/linux/export.h
 create mode 100644 tools/virtio/linux/irqreturn.h
 create mode 100644 tools/virtio/linux/kernel.h
 create mode 100644 tools/virtio/linux/printk.h
 create mode 100644 tools/virtio/linux/ratelimit.h
 create mode 100644 tools/virtio/linux/scatterlist.h
 create mode 100644 tools/virtio/linux/types.h
 create mode 100644 tools/virtio/linux/uaccess.h
 create mode 100644 tools/virtio/linux/uio.h
 create mode 100644 tools/virtio/linux/virtio_config.h
 create mode 100644 tools/virtio/linux/virtio_ring.h
 create mode 100644 tools/virtio/linux/vringh.h
 create mode 100644 tools/virtio/uapi/linux/uio.h
 create mode 100644 tools/virtio/uapi/linux/virtio_config.h
 create mode 100644 tools/virtio/uapi/linux/virtio_ring.h
 create mode 100644 tools/virtio/vringh_test.c
