Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbaIKAwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 20:52:41 -0400
Received: from ozlabs.org ([103.22.144.67]:58801 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753260AbaIKAwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 20:52:40 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 0/3] virtio_net/virtio_ring.
Date: Thu, 11 Sep 2014 10:17:35 +0930
Message-Id: <1410396458-1165-1-git-send-email-rusty@rustcorp.com.au>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mainly for DaveM and MST to ack the first one, so I can apply the
second two.  Initializing the entire sg table is naive, but with cache
effects it only seems to help, so I didn't get fancy.

Cheers,
Rusty.

Rusty Russell (3):
  virtio_net: pass well-formed sgs to virtqueue_add_*()
  virtio_ring: assume sgs are always well-formed.
  virtio_ring: unify direct/indirect code paths.

 drivers/net/virtio_net.c     |   5 +-
 drivers/virtio/virtio_ring.c | 192 ++++++++++++++++---------------------------
 2 files changed, 73 insertions(+), 124 deletions(-)

-- 
1.9.1

