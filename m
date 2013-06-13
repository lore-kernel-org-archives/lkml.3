Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247Ab3FMSaE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 14:30:04 -0400
Received: from etezian.org ([198.101.225.253]:56461 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758971Ab3FMS3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:29:00 -0400
From: Andi Shyti <andi@etezian.org>
To: arnd@arndb.de, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, pc@asdf.org, oatilla@gmail.com,
        andi@etezian.org
Subject: [PATCH 11/19] bh1770glc: removed lux_read_raw_result() function
Date: Thu, 13 Jun 2013 20:20:45 +0200
Message-Id: <4965a4461b09febeafd20bb534b456861dfdc735.1371145891.git.andi@etezian.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1371145891.git.andi@etezian.org>
References: <cover.1371145891.git.andi@etezian.org>
In-Reply-To: <cover.1371145891.git.andi@etezian.org>
References: <cover.1371145891.git.andi@etezian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lux_raw_result_show() will run directly the lux_get_result()
instead of using another support function

Signed-off-by: Andi Shyti <andi@etezian.org>
---
 drivers/misc/bh1770glc.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/misc/bh1770glc.c b/drivers/misc/bh1770glc.c
index b5fc2b9..eec799e 100644
--- a/drivers/misc/bh1770glc.c
+++ b/drivers/misc/bh1770glc.c
@@ -385,12 +385,6 @@ static int bh1770_lux_read_result(struct bh1770_chip *chip)
 	return bh1770_lux_raw_to_adjusted(chip, chip->lux_data_raw);
 }
 
-static int bh1770_lux_read_raw_result(struct bh1770_chip *chip)
-{
-	bh1770_lux_get_result(chip);
-	return chip->lux_data_raw;
-}
-
 /*
  * Chip on / off functions are called while keeping mutex except probe
  * or remove phase
@@ -725,7 +719,8 @@ static ssize_t bh1770_lux_raw_result_show(struct device *dev,
 		return -EIO;
 
 	mutex_lock(&chip->mutex);
-	ret = sprintf(buf, "%d\n", bh1770_lux_read_raw_result(chip));
+	bh1770_lux_get_result(chip);
+	ret = sprintf(buf, "%d\n", chip->lux_data_raw);
 	mutex_unlock(&chip->mutex);
 
 	return ret;
-- 
1.7.10.4

