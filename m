Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967926Ab3DSDll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 23:41:41 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:59970 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967859Ab3DSDlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 23:41:39 -0400
Message-ID: <1366342893.20735.0.camel@phoenix>
Subject: [PATCH RFT] regulator: palmas: Don't update tstep register for
 SMPS3 and SMPS7
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Fri, 19 Apr 2013 11:41:33 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SMPS3 and SMPS7 do not have tstep_addr setting, so current code actually 
writes 0 to PALMAS_SMPS12_CTRL(0x0) register when set_ramp_delay callback
is called for SMPS3 and SMPS7.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/palmas-regulator.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index f26344e..cfa143a 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -438,6 +438,10 @@ static int palmas_smps_set_ramp_delay(struct regulator_dev *rdev,
 	unsigned int addr = palmas_regs_info[id].tstep_addr;
 	int ret;
 
+	/* SMPS3 and SMPS7 do not have tstep_addr setting */
+	if (!addr)
+		return 0;
+
 	if (ramp_delay <= 0)
 		reg = 0;
 	else if (ramp_delay < 2500)
-- 
1.7.10.4



