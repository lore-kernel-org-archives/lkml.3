Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422707AbaDJUEK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 16:04:10 -0400
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:37821 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422694AbaDJUEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 16:04:08 -0400
X-IronPort-AV: E=Sophos;i="4.97,835,1389772800"; 
   d="scan'208";a="23692774"
From: Tim Kryger <tim.kryger@linaro.org>
To: Matt Porter <mporter@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>
CC: Tim Kryger <tim.kryger@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] regulator: bcm590xx: Set n_voltages for linear reg
Date: Thu, 10 Apr 2014 13:04:00 -0700
Message-ID: <1397160240-2833-1-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the macro used to define linear range regulators to include the
number of voltages.

Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
---
 drivers/regulator/bcm590xx-regulator.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/bcm590xx-regulator.c b/drivers/regulator/bcm590xx-regulator.c
index ab08ca7..c3750c5 100644
--- a/drivers/regulator/bcm590xx-regulator.c
+++ b/drivers/regulator/bcm590xx-regulator.c
@@ -123,6 +123,7 @@ struct bcm590xx_info {
 #define BCM590XX_REG_RANGES(_name, _ranges) \
 	{ \
 		.name = #_name, \
+		.n_voltages = 64, \
 		.n_linear_ranges = ARRAY_SIZE(_ranges), \
 		.linear_ranges = _ranges, \
 	}
-- 
1.7.9.5

