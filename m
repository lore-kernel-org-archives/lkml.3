Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab3LPLYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 06:24:19 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:40563 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab3LPLYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 06:24:18 -0500
Date: Mon, 16 Dec 2013 16:54:08 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org, josh@joshtriplett.org
Subject: [PATCH] drivers: virtio: Mark function virtballoon_migratepage() as
 static in virtio_balloon.c
Message-ID: <20131216112408.GA4896@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark the function virtballoon_migratepage() as static in
virtio_balloon.c because it is not used outside this file.

This eliminates the following warning in virtio_balloon.c:
drivers/virtio/virtio_balloon.c:372:5: warning: no previous prototype for ‘virtballoon_migratepage’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 drivers/virtio/virtio_balloon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index c444654..8c5943d 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -369,7 +369,7 @@ static const struct address_space_operations virtio_balloon_aops;
  * This function preforms the balloon page migration task.
  * Called through balloon_mapping->a_ops->migratepage
  */
-int virtballoon_migratepage(struct address_space *mapping,
+static int virtballoon_migratepage(struct address_space *mapping,
 		struct page *newpage, struct page *page, enum migrate_mode mode)
 {
 	struct balloon_dev_info *vb_dev_info = balloon_page_device(page);
-- 
1.7.9.5

