Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072Ab3KNQ4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:56:13 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:35510 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919Ab3KNQj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:39:26 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Swapnil Pimpale <spimpale@ddn.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 15/39] staging/lustre/lov: Get the correct address of lmm_objects
Date: Fri, 15 Nov 2013 00:32:38 +0800
Message-Id: <1384446782-13741-16-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
References: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Swapnil Pimpale <spimpale@ddn.com>

The introduction of lmm_layout_gen makes the assumption that
lmm_objects is present after lmm_stripe_count incorrect.
Fixed this to get the correct address of lmm_objects when lmmk is cast
to lov_mds_md_v1.

Lustre-change: http://review.whamcloud.com/7258
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3162
Signed-off-by: Swapnil Pimpale <spimpale@ddn.com>
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/lov/lov_pack.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/lov/lov_pack.c b/drivers/staging/lustre/lustre/lov/lov_pack.c
index 27ed27e..102a34d 100644
--- a/drivers/staging/lustre/lustre/lov/lov_pack.c
+++ b/drivers/staging/lustre/lustre/lov/lov_pack.c
@@ -641,8 +641,7 @@ int lov_getstripe(struct obd_export *exp, struct lov_stripe_md *lsm,
 	if (lum.lmm_magic == LOV_USER_MAGIC) {
 		/* User request for v1, we need skip lmm_pool_name */
 		if (lmmk->lmm_magic == LOV_MAGIC_V3) {
-			memmove((char *)(&lmmk->lmm_stripe_count) +
-				sizeof(lmmk->lmm_stripe_count),
+			memmove(((struct lov_mds_md_v1 *)lmmk)->lmm_objects,
 				((struct lov_mds_md_v3 *)lmmk)->lmm_objects,
 				lmmk->lmm_stripe_count *
 				sizeof(struct lov_ost_data_v1));
-- 
1.7.9.5

