Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387Ab3KNQqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:46:09 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:64695 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757289Ab3KNQpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:45:01 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        Andrew Perepechko <andrew_perepechko@xyratex.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 24/26] staging/lustre/lprocfs: implement log2 using bitops
Date: Fri, 15 Nov 2013 00:43:11 +0800
Message-Id: <1384447393-13838-25-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
References: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Perepechko <andrew_perepechko@xyratex.com>

This patch implements log2 using fls.

Reviewed-by: alexander_zarochentsev@xyratex.com
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3496
Signed-off-by: Andrew Perepechko <andrew_perepechko@xyratex.com>
Reviewed-by: Alexander Boyko <Alexander_Boyko@xyratex.com>
Reviewed-by: Vitaly Fertman <Vitaly_Fertman@xyratex.com>
Lustre-change: http://review.whamcloud.com/6757
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Bob Glossman <bob.glossman@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/lustre/obdclass/lprocfs_status.c        |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
index 428a023..b2647c8 100644
--- a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
+++ b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
@@ -1961,10 +1961,10 @@ EXPORT_SYMBOL(lprocfs_oh_tally);
 
 void lprocfs_oh_tally_log2(struct obd_histogram *oh, unsigned int value)
 {
-	unsigned int val;
+	unsigned int val = 0;
 
-	for (val = 0; ((1 << val) < value) && (val <= OBD_HIST_MAX); val++)
-		;
+	if (likely(value != 0))
+		val = min(fls(value - 1), OBD_HIST_MAX);
 
 	lprocfs_oh_tally(oh, val);
 }
-- 
1.7.9.5

