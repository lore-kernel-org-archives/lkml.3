Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761418Ab3DCCea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 22:34:30 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:52883 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757022Ab3DCCe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 22:34:29 -0400
Message-ID: <1364956458.1328.5.camel@phoenix>
Subject: [PATCH 4/4] regulator: ab8500: Set match pointer and match_size for
 ab8505 and ab8540
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 03 Apr 2013 10:34:18 +0800
In-Reply-To: <1364956243.1328.1.camel@phoenix>
References: <1364956243.1328.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/ab8500.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 73d84d8..d3170ae 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -3021,11 +3021,15 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
 		regulator_info_size = ARRAY_SIZE(ab8505_regulator_info);
 		reg_init = ab8505_reg_init;
 		reg_init_size = AB8505_NUM_REGULATOR_REGISTERS;
+		match = ab8505_regulator_match;
+		match_size = ARRAY_SIZE(ab8505_regulator_match);
 	} else if (is_ab8540(ab8500)) {
 		regulator_info = ab8540_regulator_info;
 		regulator_info_size = ARRAY_SIZE(ab8540_regulator_info);
 		reg_init = ab8540_reg_init;
 		reg_init_size = AB8540_NUM_REGULATOR_REGISTERS;
+		match = ab8540_regulator_match;
+		match_size = ARRAY_SIZE(ab8540_regulator_match);
 	} else {
 		regulator_info = ab8500_regulator_info;
 		regulator_info_size = ARRAY_SIZE(ab8500_regulator_info);
-- 
1.7.10.4



