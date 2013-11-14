Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab3KNQr0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:47:26 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:58488 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627Ab3KNQoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:44:39 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Fan Yong <fan.yong@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 18/26] staging/lustre/scrub: support dryrun mode OI scrub
Date: Fri, 15 Nov 2013 00:43:05 +0800
Message-Id: <1384447393-13838-19-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
References: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fan Yong <fan.yong@intel.com>

The administrator can detect whether there are any inconsistent
OI mappings but without repairing them via the command:
lctl lfsck_start --dryrun on -M <$device>

Under default mode, dryrun is "off". When the device is mounted,
the initial OI scrub will detect whether there are upgrade case,
or file-level backup/resotre case, or OI file(s) recreated case.
If found some inconsistency, it will trigger non-dryrun mode OI
scrub automatically. If the administrator does NOT want to such
auto non-dryrun OI scrub to avoid some unexpected repairing, he
(or she) can specify "-o noscrub" when mount the device.

Lustre-change: http://review.whamcloud.com/7720
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3935
Signed-off-by: Fan Yong <fan.yong@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: wangdi <di.wang@intel.com>
[picked up only client side of change -- Peng Tao]
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/include/dt_object.h |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/staging/lustre/lustre/include/dt_object.h b/drivers/staging/lustre/lustre/include/dt_object.h
index 9304c26..c40701f 100644
--- a/drivers/staging/lustre/lustre/include/dt_object.h
+++ b/drivers/staging/lustre/lustre/include/dt_object.h
@@ -622,6 +622,7 @@ struct dt_index_operations {
 
 enum dt_otable_it_valid {
 	DOIV_ERROR_HANDLE	= 0x0001,
+	DOIV_DRYRUN		= 0x0002,
 };
 
 enum dt_otable_it_flags {
@@ -633,6 +634,9 @@ enum dt_otable_it_flags {
 
 	/* There is up layer component uses the iteration. */
 	DOIF_OUTUSED	= 0x0004,
+
+	/* Check only without repairing. */
+	DOIF_DRYRUN	= 0x0008,
 };
 
 /* otable based iteration needs to use the common DT interation APIs.
-- 
1.7.9.5

