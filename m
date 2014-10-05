Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872AbaJEQDf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 12:03:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbaJEQDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 12:03:31 -0400
Date: Sun, 5 Oct 2014 19:06:59 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 03/16] virtio: refactor to use drv_to_virtio
Message-ID: <1412525038-15871-4-git-send-email-mst@redhat.com>
References: <1412525038-15871-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412525038-15871-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use drv_to_virtio instead of open-coding it.
Fix whitespace damage introduced by
        virtio: unify config_changed handling

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index 470b74f..3980687 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -241,8 +241,7 @@ EXPORT_SYMBOL_GPL(unregister_virtio_device);
 
 void virtio_config_changed(struct virtio_device *dev)
 {
-        struct virtio_driver *drv = container_of(dev->dev.driver,
-						 struct virtio_driver, driver);
+	struct virtio_driver *drv = drv_to_virtio(dev->dev.driver);
 
 	if (drv && drv->config_changed)
 		drv->config_changed(dev);
-- 
MST

