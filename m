Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358AbaFKNom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 09:44:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755679AbaFKNok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 09:44:40 -0400
Date: Wed, 11 Jun 2014 16:44:47 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: nab@daterainc.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        sfr@canb.auug.org.au, linux-scsi@vger.kernel.org
Subject: [PULL] vhost: infrastructure changes for 3.16
Message-ID: <20140611134447.GA8208@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,
Please pull the following.
Please note this needs to be merged before merging
target-pending PULL which Nicholas will be sending
out shortly.

Thanks!

The following changes since commit 1860e379875dfe7271c649058aeddffe5afd9d0d:

  Linux 3.15 (2014-06-08 11:19:54 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 47283bef7ed356629467d1fac61687756e48f254:

  vhost: move memory pointer to VQs (2014-06-09 16:21:07 +0300)

----------------------------------------------------------------
vhost: infrastructure changes for 3.16

This reworks vhost core dropping unnecessary RCU uses in favor of VQ mutexes
which are used on fast path anyway.  This fixes worst-case latency for users
which change the memory mappings a lot.
Memory allocation for vhost-net now supports fallback on vmalloc (same as for
vhost-scsi) this makes it possible to create the device on systems where memory
is very fragmented, with slightly lower performance.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Michael S. Tsirkin (4):
      vhost-net: extend device allocation to vmalloc
      vhost: replace rcu with mutex
      vhost: move acked_features to VQs
      vhost: move memory pointer to VQs

 drivers/vhost/vhost.h | 19 ++++------
 drivers/vhost/net.c   | 35 ++++++++++++-------
 drivers/vhost/scsi.c  | 26 ++++++++------
 drivers/vhost/test.c  | 11 +++---
 drivers/vhost/vhost.c | 97 ++++++++++++++++++++++++++-------------------------
 5 files changed, 101 insertions(+), 87 deletions(-)
