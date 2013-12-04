Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab3LDWTB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 17:19:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753613Ab3LDWTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 17:19:00 -0500
Date: Wed, 4 Dec 2013 17:18:56 -0500
From: Luiz Capitulino <lcapitulino@redhat.com>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] virtio_balloon: update_balloon_size(): update correct field
Message-ID: <20131204171856.3f3453e6@redhat.com>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the virtio spec, the device configuration field
that should be updated after an inflation or deflation
operation is the 'actual' field, not the 'num_pages' one.

Commit 855e0c5288177bcb193f6f6316952d2490478e1c swapped them
in update_balloon_size(). Fix it.

Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>
---
 drivers/virtio/virtio_balloon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index c444654..5c4a95b 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -285,7 +285,7 @@ static void update_balloon_size(struct virtio_balloon *vb)
 {
 	__le32 actual = cpu_to_le32(vb->num_pages);
 
-	virtio_cwrite(vb->vdev, struct virtio_balloon_config, num_pages,
+	virtio_cwrite(vb->vdev, struct virtio_balloon_config, actual,
 		      &actual);
 }
 
-- 
1.8.1.4

