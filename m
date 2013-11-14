Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab3KNQXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:23:46 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40313 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076Ab3KNQPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:15:44 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 20/40] staging/lustre/mdt: HSM coordinator client interface
Date: Fri, 15 Nov 2013 00:13:22 +0800
Message-Id: <1384445622-12346-21-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
References: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>

This patch implements the HSM coordinator methods
used by client to add/remove/list HSM actions on
FID.

Lustre-change: http://review.whamcloud.com/6532
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3341
Signed-off-by: JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/lustre/include/lustre/lustre_user.h     |    7 +++----
 drivers/staging/lustre/lustre/mdc/mdc_request.c    |    4 +---
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
index 9891ace..19fa813 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
@@ -1121,11 +1121,10 @@ static inline int hal_size(struct hsm_action_list *hal)
 
 	sz = sizeof(*hal) + cfs_size_round(strlen(hal->hal_fsname));
 	hai = hai_zero(hal);
-	for (i = 0 ; i < hal->hal_count ; i++) {
+	for (i = 0 ; i < hal->hal_count ; i++, hai = hai_next(hai))
 		sz += cfs_size_round(hai->hai_len);
-		hai = hai_next(hai);
-	}
-	return(sz);
+
+	return sz;
 }
 
 /* Copytool progress reporting */
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_request.c b/drivers/staging/lustre/lustre/mdc/mdc_request.c
index a09a5c3..8373778 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_request.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_request.c
@@ -1919,10 +1919,8 @@ static void lustre_swab_hal(struct hsm_action_list *h)
 	__swab32s(&h->hal_archive_id);
 	__swab64s(&h->hal_flags);
 	hai = hai_zero(h);
-	for (i = 0; i < h->hal_count; i++) {
+	for (i = 0; i < h->hal_count; i++, hai = hai_next(hai))
 		lustre_swab_hai(hai);
-		hai = hai_next(hai);
-	}
 }
 
 static void lustre_swab_kuch(struct kuc_hdr *l)
-- 
1.7.9.5

