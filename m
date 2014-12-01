Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbaLAQDo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 11:03:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649AbaLAQDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 11:03:42 -0500
Date: Mon, 1 Dec 2014 18:03:23 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, cornelia.huck@de.ibm.com,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, linux-api@vger.kernel.org
Subject: [PATCH v8 07/50] virtio: add virtio 1.0 feature bit
Message-ID: <1417449619-24896-8-git-send-email-mst@redhat.com>
References: <1417449619-24896-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417449619-24896-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on original patches by Rusty Russell, Thomas Huth
and Cornelia Huck.

Note: at this time, we do not negotiate this feature bit
in core, drivers have to declare VERSION_1 support explicitly.

For this reason we treat this bit as a device bit
and not as a transport bit for now.

After all drivers are converted, we will be able to
move VERSION_1 to core and drop it from all drivers.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
---
 include/uapi/linux/virtio_config.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/linux/virtio_config.h b/include/uapi/linux/virtio_config.h
index 3ce768c..80e7381 100644
--- a/include/uapi/linux/virtio_config.h
+++ b/include/uapi/linux/virtio_config.h
@@ -54,4 +54,7 @@
 /* Can the device handle any descriptor layout? */
 #define VIRTIO_F_ANY_LAYOUT		27
 
+/* v1.0 compliant. */
+#define VIRTIO_F_VERSION_1		32
+
 #endif /* _UAPI_LINUX_VIRTIO_CONFIG_H */
-- 
MST

