Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbaA1RX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 12:23:57 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.141]:10735 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755298AbaA1RX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 12:23:56 -0500
X-Env-Sender: anthony.olech.opensource@diasemi.com
X-Msg-Ref: server-6.tower-179.messagelabs.com!1390929832!36491848!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <201401281723.s0SHNmLa041140@swsrvapps-02.lan>
From: "Anthony Olech <anthony.olech.opensource@diasemi.com>" 
	<Anthony.Olech.OpenSource@diasemi.com>
Date: Tue, 28 Jan 2014 16:45:49 +0000
Subject: [PATCH V1] fix da9052 volatile register definition ommissions
To: Mark Brown <broonie@kernel.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Three of the PMIC registers have some bits that are changed
autonomously by the PMIC itself (some time) after being set
by some component driver of the DA9052 PMIC and hence they
need to be marked as volatile so that the regmap API will
not cache their values.

Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
Signed-off-by: David Dajun Chen <david.chen@diasemi.com>
---
This patch is relative to linux-next repository tag next-20140128

The bug that this patch fixes affects two components of DA9052 namely:

WATCHDOG - the first kick will work but sebsequent ones will not
           thus the will timeout at 2 x interval.

REGULATORS - the first change to any DA9052 BUCK voltage will be
             actioned, but sebsequent ones will not.

 drivers/mfd/da9052-core.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mfd/da9052-core.c b/drivers/mfd/da9052-core.c
index 25838f1..e8af816 100644
--- a/drivers/mfd/da9052-core.c
+++ b/drivers/mfd/da9052-core.c
@@ -279,6 +279,9 @@ static bool da9052_reg_volatile(struct device *dev, unsigned int reg)
 	case DA9052_EVENT_B_REG:
 	case DA9052_EVENT_C_REG:
 	case DA9052_EVENT_D_REG:
+	case DA9052_CONTROL_B_REG:
+	case DA9052_CONTROL_D_REG:
+	case DA9052_SUPPLY_REG:
 	case DA9052_FAULTLOG_REG:
 	case DA9052_CHG_TIME_REG:
 	case DA9052_ADC_RES_L_REG:
-- 
end-of-patch for fix da9052 volatile register definition ommissions V1

