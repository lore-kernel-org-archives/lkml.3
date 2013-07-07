Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab3GGO2n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 10:28:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349Ab3GGO2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 10:28:39 -0400
Date: Sun, 7 Jul 2013 17:29:44 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: kvm@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>, Asias He <asias@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH] tools/virtio: move module license stub to module.h
Message-ID: <20130707142944.GA3022@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes build for the vringh test:
[linux]$ make -C tools/virtio/
make: Entering directory `/home/mst/scm/linux/tools/virtio'
cc -g -O2 -Wall -I. -I ../../usr/include/ -Wno-pointer-sign
-fno-strict-overflow -fno-strict-aliasing -fno-common -MMD
-U_FORTIFY_SOURCE   -c -o vringh.o ../../drivers/vhost/vringh.c
../../drivers/vhost/vringh.c:1010:16: error: expected declaration
specifiers or ‘...’ before string constant

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 tools/virtio/linux/module.h | 5 +++++
 tools/virtio/linux/virtio.h | 3 ---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/virtio/linux/module.h b/tools/virtio/linux/module.h
index 3039a7e..28ce95a 100644
--- a/tools/virtio/linux/module.h
+++ b/tools/virtio/linux/module.h
@@ -1 +1,6 @@
 #include <linux/export.h>
+
+#define MODULE_LICENSE(__MODULE_LICENSE_value) \
+	static __attribute__((unused)) const char *__MODULE_LICENSE_name = \
+		__MODULE_LICENSE_value
+
diff --git a/tools/virtio/linux/virtio.h b/tools/virtio/linux/virtio.h
index cd80183..8447830 100644
--- a/tools/virtio/linux/virtio.h
+++ b/tools/virtio/linux/virtio.h
@@ -45,9 +45,6 @@ struct virtqueue {
 	void *priv;
 };
 
-#define MODULE_LICENSE(__MODULE_LICENSE_value) \
-	const char *__MODULE_LICENSE_name = __MODULE_LICENSE_value
-
 /* Interfaces exported by virtio_ring. */
 int virtqueue_add_sgs(struct virtqueue *vq,
 		      struct scatterlist *sgs[],
-- 
MST
