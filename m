Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab3DVKW6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 06:22:58 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:64972 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126Ab3DVKWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 06:22:55 -0400
Message-ID: <1366626169.3800.1.camel@phoenix>
Subject: [PATCH RESEND] regulator: palmas: Fix off-by-one for ramp_delay and
 register value mapping
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Mon, 22 Apr 2013 18:22:49 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Datasheet says:
Time Step (TSTEP) selection, when changing the output voltage, the new value is
reached through successive voltage steps (if not bypassed). The equivalent
programmable slew rate of the output voltage is:

TSTEP[1:0]: 00 Jump (no slope control)
TSTEP[1:0]: 01 10mV/us
TSTEP[1:0]: 10 5mV/us (default)
TSTEP[1:0]: 11 2.5mV/us

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
This resend updates the commit log.

 drivers/regulator/palmas-regulator.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 8fed60c..e3e8373 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -447,9 +447,9 @@ static int palmas_smps_set_ramp_delay(struct regulator_dev *rdev,
 
 	if (ramp_delay <= 0)
 		reg = 0;
-	else if (ramp_delay < 2500)
+	else if (ramp_delay <= 2500)
 		reg = 3;
-	else if (ramp_delay < 5000)
+	else if (ramp_delay <= 5000)
 		reg = 2;
 	else
 		reg = 1;
-- 
1.7.10.4



