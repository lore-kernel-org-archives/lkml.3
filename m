Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933194Ab3BLNGp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 08:06:45 -0500
Received: from mail-ve0-f175.google.com ([209.85.128.175]:57443 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932967Ab3BLNGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 08:06:44 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>, asias@redhat.com, mst@redhat.com,
        Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux-scsi@vger.kernel.org,
        JBottomley@parallels.com
Subject: [PATCH v3 0/5] virtio-scsi multiqueue
Date: Tue, 12 Feb 2013 14:06:26 +0100
Message-Id: <1360674391-2661-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series implements virtio-scsi queue steering, which gives
performance improvements of up to 50% (measured both with QEMU and
tcm_vhost backends).  The patches build on top of the new virtio APIs
at http://permalink.gmane.org/gmane.linux.kernel.virtualization/18431;
the new API simplifies the locking of the virtio-scsi driver nicely,
thus it makes sense to require them as a prerequisite.

Changes from the previous post, which can be found at
http://permalink.gmane.org/gmane.linux.kernel.virtualization/17869:

- patches 1 and 2 ("virtio: add functions for piecewise addition of
  buffers", "virtio-scsi: use functions for piecewise composition of
  buffers") split into their own series

- new cleanup patch "virtio-scsi: push vq lock/unlock into virtscsi_vq_done"

- reorganized code to move ACCESS_ONCE in a clearer place

- included Wanlong Gao's CPU hotplug patches

Ok for 3.9?  It would probably be easier to get it in via Rusty's tree
because of the prerequisites.  James, can I get your Acked-by?

Paolo

Paolo Bonzini (4):
  virtio-scsi: redo allocation of target data
  virtio-scsi: pass struct virtio_scsi to virtqueue completion function
  virtio-scsi: push vq lock/unlock into virtscsi_vq_done
  virtio-scsi: introduce multiqueue support

Wanlong Gao (1):
  virtio-scsi: reset virtqueue affinity when doing cpu hotplug

 drivers/scsi/virtio_scsi.c |  360 +++++++++++++++++++++++++++++++++++---------
 1 files changed, 292 insertions(+), 68 deletions(-)

