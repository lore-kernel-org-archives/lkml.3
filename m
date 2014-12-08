Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbaLHNGN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 08:06:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514AbaLHNGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 08:06:11 -0500
Date: Mon, 8 Dec 2014 15:05:48 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: dahi@linux.vnet.ibm.com, cornelia.huck@de.ibm.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v3 0/6] virtio 1.0 enhancements
Message-ID: <1418042769-25539-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are minor robustness enhancements on top of v8 of the patchset
	[PATCH v8 00/50] linux: towards virtio-1 guest support
http://mid.gmane.org/1417449619-24896-1-git-send-email-mst@redhat.com

As that one seems stable and actually seems to work well for people,
I'm not respinning it anymore.

The main motivation is to prevent us accidentally supporting
bad configurations, such as legacy balloon on top of
virtio 1.0 transport.
The point is that if we happen to support them mistakenly, we'll have trouble
backing out in future.  This will also help make sure hypervisors don't do
silly things.

Changes from v2:
	Check finalize_features return status on resume.
		This shouldn't normally fail, but checking can't hurt.

Michael S. Tsirkin (6):
  virtio: add API to detect legacy devices
  virtio_ccw: legacy: don't negotiate rev 1/features
  virtio: allow finalize_features to fail
  virtio_ccw: rev 1 devices set VIRTIO_F_VERSION_1
  virtio_balloon: drop legacy_only driver flag
  virtio: drop legacy_only driver flag

 include/linux/virtio.h                 |  4 ++--
 include/linux/virtio_config.h          |  3 ++-
 drivers/lguest/lguest_device.c         |  4 +++-
 drivers/misc/mic/card/mic_virtio.c     |  4 +++-
 drivers/remoteproc/remoteproc_virtio.c |  4 +++-
 drivers/s390/kvm/kvm_virtio.c          |  4 +++-
 drivers/s390/kvm/virtio_ccw.c          | 29 ++++++++++++++++++++++++-----
 drivers/virtio/virtio.c                | 32 +++++++++++++++++++++-----------
 drivers/virtio/virtio_balloon.c        |  1 -
 drivers/virtio/virtio_mmio.c           |  4 +++-
 drivers/virtio/virtio_pci.c            |  4 +++-
 11 files changed, 67 insertions(+), 26 deletions(-)

-- 
MST

