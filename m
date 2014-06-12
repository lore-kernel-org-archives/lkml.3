Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785AbaFLDIl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 23:08:41 -0400
Received: from ozlabs.org ([103.22.144.67]:58627 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755666AbaFLDIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 23:08:39 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "LKML" <linux-kernel@vger.kernel.org>
Cc: Amos Kong <akong@redhat.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Heinz Graalfs <graalfs@linux.vnet.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Subject: [PULL] virtio-next
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 12 Jun 2014 12:12:57 +0930
Message-ID: <87oaxyq24u.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit ec6931b281797b69e6cf109f9cc94d5a2bf994e0:

  word-at-a-time: avoid undefined behaviour in zero_bytemask macro (2014-04-27 15:20:05 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git tags/virtio-next-for-linus

for you to fetch changes up to c77fba9ab058d1e96ed51d4215e56905c9ef8d2a:

  virtio_scsi: don't call virtqueue_add_sgs(... GFP_NOIO) holding spinlock. (2014-05-21 11:25:41 +0930)

----------------------------------------------------------------
Main excitement is a virtio_scsi fix for alloc holding spinlock on the abort
path, which I refuse to CC stable since (1) I discovered it myself, and
(2) it's been there forever with no reports.

Cheers,
Rusty.
----------------------------------------------------------------
Amos Kong (1):
      virtio-rng: support multiple virtio-rng devices

Heinz Graalfs (1):
      virtio_ccw: introduce device_lost in virtio_ccw_device

Rusty Russell (2):
      virtio: virtio_break_device() to mark all virtqueues broken.
      virtio_scsi: don't call virtqueue_add_sgs(... GFP_NOIO) holding spinlock.

Sasha Levin (2):
      virtio-rng: fix boot with virtio-rng device
      virtio-rng: fixes for device registration/unregistration

 drivers/char/hw_random/virtio-rng.c | 105 +++++++++++++++++++++++-------------
 drivers/s390/kvm/virtio_ccw.c       |  49 ++++++++++++-----
 drivers/scsi/virtio_scsi.c          |  15 +++---
 drivers/virtio/virtio_ring.c        |  15 ++++++
 include/linux/virtio.h              |   2 +
 5 files changed, 127 insertions(+), 59 deletions(-)
