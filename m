Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab3LSJdw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 04:33:52 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:61886 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab3LSJdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 04:33:49 -0500
Date: Thu, 19 Dec 2013 15:03:36 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com,
        josh@joshtriplett.org
Subject: [PATCH 02/13] drivers: block: Remove unused function
 drbd_bm_write_lazy() in drbd_bitmap.c
Message-ID: <107e3f5de68d07bca6eaf3e439eb62bcc8f0a5b6.1387445396.git.rashika.kheria@gmail.com>
References: <f460591345e87defe53122cf056991c7f2eefa10.1387445396.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f460591345e87defe53122cf056991c7f2eefa10.1387445396.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused function drbd_bm_write_lazy() in drbd/drbd_bitmap.c.

This eliminates the following warning in drbd/drbd_bitmap.c:
drivers/block/drbd/drbd_bitmap.c:1208:5: warning: no previous prototype for ‘drbd_bm_write_lazy’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/block/drbd/drbd_bitmap.c |   10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index b12c11e..d8e2bf4 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -1201,16 +1201,6 @@ int drbd_bm_write_all(struct drbd_conf *mdev) __must_hold(local)
 }
 
 /**
- * drbd_bm_lazy_write_out() - Write bitmap pages 0 to @upper_idx-1, if they have changed.
- * @mdev:	DRBD device.
- * @upper_idx:	0: write all changed pages; +ve: page index to stop scanning for changed pages
- */
-int drbd_bm_write_lazy(struct drbd_conf *mdev, unsigned upper_idx) __must_hold(local)
-{
-	return bm_rw(mdev, WRITE, BM_AIO_COPY_PAGES, upper_idx);
-}
-
-/**
  * drbd_bm_write_copy_pages() - Write the whole bitmap to its on disk location.
  * @mdev:	DRBD device.
  *
-- 
1.7.9.5

