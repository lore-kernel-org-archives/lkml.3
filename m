Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab3ILBiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 21:38:18 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:46913 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab3ILBiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 21:38:17 -0400
Message-ID: <1378949892.15915.1.camel@phoenix>
Subject: [PATCH] regulator: palmas: Remove wrong comment for the equation
 calculating num_voltages
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@linaro.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Thu, 12 Sep 2013 09:38:12 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current equation on the comment is wrong.
For linear mapping starting from 0, the equation is (maxV-minV)/stepV + 1.
Since the linear mapping for PALMAS is not all starting from 0, the equation
on the comment is not useful and misleading. Thus remove it.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/palmas-regulator.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index fba4faa..7e2b165 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -201,12 +201,6 @@ static unsigned int palmas_smps_ramp_delay[4] = {0, 10000, 5000, 2500};
 #define SMPS_CTRL_MODE_ECO		0x02
 #define SMPS_CTRL_MODE_PWM		0x03
 
-/* These values are derived from the data sheet. And are the number of steps
- * where there is a voltage change, the ranges at beginning and end of register
- * max/min values where there are no change are ommitted.
- *
- * So they are basically (maxV-minV)/stepV
- */
 #define PALMAS_SMPS_NUM_VOLTAGES	122
 #define PALMAS_SMPS10_NUM_VOLTAGES	2
 #define PALMAS_LDO_NUM_VOLTAGES		50
-- 
1.8.1.2



