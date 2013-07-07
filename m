Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab3GGOTQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 10:19:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59884 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283Ab3GGOTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 10:19:12 -0400
Date: Sun, 7 Jul 2013 17:20:19 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: kvm@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] virtio: include asm/barrier explicitly
Message-ID: <20130707142019.GA2447@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio_ring.h uses mb() and friends, make
it pull in asm/barrier.h itself, not rely
on other headers to do it.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/linux/virtio_ring.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
index ca3ad41..b300787 100644
--- a/include/linux/virtio_ring.h
+++ b/include/linux/virtio_ring.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_VIRTIO_RING_H
 #define _LINUX_VIRTIO_RING_H
 
+#include <asm/barrier.h>
 #include <linux/irqreturn.h>
 #include <uapi/linux/virtio_ring.h>
 
-- 
MST
