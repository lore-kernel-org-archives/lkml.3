Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073AbaKERAk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:00:40 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:57190 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729AbaKERAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:00:34 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, computersforpeace@gmail.com,
        pekon@pek-sem.com, linux-mtd@lists.infradead.org
Subject: [PATCH v4 06/11] mtd: nand: WARN() if EEC Bytes per page is larger than the OOB
Date: Wed,  5 Nov 2014 16:59:48 +0000
Message-Id: <1415206793-25670-7-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415206793-25670-1-git-send-email-lee.jones@linaro.org>
References: <1415206793-25670-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EEC information is held in the Out-Of-Bounds (OOB) area, so can not be
larger than the area it's stored in.  If the math is out, we issue a
warning to the user.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/nand_base.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 4f3e80c..d0ebb05 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -4063,6 +4063,8 @@ int nand_scan_tail(struct mtd_info *mtd)
 	}
 	ecc->total = ecc->steps * ecc->bytes;
 
+	WARN_ON(ecc->total > mtd->oobsize);
+
 	/* Allow subpage writes up to ecc.steps. Not possible for MLC flash */
 	if (!(chip->options & NAND_NO_SUBPAGE_WRITE) && nand_is_slc(chip)) {
 		switch (ecc->steps) {
-- 
1.9.1

