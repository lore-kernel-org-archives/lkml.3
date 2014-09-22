Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbaIVIAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 04:00:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbaIVIAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 04:00:34 -0400
Date: Mon, 22 Sep 2014 11:03:31 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sudeep Dutt <sudeep.dutt@intel.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Siva Yerramreddy <yshivakrishna@gmail.com>,
        Heinz Graalfs <graalfs@linux.vnet.ibm.com>, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH] virtio: refactor to use drv_to_virtio
Message-ID: <1411372905-12649-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use drv_to_virtio instead of open-coding it.
Fix whitespace damage introduced by
	virtio: unify config_changed handling

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

Note: I'll probably smash this into the previous patch.

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
