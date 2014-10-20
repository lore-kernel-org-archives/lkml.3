Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbaJTGs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 02:48:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484AbaJTGs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 02:48:57 -0400
Date: Mon, 20 Oct 2014 09:52:31 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>
Subject: [PATCH RFC v3 0/3] virtio_net: enabling tx interrupts
Message-ID: <1413787824-16130-1-git-send-email-mst@redhat.com>
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

Testing TBD, I was asked for a version for early testing.

Applies on top of patch: "virtio_net: fix use after free"
that I recently sent.

Changes from v3:
	clean up code, address issues raised by Jason
Changes from v1:
        address comments by Jason Wang, use delayed cb everywhere
        rebased Jason's patch on top of mine and include it (with some tweaks)

Jason Wang (1):
  virtio-net: optimize free_old_xmit_skbs stats

Michael S. Tsirkin (2):
  virtio_net: enable tx interrupt
  virtio_net: bql

 drivers/net/virtio_net.c | 144 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 101 insertions(+), 43 deletions(-)

-- 
MST

