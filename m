Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbaC2StX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 14:49:23 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62913 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbaC2StU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 14:49:20 -0400
Date: Sun, 30 Mar 2014 00:19:45 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Vinayak Holikatti <vinholikatti@gmail.com>,
        Santosh Y <santoshsy@gmail.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 53/55] scsi: Mark functions as static in ufs/ufshcd.c
Message-ID: <dacbe94180cd968f5a45611b1bd08969ee9d3625.1396114898.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark functions as static in ufs/ufshcd.c because they are not used
outside this file.

This eliminates the following warnings in ufs/ufshcd.c:
drivers/scsi/ufs/ufshcd.c:1173:5: warning: no previous prototype for ‘ufshcd_query_attr’ [-Wmissing-prototypes]
drivers/scsi/ufs/ufshcd.c:1484:5: warning: no previous prototype for ‘ufshcd_uic_change_pwr_mode’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/ufs/ufshcd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 04884d6..894bab6 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1170,7 +1170,7 @@ out_unlock:
  *
  * Returns 0 for success, non-zero in case of failure
 */
-int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
+static int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
 			enum attr_idn idn, u8 index, u8 selector, u32 *attr_val)
 {
 	struct ufs_query_req *request;
@@ -1481,7 +1481,7 @@ EXPORT_SYMBOL_GPL(ufshcd_dme_get_attr);
  *
  * Returns 0 on success, non-zero value on failure
  */
-int ufshcd_uic_change_pwr_mode(struct ufs_hba *hba, u8 mode)
+static int ufshcd_uic_change_pwr_mode(struct ufs_hba *hba, u8 mode)
 {
 	struct uic_command uic_cmd = {0};
 	struct completion pwr_done;
-- 
1.7.9.5

