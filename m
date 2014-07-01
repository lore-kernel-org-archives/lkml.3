Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275AbaGAQTd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:19:33 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:53115 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757990AbaGAQQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:16:55 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 12/20] block: Convert last uses of __FUNCTION__ to __func__
Date: Tue,  1 Jul 2014 18:16:42 +0200
Message-Id: <1404231410-29852-13-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404231410-29852-1-git-send-email-philipp.reisner@linbit.com>
References: <1404231410-29852-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

Just about all of these have been converted to __func__,
so convert the last uses.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index fe6595a..b0ab358 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1867,7 +1867,7 @@ static inline void inc_ap_pending(struct drbd_device *device)
 			func, line,					\
 			atomic_read(&device->which))
 
-#define dec_ap_pending(device) _dec_ap_pending(device, __FUNCTION__, __LINE__)
+#define dec_ap_pending(device) _dec_ap_pending(device, __func__, __LINE__)
 static inline void _dec_ap_pending(struct drbd_device *device, const char *func, int line)
 {
 	if (atomic_dec_and_test(&device->ap_pending_cnt))
@@ -1886,7 +1886,7 @@ static inline void inc_rs_pending(struct drbd_device *device)
 	atomic_inc(&device->rs_pending_cnt);
 }
 
-#define dec_rs_pending(device) _dec_rs_pending(device, __FUNCTION__, __LINE__)
+#define dec_rs_pending(device) _dec_rs_pending(device, __func__, __LINE__)
 static inline void _dec_rs_pending(struct drbd_device *device, const char *func, int line)
 {
 	atomic_dec(&device->rs_pending_cnt);
@@ -1907,14 +1907,14 @@ static inline void inc_unacked(struct drbd_device *device)
 	atomic_inc(&device->unacked_cnt);
 }
 
-#define dec_unacked(device) _dec_unacked(device, __FUNCTION__, __LINE__)
+#define dec_unacked(device) _dec_unacked(device, __func__, __LINE__)
 static inline void _dec_unacked(struct drbd_device *device, const char *func, int line)
 {
 	atomic_dec(&device->unacked_cnt);
 	ERR_IF_CNT_IS_NEGATIVE(unacked_cnt, func, line);
 }
 
-#define sub_unacked(device, n) _sub_unacked(device, n, __FUNCTION__, __LINE__)
+#define sub_unacked(device, n) _sub_unacked(device, n, __func__, __LINE__)
 static inline void _sub_unacked(struct drbd_device *device, int n, const char *func, int line)
 {
 	atomic_sub(n, &device->unacked_cnt);
-- 
1.9.1

