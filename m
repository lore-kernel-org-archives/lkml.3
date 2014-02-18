Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966AbaBRKqv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 05:46:51 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:52601 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908AbaBRKqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 05:46:46 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 02/15] regulator: ti-abb: Do not hardcode return value
Date: Tue, 18 Feb 2014 16:10:58 +0530
Message-Id: <1392720071-13503-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392720071-13503-1-git-send-email-sachin.kamat@linaro.org>
References: <1392720071-13503-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Propagate the error value returned by the function instead.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/ti-abb-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/ti-abb-regulator.c b/drivers/regulator/ti-abb-regulator.c
index 804c83a31d69..75fa64769b4b 100644
--- a/drivers/regulator/ti-abb-regulator.c
+++ b/drivers/regulator/ti-abb-regulator.c
@@ -522,7 +522,7 @@ static int ti_abb_init_table(struct device *dev, struct ti_abb *abb,
 	num_entries = of_property_count_u32_elems(dev->of_node, pname);
 	if (num_entries < 0) {
 		dev_err(dev, "No '%s' property?\n", pname);
-		return -ENODEV;
+		return num_entries;
 	}
 
 	if (!num_entries || (num_entries % num_values)) {
-- 
1.7.9.5

