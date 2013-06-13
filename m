Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759083Ab3FMScz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 14:32:55 -0400
Received: from etezian.org ([198.101.225.253]:56458 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758945Ab3FMS3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:29:00 -0400
From: Andi Shyti <andi@etezian.org>
To: arnd@arndb.de, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, pc@asdf.org, oatilla@gmail.com,
        andi@etezian.org
Subject: [PATCH 09/19] bh1770glc: use min_t instead of min
Date: Thu, 13 Jun 2013 20:20:43 +0200
Message-Id: <a4596befbbb6230336affa57b7d22dbd7ea0ab7a.1371145891.git.andi@etezian.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1371145891.git.andi@etezian.org>
References: <cover.1371145891.git.andi@etezian.org>
In-Reply-To: <cover.1371145891.git.andi@etezian.org>
References: <cover.1371145891.git.andi@etezian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andi Shyti <andi@etezian.org>
---
 drivers/misc/bh1770glc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/bh1770glc.c b/drivers/misc/bh1770glc.c
index 031a9fa..bd90eaf 100644
--- a/drivers/misc/bh1770glc.c
+++ b/drivers/misc/bh1770glc.c
@@ -273,7 +273,7 @@ static inline u16 bh1770_lux_raw_to_adjusted(struct bh1770_chip *chip, u16 raw)
 {
 	u32 lux;
 	lux = ((u32)raw * chip->lux_corr) / BH1770_LUX_CORR_SCALE;
-	return min(lux, (u32)BH1770_LUX_RANGE);
+	return min_t(u32, lux, BH1770_LUX_RANGE);
 }
 
 static inline u16 bh1770_lux_adjusted_to_raw(struct bh1770_chip *chip,
-- 
1.7.10.4

