Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab3KNQkY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:40:24 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:54409 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755999Ab3KNQjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:39:12 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 11/39] staging/lustre/mdt: CDT cleanup follow-on patch
Date: Fri, 15 Nov 2013 00:32:34 +0800
Message-Id: <1384446782-13741-12-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
References: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>

This patch implements the comments made during the review after
maloo passed test or after the landing.

rename in hai_zero() hai_first()
 Use a better name for hai helper

replace use of cfs_helpers by native one in CDT
 replace atomic_t and helpers
 replace cfs_list and helpers
 change list_for_each + list_entry by list_entry_for_each
 replace cfs_task_t

clean err msg in HSM agent interface
 remove duplicate rc print

parenthesis code cleaning
 remove useless () in conditionnal tests

Lustre-change: http://review.whamcloud.com/7254
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3709
Signed-off-by: JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>
Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/lustre/include/lustre/lustre_user.h     |    4 ++--
 drivers/staging/lustre/lustre/mdc/mdc_request.c    |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
index c63a1ae..2c72a88 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
@@ -1106,7 +1106,7 @@ static inline int cfs_size_round (int val)
 #endif
 
 /* Return pointer to first hai in action list */
-static inline struct hsm_action_item * hai_zero(struct hsm_action_list *hal)
+static inline struct hsm_action_item *hai_first(struct hsm_action_list *hal)
 {
 	return (struct hsm_action_item *)(hal->hal_fsname +
 					  cfs_size_round(strlen(hal-> \
@@ -1126,7 +1126,7 @@ static inline int hal_size(struct hsm_action_list *hal)
 	struct hsm_action_item *hai;
 
 	sz = sizeof(*hal) + cfs_size_round(strlen(hal->hal_fsname));
-	hai = hai_zero(hal);
+	hai = hai_first(hal);
 	for (i = 0 ; i < hal->hal_count ; i++, hai = hai_next(hai))
 		sz += cfs_size_round(hai->hai_len);
 
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_request.c b/drivers/staging/lustre/lustre/mdc/mdc_request.c
index e418b58..eb3b44f 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_request.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_request.c
@@ -1957,7 +1957,7 @@ static void lustre_swab_hal(struct hsm_action_list *h)
 	__swab32s(&h->hal_count);
 	__swab32s(&h->hal_archive_id);
 	__swab64s(&h->hal_flags);
-	hai = hai_zero(h);
+	hai = hai_first(h);
 	for (i = 0; i < h->hal_count; i++, hai = hai_next(hai))
 		lustre_swab_hai(hai);
 }
-- 
1.7.9.5

