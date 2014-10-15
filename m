Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463AbaJOO21 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 10:28:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313AbaJOO20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 10:28:26 -0400
Date: Wed, 15 Oct 2014 17:32:01 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>
Subject: [PATCH RFC v2 0/3] virtio_net: enabling tx interrupts
Message-ID: <1413383116-30977-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RFC patches to enable tx interrupts.
This is to demonstrate how this can be done without
core virtio changes, and to make sure I understand
the new APIs correctly.

Testing TBD: I'm going offline for several days, will only be able to
test afterwards (unless someone beats me to this).
So I thought I'd post this early.

Applies on top of patch: "virtio_net: fix use after free"
that I recently sent.

Changes:
	address comments by Jason Wang, use delayed cb everywhere
	rebased Jason's patch on top of mine and include it (with some tweaks)

Jason, feel free to either use this, try it out, or take ideas out
of this patchset and reuse in any other way you see fit.

Jason Wang (1):
  virtio-net: optimize free_old_xmit_skbs stats

Michael S. Tsirkin (2):
  virtio_net: enable tx interrupt
  virtio_net: bql

 drivers/net/virtio_net.c | 153 ++++++++++++++++++++++++++++++++++-------------
 1 file changed, 111 insertions(+), 42 deletions(-)

-- 
MST

