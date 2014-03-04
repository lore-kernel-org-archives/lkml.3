Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049AbaCDK2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 05:28:45 -0500
Received: from mail-bn1blp0183.outbound.protection.outlook.com ([207.46.163.183]:47213
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757032AbaCDK2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 05:28:43 -0500
From: Yibin Gong <yibin.gong@freescale.com>
To: Axel Lin <axel.lin@ingics.com>, Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] regulator: pfuze100: Add terminate entry for
 [i2c|of]_device_id tables
Thread-Topic: [PATCH] regulator: pfuze100: Add terminate entry for
 [i2c|of]_device_id tables
Thread-Index: AQHPN5NflDGVuwL+CUafcPjWSkijsZrQuYAg
Date: Tue, 4 Mar 2014 10:28:40 +0000
Message-ID: <a271fdb788164d8196a49e4e0b696d86@BLUPR03MB036.namprd03.prod.outlook.com>
References: <1393928414.9669.1.camel@phoenix>
In-Reply-To: <1393928414.9669.1.camel@phoenix>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 01401330D1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(377454003)(13464003)(199002)(189002)(83322001)(19580395003)(56816005)(76576001)(92566001)(19580405001)(93136001)(81816001)(74706001)(76786001)(80976001)(53806001)(77096001)(74316001)(80022001)(77982001)(81686001)(74876001)(59766001)(85306002)(79102001)(54356001)(76796001)(66066001)(69226001)(94316002)(56776001)(47736001)(74662001)(65816001)(76482001)(50986001)(54316002)(95666003)(4396001)(47976001)(87936001)(49866001)(81542001)(86362001)(575784001)(87266001)(63696002)(2656002)(95416001)(90146001)(74366001)(74502001)(31966008)(83072002)(85852003)(33646001)(51856001)(93516002)(46102001)(81342001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB421;H:BLUPR03MB036.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:F8BF3D53.B2B9EEB.A3C1B36F.9FD65A01.20235;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s24ASrId002787

Acked-by: Robin Gong <b38343@freescale.com>

-----Original Message-----
From: Axel Lin [mailto:axel.lin@ingics.com] 
Sent: Tuesday, March 04, 2014 6:20 PM
To: Mark Brown
Cc: Gong Yibin-B38343; Liam Girdwood; linux-kernel@vger.kernel.org
Subject: [PATCH] regulator: pfuze100: Add terminate entry for [i2c|of]_device_id tables

Also remove PFUZE_NUM to avoid below build warnings:

  CC [M]  drivers/regulator/pfuze100-regulator.o
drivers/regulator/pfuze100-regulator.c:86:2: warning: excess elements in array initializer [enabled by default]
drivers/regulator/pfuze100-regulator.c:86:2: warning: (near initialization for 'pfuze_device_id') [enabled by default]
drivers/regulator/pfuze100-regulator.c:93:2: warning: excess elements in array initializer [enabled by default]
drivers/regulator/pfuze100-regulator.c:93:2: warning: (near initialization for 'pfuze_dt_ids') [enabled by default]

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/pfuze100-regulator.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
index 44075f8..f87ec70 100644
--- a/drivers/regulator/pfuze100-regulator.c
+++ b/drivers/regulator/pfuze100-regulator.c
@@ -56,7 +56,7 @@
 #define PFUZE100_VGEN5VOL	0x70
 #define PFUZE100_VGEN6VOL	0x71
 
-enum chips {PFUZE100, PFUZE200, PFUZE_NUM};
+enum chips { PFUZE100, PFUZE200 };
 
 struct pfuze_regulator {
 	struct regulator_desc desc;
@@ -80,15 +80,17 @@ static const int pfuze100_vsnvs[] = {
 	1000000, 1100000, 1200000, 1300000, 1500000, 1800000, 3000000,  };
 
-static const struct i2c_device_id pfuze_device_id[PFUZE_NUM] = {
+static const struct i2c_device_id pfuze_device_id[] = {
 	{.name = "pfuze100", .driver_data = PFUZE100},
 	{.name = "pfuze200", .driver_data = PFUZE200},
+	{ }
 };
 MODULE_DEVICE_TABLE(i2c, pfuze_device_id);
 
-static const struct of_device_id pfuze_dt_ids[PFUZE_NUM] = {
+static const struct of_device_id pfuze_dt_ids[] = {
 	{ .compatible = "fsl,pfuze100", .data = (void *)PFUZE100},
 	{ .compatible = "fsl,pfuze200", .data = (void *)PFUZE200},
+	{ }
 };
 MODULE_DEVICE_TABLE(of, pfuze_dt_ids);
 
--
1.8.1.2





ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
