Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab3KTX0H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 18:26:07 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:16694 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754265Ab3KTX0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 18:26:03 -0500
From: Courtney Cavin <courtney.cavin@sonymobile.com>
To: <broonie@kernel.org>
CC: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] regmap: make sure we unlock on failure in regmap_bulk_write
Date: Wed, 20 Nov 2013 15:27:09 -0800
Message-ID: <1384990029-28182-1-git-send-email-courtney.cavin@sonymobile.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Courtney Cavin <courtney.cavin@sonymobile.com>
---
 drivers/base/regmap/regmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 9c021d9..d1a9141 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1549,7 +1549,7 @@ int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
 						val + (i * val_bytes),
 						val_bytes);
 			if (ret != 0)
-				return ret;
+				goto out;
 		}
 	} else {
 		ret = _regmap_raw_write(map, reg, wval, val_bytes * val_count);
-- 
1.8.1.5

