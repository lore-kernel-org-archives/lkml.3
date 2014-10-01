Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbaJAXHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 19:07:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730AbaJAXHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 19:07:15 -0400
From: Andy Grover <agrover@redhat.com>
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, hch@lst.de, nab@linux-iscsi.org,
        shli@kernel.org, linux-kernel@vger.kernel.org, rjones@redhat.com
Subject: [PATCHv2 2/4] uio: Export definition of struct uio_device
Date: Wed,  1 Oct 2014 16:07:03 -0700
Message-Id: <1412204825-13292-3-git-send-email-agrover@redhat.com>
In-Reply-To: <1412204825-13292-1-git-send-email-agrover@redhat.com>
References: <1412204825-13292-1-git-send-email-agrover@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to prevent a O(n) search of the filesystem to link up its uio
node with its target configuration, TCMU needs to know the minor number
that UIO assigned. Expose the definition of this struct so TCMU can
access this field.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/uio/uio.c          | 12 ------------
 include/linux/uio_driver.h | 12 +++++++++++-
 2 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index a673e5b..60fa627 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -28,18 +28,6 @@
 
 #define UIO_MAX_DEVICES		(1U << MINORBITS)
 
-struct uio_device {
-	struct module		*owner;
-	struct device		*dev;
-	int			minor;
-	atomic_t		event;
-	struct fasync_struct	*async_queue;
-	wait_queue_head_t	wait;
-	struct uio_info		*info;
-	struct kobject		*map_dir;
-	struct kobject		*portio_dir;
-};
-
 static int uio_major;
 static struct cdev *uio_cdev;
 static DEFINE_IDR(uio_idr);
diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
index 1ad4724..baa8171 100644
--- a/include/linux/uio_driver.h
+++ b/include/linux/uio_driver.h
@@ -63,7 +63,17 @@ struct uio_port {
 
 #define MAX_UIO_PORT_REGIONS	5
 
-struct uio_device;
+struct uio_device {
+        struct module           *owner;
+        struct device           *dev;
+        int                     minor;
+        atomic_t                event;
+        struct fasync_struct    *async_queue;
+        wait_queue_head_t       wait;
+        struct uio_info         *info;
+        struct kobject          *map_dir;
+        struct kobject          *portio_dir;
+};
 
 /**
  * struct uio_info - UIO device capabilities
-- 
1.9.3

