Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab3KNQrP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:47:15 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:36333 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992Ab3KNQoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:44:46 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "John L. Hammond" <john.hammond@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 20/26] staging/lustre/hsm: reprocess LDLM resource in mdt_hsm_release()
Date: Fri, 15 Nov 2013 00:43:07 +0800
Message-Id: <1384447393-13838-21-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
References: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

In mdt_hsm_release() manually reprocess the LDLM resource (the file
being released) after cancelling the lease (exclusive open lock on the
same file).

Lustre-change: http://review.whamcloud.com/7621
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3931
Signed-off-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
Reviewed-by: Bobi Jam <bobijam@gmail.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
[picked only client side of change -- Peng Tao]
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/ldlm/ldlm_lock.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c b/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
index c4fa9f9..ac84d01 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
@@ -2091,6 +2091,7 @@ void ldlm_cancel_locks_for_export(struct obd_export *exp)
 	cfs_hash_for_each_empty(exp->exp_lock_hash,
 				ldlm_cancel_locks_for_export_cb, &ecl);
 }
+EXPORT_SYMBOL(ldlm_reprocess_all);
 
 /**
  * Downgrade an exclusive lock.
-- 
1.7.9.5

