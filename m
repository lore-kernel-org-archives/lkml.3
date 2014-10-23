Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099AbaJWQ0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 12:26:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121AbaJWQU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 12:20:58 -0400
Date: Thu, 23 Oct 2014 19:24:25 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, linux-api@vger.kernel.org
Subject: [PATCH RFC v4 05/17] virtio: add virtio 1.0 feature bit
Message-ID: <1414081380-14623-6-git-send-email-mst@redhat.com>
References: <1414081380-14623-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414081380-14623-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on original patches by Rusty Russell, Thomas Huth
and Cornelia Huck.

Note: at this time, we do not negotiate this feature bit
in core, drivers have to declare VERSION_1 support explicitly.

After all drivers are converted, we will be able to
move VERSION_1 to core and drop it from all drivers.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
---
 include/uapi/linux/virtio_config.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/virtio_config.h b/include/uapi/linux/virtio_config.h
index 3ce768c..f3fe33a 100644
--- a/include/uapi/linux/virtio_config.h
+++ b/include/uapi/linux/virtio_config.h
@@ -41,11 +41,11 @@
 /* We've given up on this device. */
 #define VIRTIO_CONFIG_S_FAILED		0x80
 
-/* Some virtio feature bits (currently bits 28 through 31) are reserved for the
+/* Some virtio feature bits (currently bits 28 through 32) are reserved for the
  * transport being used (eg. virtio_ring), the rest are per-device feature
  * bits. */
 #define VIRTIO_TRANSPORT_F_START	28
-#define VIRTIO_TRANSPORT_F_END		32
+#define VIRTIO_TRANSPORT_F_END		33
 
 /* Do we get callbacks when the ring is completely used, even if we've
  * suppressed them? */
@@ -54,4 +54,7 @@
 /* Can the device handle any descriptor layout? */
 #define VIRTIO_F_ANY_LAYOUT		27
 
+/* v1.0 compliant. */
+#define VIRTIO_F_VERSION_1		32
+
 #endif /* _UAPI_LINUX_VIRTIO_CONFIG_H */
-- 
MST

