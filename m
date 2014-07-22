Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692AbaGVExT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 00:53:19 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:42697 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaGVExP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 00:53:15 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: dougthompson@xmission.com
Cc: bp@alien8.de, m.chehab@samsung.com, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] edac: Remove fixmes in e7xxx_edac.c
Date: Tue, 22 Jul 2014 00:53:09 -0400
Message-Id: <1406004789-9918-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes two Page shift fixs me in this file and not checking
if row is -1 in process_ce as it cannot be this value or be must
exit this function by returning.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 drivers/edac/e7xxx_edac.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/edac/e7xxx_edac.c b/drivers/edac/e7xxx_edac.c
index 3cda79b..563983f 100644
--- a/drivers/edac/e7xxx_edac.c
+++ b/drivers/edac/e7xxx_edac.c
@@ -211,12 +211,13 @@ static void process_ce(struct mem_ctl_info *mci, struct e7xxx_error_info *info)
 	edac_dbg(3, "\n");
 	/* read the error address */
 	error_1b = info->dram_celog_add;
-	/* FIXME - should use PAGE_SHIFT */
-	page = error_1b >> 6;	/* convert the address to 4k page */
+	page = error_1b >> PAGE_SHIFT;	/* convert the address to 4k page */
 	/* read the syndrome */
 	syndrome = info->dram_celog_syndrome;
-	/* FIXME - check for -1 */
 	row = edac_mc_find_csrow_by_page(mci, page);
+	if (row == -1)
+		return;
 	/* convert syndrome to channel */
 	channel = e7xxx_find_channel(syndrome);
 	edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 1, page, 0, syndrome,
@@ -238,8 +239,7 @@ static void process_ue(struct mem_ctl_info *mci, struct e7xxx_error_info *info)
 	edac_dbg(3, "\n");
 	/* read the error address */
 	error_2b = info->dram_uelog_add;
-	/* FIXME - should use PAGE_SHIFT */
-	block_page = error_2b >> 6;	/* convert to 4k address */
+	block_page = error_2b >> PAGE_SHIFT;	/* convert to 4k address */
 	row = edac_mc_find_csrow_by_page(mci, block_page);
 
 	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1, block_page, 0, 0,
-- 
1.9.1

