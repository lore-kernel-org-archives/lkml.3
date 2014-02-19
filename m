Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911AbaBSId3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 03:33:29 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:47798 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbaBSId2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 03:33:28 -0500
Message-ID: <1392798801.31957.3.camel@phoenix>
Subject: [PATCH 1/3 v2] regulator: tps65218: Add terminate entry for
 of_device_id table
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Keerthy <j-keerthy@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 19 Feb 2014 16:33:21 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes below build error:
FATAL: drivers/regulator/tps65218-regulator: struct of_device_id is not terminated with a NULL entry!

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
I'm sorry that I just found I CC wrong developers in my previous mail.
So here is a resend.
 drivers/regulator/tps65218-regulator.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/tps65218-regulator.c b/drivers/regulator/tps65218-regulator.c
index 958276c..d1c7831 100644
--- a/drivers/regulator/tps65218-regulator.c
+++ b/drivers/regulator/tps65218-regulator.c
@@ -96,6 +96,7 @@ static const struct of_device_id tps65218_of_match[] = {
 	TPS65218_OF_MATCH("ti,tps65218-dcdc5", tps65218_pmic_regs[DCDC5]),
 	TPS65218_OF_MATCH("ti,tps65218-dcdc6", tps65218_pmic_regs[DCDC6]),
 	TPS65218_OF_MATCH("ti,tps65218-ldo1", tps65218_pmic_regs[LDO1]),
+	{ }
 };
 MODULE_DEVICE_TABLE(of, tps65218_of_match);
 
-- 
1.8.1.2



