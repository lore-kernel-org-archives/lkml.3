Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbaCYTf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 15:35:28 -0400
Received: from smtprelay0040.hostedemail.com ([216.40.44.40]:55223 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754710AbaCYTfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 15:35:23 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1542:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:3138:3139:3140:3141:3142:3353:3865:3866:3867:4321:4605:5007:6119:6261:7903:10004:10026:10848:11026:11233:11473:11658:11914:12043:12296:12438:12517:12519:12555,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: iron00_119d6bfe50352
X-Filterd-Recvd-Size: 3597
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Lars Ellenberg <drbd-dev@lists.linbit.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>, drbd-user@lists.linbit.com,
        xen-devel@lists.xenproject.org
Subject: [PATCH 3/5] block: Convert last uses of __FUNCTION__ to __func__
Date: Tue, 25 Mar 2014 12:35:05 -0700
Message-Id: <fec7be25b0bae2280231f4e7779378b93de642f9.1395775901.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1395775901.git.joe@perches.com>
References: <cover.1395775901.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just about all of these have been converted to __func__,
so convert the last uses.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/drbd/drbd_int.h | 8 ++++----
 drivers/block/xen-blkfront.c  | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index e7093d4..e312f73 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1781,7 +1781,7 @@ static inline void inc_ap_pending(struct drbd_device *device)
 			func, line,					\
 			atomic_read(&device->which))
 
-#define dec_ap_pending(device) _dec_ap_pending(device, __FUNCTION__, __LINE__)
+#define dec_ap_pending(device) _dec_ap_pending(device, __func__, __LINE__)
 static inline void _dec_ap_pending(struct drbd_device *device, const char *func, int line)
 {
 	if (atomic_dec_and_test(&device->ap_pending_cnt))
@@ -1800,7 +1800,7 @@ static inline void inc_rs_pending(struct drbd_device *device)
 	atomic_inc(&device->rs_pending_cnt);
 }
 
-#define dec_rs_pending(device) _dec_rs_pending(device, __FUNCTION__, __LINE__)
+#define dec_rs_pending(device) _dec_rs_pending(device, __func__, __LINE__)
 static inline void _dec_rs_pending(struct drbd_device *device, const char *func, int line)
 {
 	atomic_dec(&device->rs_pending_cnt);
@@ -1821,14 +1821,14 @@ static inline void inc_unacked(struct drbd_device *device)
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
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index efe1b47..375aea5 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1366,8 +1366,8 @@ static int blkfront_probe(struct xenbus_device *dev,
 
 			if (major != XENVBD_MAJOR) {
 				printk(KERN_INFO
-						"%s: HVM does not support vbd %d as xen block device\n",
-						__FUNCTION__, vdevice);
+				       "%s: HVM does not support vbd %d as xen block device\n",
+				       __func__, vdevice);
 				return -ENODEV;
 			}
 		}
-- 
1.8.1.2.459.gbcd45b4.dirty

