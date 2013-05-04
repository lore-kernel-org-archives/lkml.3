Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759862Ab3EDOCd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 10:02:33 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:40866 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758751Ab3EDOCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 10:02:32 -0400
Message-ID: <1367676147.5124.1.camel@phoenix>
Subject: [PATCH] regulator: ti-abb: Fix off-by-one valid range checking for
 abb->current_info_idx
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: "Andrii.Tseglytskyi" <andrii.tseglytskyi@ti.com>,
        Nishanth Menon <nm@ti.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Sat, 04 May 2013 22:02:27 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

abb->current_info_idx is used as array subscript to access volt_table,
thus the valid value range should be 0 ... desc->n_voltages - 1.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/ti-abb-regulator.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/ti-abb-regulator.c b/drivers/regulator/ti-abb-regulator.c
index c1870ea..870d209 100644
--- a/drivers/regulator/ti-abb-regulator.c
+++ b/drivers/regulator/ti-abb-regulator.c
@@ -387,8 +387,8 @@ static int ti_abb_get_voltage_sel(struct regulator_dev *rdev)
 		return -EINVAL;
 	}
 
-	if (abb->current_info_idx > (int)desc->n_voltages) {
-		dev_err(dev, "%s: Corrupted data? idx(%d) > n_voltages(%d)\n",
+	if (abb->current_info_idx >= (int)desc->n_voltages) {
+		dev_err(dev, "%s: Corrupted data? idx(%d) >= n_voltages(%d)\n",
 			__func__, abb->current_info_idx, desc->n_voltages);
 		return -EINVAL;
 	}
-- 
1.8.1.2



