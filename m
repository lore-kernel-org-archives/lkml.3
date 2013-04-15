Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935328Ab3DOIhA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 04:37:00 -0400
Received: from mail-da0-f51.google.com ([209.85.210.51]:39273 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933777Ab3DOIg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 04:36:58 -0400
Message-ID: <1366015011.13029.1.camel@phoenix>
Subject: [PATCH RFT] regulator: ab8500: Fix voltage_shift setting for
 AB8540_LDO_DMIC
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Mon, 15 Apr 2013 16:36:51 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The voltage_mask is 0xc0, thus we need to set voltage_shift = 6 to get correct
selector in get_voltage_sel and set_voltage_sel.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
Hi Bengt,
I don't have the datasheet. Can you confirm if this fix is correct?

BTW, can you also review a couple patches for ab8500 and ab8500-ext I sent a few
days ago? I ask this because now I have more patches that may depend on previous
patches.

Thanks,
Axel

 drivers/regulator/ab8500.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index b81ff04..0a62ef9 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -1729,6 +1729,7 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x03,
 		.voltage_reg		= 0x83,
 		.voltage_mask		= 0xc0,
+		.voltage_shift		= 6,
 	},
 
 	/*
-- 
1.7.10.4



