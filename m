Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab3DLHdd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 03:33:33 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33200 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab3DLHdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 03:33:32 -0400
Message-ID: <1365752005.15003.1.camel@phoenix>
Subject: [RFT][PATCH] regulator: ab8500: Fix voltage_mask for
 AB8505_LDO_AUDIO
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Fri, 12 Apr 2013 15:33:25 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The voltage_mask and voltage_shift settings of AB8505_LDO_AUDIO are not matched.
It looks like a typo in the voltage_mask settings.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
Hi Lee and Bengt,
I don't have the datasheet. Can you confirm if this fix is correct?

Thanks,
Axel
 drivers/regulator/ab8500.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index ea182d3..b81ff04 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -1130,7 +1130,7 @@ static struct ab8500_regulator_info
 		.update_val		= 0x02,
 		.voltage_bank		= 0x01,
 		.voltage_reg		= 0x57,
-		.voltage_mask		= 0x7,
+		.voltage_mask		= 0x70,
 		.voltage_shift		= 4,
 	},
 	[AB8505_LDO_ANAMIC1] = {
-- 
1.7.10.4



