Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbaBRKuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 05:50:54 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:46554 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932AbaBRKqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 05:46:49 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 03/15] regulator: ti-abb: Remove redundant error message
Date: Tue, 18 Feb 2014 16:10:59 +0530
Message-Id: <1392720071-13503-3-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392720071-13503-1-git-send-email-sachin.kamat@linaro.org>
References: <1392720071-13503-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kzalloc prints its own OOM message upon failure.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/ti-abb-regulator.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/regulator/ti-abb-regulator.c b/drivers/regulator/ti-abb-regulator.c
index 75fa64769b4b..a2dabb575b97 100644
--- a/drivers/regulator/ti-abb-regulator.c
+++ b/drivers/regulator/ti-abb-regulator.c
@@ -533,20 +533,15 @@ static int ti_abb_init_table(struct device *dev, struct ti_abb *abb,
 	num_entries /= num_values;
 
 	info = devm_kzalloc(dev, sizeof(*info) * num_entries, GFP_KERNEL);
-	if (!info) {
-		dev_err(dev, "Can't allocate info table for '%s' property\n",
-			pname);
+	if (!info)
 		return -ENOMEM;
-	}
+
 	abb->info = info;
 
 	volt_table = devm_kzalloc(dev, sizeof(unsigned int) * num_entries,
 				  GFP_KERNEL);
-	if (!volt_table) {
-		dev_err(dev, "Can't allocate voltage table for '%s' property\n",
-			pname);
+	if (!volt_table)
 		return -ENOMEM;
-	}
 
 	abb->rdesc.n_voltages = num_entries;
 	abb->rdesc.volt_table = volt_table;
-- 
1.7.9.5

