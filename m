Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab3EIOyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 10:54:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091Ab3EIOye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 10:54:34 -0400
From: Luiz Capitulino <lcapitulino@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, riel@redhat.com,
        aquini@redhat.com, mst@redhat.com, amit.shah@redhat.com,
        anton@enomsg.org
Subject: [RFC v2 0/2] virtio_balloon: auto-ballooning support
Date: Thu,  9 May 2013 10:53:47 -0400
Message-Id: <1368111229-29847-1-git-send-email-lcapitulino@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series is a respin of automatic ballooning support I started
working on last year. Patch 2/2 contains all relevant technical
details and performance measurements results.

This is in RFC state because it's a work in progress.

Here's some information if you want to try automatic ballooning:

 1. You'll need 3.9+ for the host kernel
 2. Apply this series for the guest kernel
 3. Grab the QEMU bits from:
    git://repo.or.cz/qemu/qmp-unstable.git balloon/auto-ballooning/memcg/rfc
 4. Enable the balloon device in qemu with:
    -device virtio-balloon-pci,auto-balloon=true
 5. Balloon the guest memory down, say from 1G to 256MB
 6. Generate some pressure in the guest, say a kernel build with -j16

Any feedback is appreciated!

Luiz Capitulino (2):
  virtio_balloon: move balloon_lock mutex to callers
  virtio_balloon: auto-ballooning support

 drivers/virtio/virtio_balloon.c     | 63 ++++++++++++++++++++++++++++++++++---
 include/uapi/linux/virtio_balloon.h |  1 +
 2 files changed, 60 insertions(+), 4 deletions(-)

-- 
1.8.1.4
