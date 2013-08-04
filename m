Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab3HDBXg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 21:23:36 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:34251 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab3HDBXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 21:23:35 -0400
Message-ID: <1375579408.3588.1.camel@phoenix>
Subject: [PATCH] regulator: 88pm800: Fix checking whether num_regulator is
 valid
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: "Joseph(Yossi) Hanin" <yhanin@marvell.com>, Yi Zhang <yizhang@marvell.com>,
        Chao Xie <chao.xie@marvell.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Sun, 04 Aug 2013 09:23:28 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code to check whether num_regulator is valid is wrong because it should
iterate all array entries rather than break from the for loop if
pdata->regulators[i] is NULL.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/88pm800.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/88pm800.c b/drivers/regulator/88pm800.c
index c72fe95..58e9b74 100644
--- a/drivers/regulator/88pm800.c
+++ b/drivers/regulator/88pm800.c
@@ -299,10 +299,13 @@ static int pm800_regulator_probe(struct platform_device *pdev)
 			return -ENODEV;
 		}
 	} else if (pdata->num_regulators) {
-		/* Check whether num_regulator is valid. */
 		unsigned int count = 0;
-		for (i = 0; pdata->regulators[i]; i++)
-			count++;
+
+		/* Check whether num_regulator is valid. */
+		for (i = 0; ARRAY_SIZE(pdata->regulators); i++) {
+			if (pdata->regulators[i])
+				count++;
+		}
 		if (count != pdata->num_regulators)
 			return -EINVAL;
 	} else {
-- 
1.8.1.2



