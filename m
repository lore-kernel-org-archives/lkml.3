Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447AbaE0DFw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 23:05:52 -0400
Received: from mail-bl2lp0211.outbound.protection.outlook.com ([207.46.163.211]:46790
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751887AbaE0DFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 23:05:51 -0400
From: Yibin Gong <yibin.gong@freescale.com>
To: Axel Lin <axel.lin@ingics.com>, Mark Brown <broonie@kernel.org>
CC: "Fabio.Estevam@freescale.com" <Fabio.Estevam@freescale.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFT][PATCH] regulator: pfuze100: Support enable/disable for
 fixed regulator
Thread-Topic: [RFT][PATCH] regulator: pfuze100: Support enable/disable for
 fixed regulator
Thread-Index: AQHPeMi/QghsP9ZTdUKLGQIVyT5BGZtTvutg
Date: Tue, 27 May 2014 03:05:35 +0000
Message-ID: <cf4da38b716044d598a0e3b77f403f39@BLUPR03MB036.namprd03.prod.outlook.com>
References: <1401098173.12646.1.camel@phoenix>
In-Reply-To: <1401098173.12646.1.camel@phoenix>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.158.211]
x-forefront-prvs: 02243C58C6
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(377454003)(164054003)(13464003)(189002)(199002)(92566001)(19580395003)(19580405001)(83322001)(81542001)(81342001)(76482001)(77982001)(85852003)(86362001)(83072002)(33646001)(66066001)(80022001)(99286001)(74502001)(99396002)(74662001)(101416001)(21056001)(79102001)(4396001)(74316001)(20776003)(64706001)(46102001)(31966008)(76176999)(50986999)(54356999)(2656002)(76576001)(87936001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB246;H:BLUPR03MB036.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yibin.gong@freescale.com; 
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4R364Fo019696

Tested-by: Robin Gong <b38343@freescale.com>
Acked-by: Robin Gong <b38343@freescale.com>

-----Original Message-----
From: Axel Lin [mailto:axel.lin@ingics.com] 
Sent: Monday, May 26, 2014 5:56 PM
To: Mark Brown
Cc: Gong Yibin-B38343; Estevam Fabio-R49496; Liam Girdwood; linux-kernel@vger.kernel.org
Subject: [RFT][PATCH] regulator: pfuze100: Support enable/disable for fixed regulator

Current code has .enable_reg and .enable_mask settings, but the implementation for corresponding callbacks are missing. Fix it.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
Hi Robin,
Can you review and test this patch?
Thanks,
Axel

 drivers/regulator/pfuze100-regulator.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
index 67e678c..b6b4529 100644
--- a/drivers/regulator/pfuze100-regulator.c
+++ b/drivers/regulator/pfuze100-regulator.c
@@ -125,6 +125,9 @@ static struct regulator_ops pfuze100_ldo_regulator_ops = {  };
 
 static struct regulator_ops pfuze100_fixed_regulator_ops = {
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
+	.is_enabled = regulator_is_enabled_regmap,
 	.list_voltage = regulator_list_voltage_linear,  };
 
--
1.8.3.2



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
