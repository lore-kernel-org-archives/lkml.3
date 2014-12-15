Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751121AbaLOVOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 16:14:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750723AbaLOVOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 16:14:08 -0500
Date: Mon, 15 Dec 2014 23:14:02 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 1/3] vringh: 64 bit features
Message-ID: <1418678019-31629-2-git-send-email-mst@redhat.com>
References: <1418678019-31629-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418678019-31629-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass u64 everywhere.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/linux/vringh.h | 4 ++--
 drivers/vhost/vringh.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/vringh.h b/include/linux/vringh.h
index 749cde2..f696dd0 100644
--- a/include/linux/vringh.h
+++ b/include/linux/vringh.h
@@ -105,7 +105,7 @@ struct vringh_kiov {
 #define VRINGH_IOV_ALLOCATED 0x8000000
 
 /* Helpers for userspace vrings. */
-int vringh_init_user(struct vringh *vrh, u32 features,
+int vringh_init_user(struct vringh *vrh, u64 features,
 		     unsigned int num, bool weak_barriers,
 		     struct vring_desc __user *desc,
 		     struct vring_avail __user *avail,
@@ -167,7 +167,7 @@ bool vringh_notify_enable_user(struct vringh *vrh);
 void vringh_notify_disable_user(struct vringh *vrh);
 
 /* Helpers for kernelspace vrings. */
-int vringh_init_kern(struct vringh *vrh, u32 features,
+int vringh_init_kern(struct vringh *vrh, u64 features,
 		     unsigned int num, bool weak_barriers,
 		     struct vring_desc *desc,
 		     struct vring_avail *avail,
diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 5174eba..ac3fe27 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -577,7 +577,7 @@ static inline int xfer_to_user(void *dst, void *src, size_t len)
  * Returns an error if num is invalid: you should check pointers
  * yourself!
  */
-int vringh_init_user(struct vringh *vrh, u32 features,
+int vringh_init_user(struct vringh *vrh, u64 features,
 		     unsigned int num, bool weak_barriers,
 		     struct vring_desc __user *desc,
 		     struct vring_avail __user *avail,
@@ -836,7 +836,7 @@ static inline int xfer_kern(void *src, void *dst, size_t len)
  *
  * Returns an error if num is invalid.
  */
-int vringh_init_kern(struct vringh *vrh, u32 features,
+int vringh_init_kern(struct vringh *vrh, u64 features,
 		     unsigned int num, bool weak_barriers,
 		     struct vring_desc *desc,
 		     struct vring_avail *avail,
-- 
MST

