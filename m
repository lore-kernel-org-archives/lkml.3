Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441Ab3F2EE0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 00:04:26 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:56625 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab3F2EEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 00:04:25 -0400
Message-ID: <1372478659.9121.2.camel@phoenix>
Subject: [PATCH] regulator: max77693: Skip register regulator if no platform
 initialization data
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Sat, 29 Jun 2013 12:04:19 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code in max77693_pmic_dt_parse_rdata() does skip setting rdata if
!rmatch[i].init_data. So we may have some empty entries in rdata[].
We need to skip register regulator if no platform initialization data,
otherwise we may resiter regulator with invalid settings ( the empty entries
of rdata[]).

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/max77693.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/regulator/max77693.c b/drivers/regulator/max77693.c
index d45a4dd..6116a49 100644
--- a/drivers/regulator/max77693.c
+++ b/drivers/regulator/max77693.c
@@ -265,6 +265,9 @@ static int max77693_pmic_probe(struct platform_device *pdev)
 	for (i = 0; i < max77693_pmic->num_regulators; i++) {
 		int id = rdata[i].id;
 
+		if (!rdata[i].initdata)
+			continue;
+
 		config.init_data = rdata[i].initdata;
 		config.of_node = rdata[i].of_node;
 
-- 
1.8.1.2



