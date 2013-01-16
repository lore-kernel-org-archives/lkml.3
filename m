Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab3APOyh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 09:54:37 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:47473 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab3APOyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 09:54:35 -0500
From: yix.x.zhang@gmail.com
To: cjb@laptop.org
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Zhang, Yi" <yix.x.zhang@gmail.com>
Subject: [PATCH v2] mmc: correct one comment error of structure mmc_ext_csd
Date: Wed, 16 Jan 2013 22:53:34 +0800
Message-Id: <50f6bf2a.e2ee440a.7c4d.ffff97b8@mx.google.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <50EBD75F.7050805@codeaurora.org>
References: <50EBD75F.7050805@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Zhang, Yi" <yix.x.zhang@gmail.com>

The right value for field raw_exception_status is 54(not 53) according
to eMMC 4.5 specification. Also for more readable, replace all number
values with macro symboles.

Signed-off-by: Zhang, Yi <yix.x.zhang@gmail.com>
---
 include/linux/mmc/card.h |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index 5c69315..d270392 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -83,23 +83,23 @@ struct mmc_ext_csd {
 	unsigned int            data_tag_unit_size;     /* DATA TAG UNIT size */
 	unsigned int		boot_ro_lock;		/* ro lock support */
 	bool			boot_ro_lockable;
-	u8			raw_exception_status;	/* 53 */
-	u8			raw_partition_support;	/* 160 */
-	u8			raw_rpmb_size_mult;	/* 168 */
-	u8			raw_erased_mem_count;	/* 181 */
-	u8			raw_ext_csd_structure;	/* 194 */
-	u8			raw_card_type;		/* 196 */
-	u8			out_of_int_time;	/* 198 */
-	u8			raw_s_a_timeout;		/* 217 */
-	u8			raw_hc_erase_gap_size;	/* 221 */
-	u8			raw_erase_timeout_mult;	/* 223 */
-	u8			raw_hc_erase_grp_size;	/* 224 */
-	u8			raw_sec_trim_mult;	/* 229 */
-	u8			raw_sec_erase_mult;	/* 230 */
-	u8			raw_sec_feature_support;/* 231 */
-	u8			raw_trim_mult;		/* 232 */
-	u8			raw_bkops_status;	/* 246 */
-	u8			raw_sectors[4];		/* 212 - 4 bytes */
+	u8			raw_exception_status;	/* EXT_CSD_EXP_EVENTS_STATUS */
+	u8			raw_partition_support;	/* EXT_CSD_PARTITION_SUPPORT */
+	u8			raw_rpmb_size_mult;	/* EXT_CSD_RPMB_MULT */
+	u8			raw_erased_mem_count;	/* EXT_CSD_ERASED_MEM_CONT */
+	u8			raw_ext_csd_structure;	/* EXT_CSD_STRUCTURE */
+	u8			raw_card_type;		/* EXT_CSD_CARD_TYPE */
+	u8			out_of_int_time;	/* EXT_CSD_OUT_OF_INTERRUPT_TIME */
+	u8			raw_s_a_timeout;	/* EXT_CSD_S_A_TIMEOUT */
+	u8			raw_hc_erase_gap_size;	/* EXT_CSD_HC_WP_GRP_SIZE */
+	u8			raw_erase_timeout_mult;	/* EXT_CSD_ERASE_TIMEOUT_MULT */
+	u8			raw_hc_erase_grp_size;	/* EXT_CSD_HC_ERASE_GRP_SIZE */
+	u8			raw_sec_trim_mult;	/* EXT_CSD_SEC_TRIM_MULT */
+	u8			raw_sec_erase_mult;	/* EXT_CSD_SEC_ERASE_MULT */
+	u8			raw_sec_feature_support;/* EXT_CSD_SEC_FEATURE_SUPPORT */
+	u8			raw_trim_mult;		/* EXT_CSD_TRIM_MULT */
+	u8			raw_bkops_status;	/* EXT_CSD_BKOPS_STATUS */
+	u8			raw_sectors[4];		/* EXT_CSD_SEC_CNT - 4 bytes */
 
 	unsigned int            feature_support;
 #define MMC_DISCARD_FEATURE	BIT(0)                  /* CMD38 feature */
-- 
1.7.10.4

