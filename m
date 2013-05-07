Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131Ab3EGLKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 07:10:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756201Ab3EGLKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 07:10:32 -0400
Date: Tue, 7 May 2013 14:10:24 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, asias@redhat.com,
        mst@redhat.com, pbonzini@redhat.com
Subject: [PULL] vhost: more fixes for 3.10
Message-ID: <20130507111024.GA18992@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I didn't do any back-merging tricks this time,
as a result this is behind master by quite a lot.
But I did a test merge and it came out correctly,
so this shouldn't be an issue.

The following changes since commit 181c04a357bb791587c55a99362c2fdde2c64f18:

  vhost_scsi: module rename (2013-05-02 13:40:22 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to a18cc421649dfdc21edb6c4c867dd05447d7df8c:

  vhost-scsi: Enable VIRTIO_RING_F_EVENT_IDX (2013-05-07 11:11:08 +0300)

----------------------------------------------------------------
vhost: more fixes for 3.10

This fixes some minor issues in the patches that have been merged.
We also finally drop the workaround disabling event_idx
for scsi: it was always questionable, and now we
know it's not needed.
There's also a memory leak fix.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Asias He (7):
      vhost: Export vhost_dev_set_owner
      vhost-net: Free ubuf when vhost_dev_set_owner fails
      vhost: Move VHOST_NET_FEATURES to net.c
      vhost: Remove comments for hdr in vhost.h
      vhost: Remove vhost_enable_zcopy in vhost.h
      vhost-net: Cleanup vhost_ubuf and vhost_zcopy
      vhost-scsi: Enable VIRTIO_RING_F_EVENT_IDX

Michael S. Tsirkin (1):
      vhost: drop virtio_net.h dependency

 drivers/vhost/net.c   | 100 +++++++++++++++++++++++++++++++++-----------------
 drivers/vhost/scsi.c  |   8 +---
 drivers/vhost/vhost.c |   4 +-
 drivers/vhost/vhost.h |  10 +----
 4 files changed, 71 insertions(+), 51 deletions(-)
