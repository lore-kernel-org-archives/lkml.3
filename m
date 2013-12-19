Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab3LSJqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 04:46:33 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:51245 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab3LSJqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 04:46:31 -0500
Date: Thu, 19 Dec 2013 15:16:22 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com,
        josh@joshtriplett.org
Subject: [PATCH 10/13] drivers: block: Mark functions as static in drbd_main.c
Message-ID: <e392fa86848d078db6ca8e2de9f3a7d151b0b129.1387445396.git.rashika.kheria@gmail.com>
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

Mark functions _drbd_send_uuids(), fill_bitmap_rle_bits() and
init_submitter() as static in drbd/drbd_main.c because they are
not used outside this file.

This eliminates the following warnings in drbd/drbd_main.c:
drivers/block/drbd/drbd_main.c:826:5: warning: no previous prototype for ‘_drbd_send_uuids’ [-Wmissing-prototypes]
drivers/block/drbd/drbd_main.c:1070:5: warning: no previous prototype for ‘fill_bitmap_rle_bits’ [-Wmissing-prototypes]
drivers/block/drbd/drbd_main.c:2592:5: warning: no previous prototype for ‘init_submitter’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/block/drbd/drbd_main.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 4a24e71..3cc0997 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -821,7 +821,7 @@ int drbd_send_protocol(struct drbd_tconn *tconn)
 	return err;
 }
 
-int _drbd_send_uuids(struct drbd_conf *mdev, u64 uuid_flags)
+static int _drbd_send_uuids(struct drbd_conf *mdev, u64 uuid_flags)
 {
 	struct drbd_socket *sock;
 	struct p_uuids *p;
@@ -1065,7 +1065,7 @@ static void dcbp_set_pad_bits(struct p_compressed_bm *p, int n)
 	p->encoding = (p->encoding & (~0x7 << 4)) | (n << 4);
 }
 
-int fill_bitmap_rle_bits(struct drbd_conf *mdev,
+static int fill_bitmap_rle_bits(struct drbd_conf *mdev,
 			 struct p_compressed_bm *p,
 			 unsigned int size,
 			 struct bm_xfer_ctx *c)
@@ -2587,7 +2587,7 @@ void conn_destroy(struct kref *kref)
 	kfree(tconn);
 }
 
-int init_submitter(struct drbd_conf *mdev)
+static int init_submitter(struct drbd_conf *mdev)
 {
 	/* opencoded create_singlethread_workqueue(),
 	 * to be able to say "drbd%d", ..., minor */
-- 
1.7.9.5

