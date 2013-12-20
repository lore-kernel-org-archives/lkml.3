Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab3LTC54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 21:57:56 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:40112 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab3LTC5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 21:57:54 -0500
Message-ID: <1387508269.10796.1.camel@phoenix>
Subject: [PATCH] regulator: as3722: Don't set min_uV/uV_step/linear_min_sel
 for linear_ranges
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Fri, 20 Dec 2013 10:57:49 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These settings are not used when using linear_ranges and it makes the code
looks confusing. Thus remove them.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/as3722-regulator.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/regulator/as3722-regulator.c b/drivers/regulator/as3722-regulator.c
index b9f1d24..27fe63c 100644
--- a/drivers/regulator/as3722-regulator.c
+++ b/drivers/regulator/as3722-regulator.c
@@ -842,9 +842,6 @@ static int as3722_regulator_probe(struct platform_device *pdev)
 				ops = &as3722_ldo_extcntrl_ops;
 			else
 				ops = &as3722_ldo_ops;
-			as3722_regs->desc[id].min_uV = 825000;
-			as3722_regs->desc[id].uV_step = 25000;
-			as3722_regs->desc[id].linear_min_sel = 1;
 			as3722_regs->desc[id].enable_time = 500;
 			as3722_regs->desc[id].linear_ranges = as3722_ldo_ranges;
 			as3722_regs->desc[id].n_linear_ranges =
-- 
1.8.1.2



