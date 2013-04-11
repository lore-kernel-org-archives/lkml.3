Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab3DKEFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 00:05:49 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:62413 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab3DKEFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 00:05:48 -0400
Message-ID: <1365653143.17060.2.camel@phoenix>
Subject: [PATCH 2/2] regulator: ab8500: Unregister ab8500-ext regulators in
 probe() failure path
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Thu, 11 Apr 2013 12:05:43 +0800
In-Reply-To: <1365653058.17060.0.camel@phoenix>
References: <1365653058.17060.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/ab8500.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index c200f8b..ea182d3 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -3172,8 +3172,11 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
 	for (i = 0; i < abx500_regulator.info_size; i++) {
 		err = ab8500_regulator_register(pdev, &pdata->regulator[i],
 						i, NULL);
-		if (err < 0)
+		if (err < 0) {
+			if (!is_ab8505(ab8500))
+				ab8500_ext_regulator_exit(pdev);
 			return err;
+		}
 	}
 
 	return 0;
-- 
1.7.10.4



