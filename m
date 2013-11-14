Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab3KNQlY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:41:24 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:51304 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756478Ab3KNQkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:40:15 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Andriy Skulysh <Andriy_Skulysh@xyratex.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 28/39] staging/lustre/ldlm: ldlm_flock_deadlock() ASSERTION( req != lock ) failed
Date: Fri, 15 Nov 2013 00:32:51 +0800
Message-Id: <1384446782-13741-29-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
References: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andriy Skulysh <Andriy_Skulysh@xyratex.com>

Abort processing of flock blockers list
on reaching disconnected export

Lustre-change: http://review.whamcloud.com/7392
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3783
Signed-off-by: Andriy Skulysh <Andriy_Skulysh@xyratex.com>
Reviewed-by: Keith Mannthey <keith.mannthey@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/ldlm/ldlm_flock.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c b/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c
index 6324eff..d4598b6 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c
@@ -195,6 +195,9 @@ ldlm_flock_deadlock(struct ldlm_lock *req, struct ldlm_lock *bl_lock)
 		cfs_hash_put(bl_exp->exp_flock_hash, &lock->l_exp_flock_hash);
 		bl_exp = bl_exp_new;
 
+		if (bl_exp->exp_failed)
+			break;
+
 		if (bl_owner == req_owner && bl_exp == req_exp) {
 			class_export_put(bl_exp);
 			return 1;
-- 
1.7.9.5

