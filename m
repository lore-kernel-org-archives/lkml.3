Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab3BSIJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 03:09:21 -0500
Received: from ozlabs.org ([203.10.76.45]:43659 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758158Ab3BSICo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 03:02:44 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Asias He <asias@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 00/16] virtio ring rework.
Date: Tue, 19 Feb 2013 18:26:18 +1030
Message-Id: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, this is (ab)uses some of Paolo's patches.  The first 7 are
candidates for this merge window (maybe), the rest I'm not so sure
about.

Thanks,
Rusty.

Paolo Bonzini (3):
  scatterlist: introduce sg_unmark_end
  virtio-blk: reorganize virtblk_add_req
  virtio-blk: use virtqueue_add_sgs on req path

Rusty Russell (13):
  virtio_ring: virtqueue_add_sgs, to add multiple sgs.
  virtio-blk: use virtqueue_start_buf on bio path
  virtio_blk: remove nents member.
  virtio_ring: don't count elements twice for add_buf path.
  virtio_ring: virtqueue_add_outbuf / virtqueue_add_inbuf.
  virtio_net: use simplified virtqueue accessors.
  virtio_net: use virtqueue_add_sgs[] for command buffers.
  virtio_rng: use simplified virtqueue accessors.
  virtio_console: use simplified virtqueue accessors.
  caif_virtio: use simplified virtqueue accessors.
  virtio_rpmsg_bus: use simplified virtqueue accessors.
  virtio_balloon: use simplified virtqueue accessors.
  9p/trans_virtio.c: use virtio_add_sgs[]

 block/blk-integrity.c               |    2 +-
 block/blk-merge.c                   |    2 +-
 drivers/block/virtio_blk.c          |  146 +++++++++-----------
 drivers/char/hw_random/virtio-rng.c |    2 +-
 drivers/char/virtio_console.c       |    6 +-
 drivers/net/caif/caif_virtio.c      |    3 +-
 drivers/net/virtio_net.c            |   61 ++++-----
 drivers/rpmsg/virtio_rpmsg_bus.c    |    8 +-
 drivers/virtio/virtio_balloon.c     |    6 +-
 drivers/virtio/virtio_ring.c        |  253 ++++++++++++++++++++++++++---------
 include/linux/scatterlist.h         |   16 +++
 include/linux/virtio.h              |   17 +++
 net/9p/trans_virtio.c               |   48 +++++--
 13 files changed, 371 insertions(+), 199 deletions(-)

-- 
1.7.10.4

