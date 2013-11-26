Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab3KZCGL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 21:06:11 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:39546 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026Ab3KZCGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 21:06:08 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 07/16] staging/lustre/mdt: HSM coordinator client interface
Date: Tue, 26 Nov 2013 10:05:01 +0800
Message-Id: <1385431510-18988-8-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385431510-18988-1-git-send-email-bergwolf@gmail.com>
References: <1385431510-18988-1-git-send-email-bergwolf@gmail.com>
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
index 9fd1d3b..9436166 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
@@ -1121,11 +1121,10 @@ static inline int hal_size(struct hsm_action_list *hal)
 
 	sz = sizeof(*hal) + cfs_size_round(strlen(hal->hal_fsname));
 	hai = hai_zero(hal);
-	for (i = 0 ; i < hal->hal_count ; i++) {
+	for (i = 0; i < hal->hal_count; i++, hai = hai_next(hai))
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

