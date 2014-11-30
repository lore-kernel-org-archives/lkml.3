Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383AbaK3Lgo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 06:36:44 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:14388 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbaK3Lft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 06:35:49 -0500
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 4/6] UBI: Fastmap: Wrap fastmap specific function in a ifdef
Date: Sun, 30 Nov 2014 12:35:38 +0100
Message-Id: <1417347340-6872-5-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1417347340-6872-1-git-send-email-richard@nod.at>
References: <1417347340-6872-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...such that we can implement NOP variants of some functions.
This will help to reduce fastmap specific ifdefs in other c files.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/ubi.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index d672412..6fadf34 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -864,10 +864,14 @@ int ubi_compare_lebs(struct ubi_device *ubi, const struct ubi_ainf_peb *aeb,
 		      int pnum, const struct ubi_vid_hdr *vid_hdr);
 
 /* fastmap.c */
+#ifdef CONFIG_MTD_UBI_FASTMAP
 size_t ubi_calc_fm_size(struct ubi_device *ubi);
 int ubi_update_fastmap(struct ubi_device *ubi);
 int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai,
 		     int fm_anchor);
+#else
+static inline int ubi_update_fastmap(struct ubi_device *ubi) { return 0; }
+#endif
 
 /* block.c */
 #ifdef CONFIG_MTD_UBI_BLOCK
-- 
1.8.4.5

