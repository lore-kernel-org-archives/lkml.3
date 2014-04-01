Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608AbaDBFUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 01:20:35 -0400
Received: from ozlabs.org ([203.10.76.45]:38891 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755AbaDBFUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 01:20:34 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "LKML" <linux-kernel@vger.kernel.org>
Cc: Alexander Gordeev <agordeev@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Frank Swiderski <fes@google.com>
Cc: Gopesh Kumar Chaudhary <gopchaud@in.ibm.com>
Cc: Heinz Graalfs <graalfs@linux.vnet.ibm.com>
Cc: Joel Stanley <joel@jms.id.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: virtualization@lists.linux-foundation.org
Subject: [PULL] virtio-next
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Tue, 01 Apr 2014 13:28:12 +1030
Message-ID: <87bnwlpxh7.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 33807f4f0daec3b00565c2932d95f614f5833adf:

  Merge branch 'for-next' of git://git.samba.org/sfrench/cifs-2.6 (2014-03-11 11:53:42 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git tags/virtio-next-for-linus

for you to fetch changes up to fc4324b4597c4eb8907207e82f9a6acec84dd335:

  virtio-blk: base queue-depth on virtqueue ringsize or module param (2014-03-24 12:20:18 +1030)

----------------------------------------------------------------
Nothing exciting: virtio-blk users might see a bit of a boost from the
doubling of the default queue length though.

Cheers,
Rusty.

----------------------------------------------------------------
Alexander Gordeev (1):
      virtio: Use pci_enable_msix_exact() instead of pci_enable_msix()

Joel Stanley (3):
      tools/virtio: update internal copies of headers
      tools/virtio: fix missing kmemleak_ignore symbol
      tools/virtio: add a missing )

Randy Dunlap (1):
      MAINTAINERS: virtio-dev is subscribers only

Rusty Russell (8):
      virtio_balloon: don't softlockup on huge balloon changes.
      virtio_net: don't crash if virtqueue is broken.
      virtio_blk: don't crash, report error if virtqueue is broken.
      virtio_balloon: don't crash if virtqueue is broken.
      virtio-rng: don't crash if virtqueue is broken.
      virtio: fail adding buffer on broken queues.
      Revert a02bbb1ccfe8: MAINTAINERS: add virtio-dev ML for virtio
      virtio-blk: base queue-depth on virtqueue ringsize or module param

 MAINTAINERS                         |  3 ---
 drivers/block/virtio_blk.c          | 20 +++++++++++++++++---
 drivers/char/hw_random/virtio-rng.c |  3 +--
 drivers/net/virtio_net.c            |  2 +-
 drivers/virtio/virtio_balloon.c     | 14 +++++++++-----
 drivers/virtio/virtio_pci.c         |  6 ++----
 drivers/virtio/virtio_ring.c        | 12 +++++++++---
 tools/virtio/linux/kmemleak.h       |  3 +++
 tools/virtio/linux/virtio.h         |  4 ++--
 tools/virtio/virtio_test.c          |  2 +-
 10 files changed, 45 insertions(+), 24 deletions(-)
 create mode 100644 tools/virtio/linux/kmemleak.h
