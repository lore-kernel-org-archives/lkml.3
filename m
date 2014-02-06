Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbaBKQS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:18:26 -0500
Received: from mail1.bemta14.messagelabs.com ([193.109.254.113]:46438 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750984AbaBKQSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:18:25 -0500
X-Env-Sender: anthony.olech.opensource@diasemi.com
X-Msg-Ref: server-2.tower-194.messagelabs.com!1392135095!2802940!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <201402111611.s1BGBXkr056672@swsrvapps-02.lan>
From: "Anthony Olech <anthony.olech.opensource@diasemi.com>" 
	<Anthony.Olech.OpenSource@diasemi.com>
Date: Thu, 6 Feb 2014 17:33:24 +0000
Subject: [PATCH V2] mfd: da9052: Fix volatile register definition ommissions
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
CC: <linux-kernel@vger.kernel.org>, David Dajun Chen <david.chen@diasemi.com>
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
Acked-by: David Dajun Chen <david.chen@diasemi.com>
---

This patch is relative to linux-next repository tag next-20140206

The problem was detected whilst running a scripted set of functional
regression tests whilst investigating a different problem.

This patch has been test compiled on an amd64 server for both x86
and arm targets.

This patch has been spot verified using an SMDK6410 platform
fly-wired to a Dialog da9053 EVB.

The bug that this patch fixes affects two components of DA9052 namely:

WATCHDOG - the first kick will work but sebsequent ones will not
           thus the watchdog will timeout at 2 x interval.

REGULATORS - the first change to any DA9052/DA9053  BUCK voltage
             will be actioned, but sebsequent ones will not.

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
end-of-patch for mfd: da9052: Fix volatile register definition ommissions V2

