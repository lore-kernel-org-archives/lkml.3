Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297AbaEXDKt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 23:10:49 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:45876 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbaEXDKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 23:10:48 -0400
Message-ID: <1400901043.11911.2.camel@phoenix>
Subject: [PATCH] regulator: core: Use map_voltage_linear_range by default
 for list_voltage_linear_range
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Sat, 24 May 2014 11:10:43 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use map_voltage_linear_range() if list_voltage_linear_range() is in use and
nothing is set.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index b97ffd2..7399cbf 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2321,6 +2321,10 @@ static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 			    regulator_list_voltage_linear)
 				ret = regulator_map_voltage_linear(rdev,
 								min_uV, max_uV);
+			else if (rdev->desc->ops->list_voltage ==
+				 regulator_list_voltage_linear_range)
+				ret = regulator_map_voltage_linear_range(rdev,
+								min_uV, max_uV);
 			else
 				ret = regulator_map_voltage_iterate(rdev,
 								min_uV, max_uV);
-- 
1.8.3.2



