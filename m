Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760019Ab3DBGeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 02:34:37 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:42374 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758310Ab3DBGeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 02:34:36 -0400
Message-ID: <1364884470.12936.2.camel@phoenix>
Subject: [RFT][PATCH 2/2] regulator: ab8500: Add missing volt_table setting
 for AB8540_LDO_TVOUT
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Tue, 02 Apr 2013 14:34:30 +0800
In-Reply-To: <1364884370.12936.0.camel@phoenix>
References: <1364884370.12936.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required for regulator_list_voltage_table() to properly work.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
Hi,
The setting is copied from AB8500_LDO_TVOUT, I don't have the datasheet.
Can someone test and review if this patch is correct or not?

Axel
 drivers/regulator/ab8500.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 5fd764e..44602c5 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -1303,6 +1303,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_TVOUT,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.volt_table	= fixed_2000000_voltage,
 		},
 		.load_lp_uA		= 1000,
 		.update_bank		= 0x03,
-- 
1.7.10.4



