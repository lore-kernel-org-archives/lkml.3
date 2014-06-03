Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933451AbaFCTbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 15:31:48 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:48268 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933372AbaFCTbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 15:31:44 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: hch@lst.de, JBottomley@Parallels.com, venkateshs@google.com
Subject: [PATCH 0/6] virtio-scsi patches for 3.16 + a midlayer one-liner
Date: Tue,  3 Jun 2014 21:31:27 +0200
Message-Id: <1401823893-29028-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delay, mostly caused by the discussion and testing of
patch 5.  That's the most important of the bunch, and debugging the
problem also led to the discovery of a midlayer bug fixed by patch 4.

I hope these can make their way into 3.16.  Thanks!

Paolo


Ming Lei (2):
  virtio_scsi: remove ACCESS_ONCE() and smp_read_barrier_depends()
  virtio-scsi: replace target spinlock with seqcount

Paolo Bonzini (2):
  virtio-scsi: avoid cancelling uninitialized work items
  virtio-scsi: fix various bad behavior on aborted requests

Ulrich Obergfell (1):
  scsi_error: fix invalid setting of host byte

Venkatesh Srinivas (1):
  virtio-scsi: Implement change_queue_depth for virtscsi targets

 drivers/scsi/scsi_error.c  |   2 +-
 drivers/scsi/virtio_scsi.c | 148 +++++++++++++++++++++++++++------------------
 2 files changed, 91 insertions(+), 59 deletions(-)

-- 
1.8.3.1

