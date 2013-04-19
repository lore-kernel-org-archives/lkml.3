Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab3DSGSz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 02:18:55 -0400
Received: from mail-da0-f44.google.com ([209.85.210.44]:59967 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756880Ab3DSGSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 02:18:54 -0400
Message-ID: <1366352328.7079.0.camel@phoenix>
Subject: [PATCH RFT v2] regulator: palmas: Don't update tstep register for
 SMPS3 and SMPS7
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Fri, 19 Apr 2013 14:18:48 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SMPS3 and SMPS7 do not have tstep_addr setting, so current code actually
writes 0 to smps12_ctl (offset is 0) register when set_ramp_delay callback
is called for SMPS3 and SMPS7.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/palmas-regulator.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index f26344e..b253bd4 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -438,6 +438,13 @@ static int palmas_smps_set_ramp_delay(struct regulator_dev *rdev,
 	unsigned int addr = palmas_regs_info[id].tstep_addr;
 	int ret;
 
+	/* SMPS3 and SMPS7 do not have tstep_addr setting */
+	switch (id) {
+	case PALMAS_REG_SMPS3:
+	case PALMAS_REG_SMPS7:
+		return 0;
+	}
+
 	if (ramp_delay <= 0)
 		reg = 0;
 	else if (ramp_delay < 2500)
-- 
1.7.10.4



