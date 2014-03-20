Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103AbaCTFX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 01:23:58 -0400
Received: from [207.46.163.185] ([207.46.163.185]:49813 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750826AbaCTFXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 01:23:55 -0400
From: "fugang.duan@freescale.com" <fugang.duan@freescale.com>
To: =?utf-8?B?TG90aGFyIFdhw59tYW5u?= <LW@KARO-electronics.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        "Henrik Rydberg" <rydberg@euromail.se>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Jingoo Han <jg1.han@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        "Mark Rutland" <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Rob Landley <rob@landley.net>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Simon Budig <simon.budig@kernelconcepts.de>
Subject: RE: [PATCHv4 4/5] Input: edt-ft5x06: Ignore touchdown events
Thread-Topic: [PATCHv4 4/5] Input: edt-ft5x06: Ignore touchdown events
Thread-Index: AQHPQ3SHjxR1eLoJpkayETbGVIkr55rpcaHg
Date: Thu, 20 Mar 2014 05:22:01 +0000
Message-ID: <872e4d7ea1ed455592b0bf828d69fb26@BLUPR03MB373.namprd03.prod.outlook.com>
References: <1395234563-11034-1-git-send-email-LW@KARO-electronics.de>
 <1395234563-11034-5-git-send-email-LW@KARO-electronics.de>
In-Reply-To: <1395234563-11034-5-git-send-email-LW@KARO-electronics.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.158.215]
x-forefront-prvs: 01565FED4C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(979002)(6009001)(428001)(199002)(189002)(51704005)(377454003)(97186001)(51856001)(19580405001)(19580395003)(83322001)(56776001)(50986001)(81686001)(2201001)(81816001)(85852003)(83072002)(74366001)(90146001)(56816005)(92566001)(74316001)(54356001)(80976001)(4396001)(53806001)(47446002)(74662001)(31966008)(97336001)(49866001)(74502001)(93136001)(47736001)(54316002)(47976001)(76786001)(76796001)(76576001)(76482001)(46102001)(85306002)(74706001)(2656002)(74876001)(77982001)(59766001)(69226001)(94946001)(81542001)(87936001)(66066001)(79102001)(86362001)(95666003)(94316002)(575784001)(80022001)(87266001)(65816001)(63696002)(20776003)(95416001)(81342001)(33646001)(93516002)(1121002)(921003)(24736002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB373;H:BLUPR03MB373.namprd03.prod.outlook.com;FPR:3888466A.E6D3A029.55E4FB90.40E81AF1.2020E;MLV:ovrnspm;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2K5O32C019512

From: Lothar WaÃŸmann <LW@KARO-electronics.de>
Data: Wednesday, March 19, 2014 9:09 PM

>To: Dmitry Torokhov; Duan Fugang-B38611; Grant Likely; Henrik Rydberg; Ian
>Campbell; Jingoo Han; Kumar Gala; Mark Rutland; Pawel Moll; Rob Herring; Rob
>Landley; Sachin Kamat; devicetree@vger.kernel.org; linux-doc@vger.kernel.org;
>linux-input@vger.kernel.org; linux-kernel@vger.kernel.org; Simon Budig; Lothar
>WaÃŸmann
>Subject: [PATCHv4 4/5] Input: edt-ft5x06: Ignore touchdown events
>
>The chip may report invalid coordinates on touchdown events, so don't report
>the initial touchdown event.
>
>Signed-off-by: Lothar WaÃŸmann <LW@KARO-electronics.de>
>---
> drivers/input/touchscreen/edt-ft5x06.c |    4 ++++
> 1 file changed, 4 insertions(+)
>
>diff --git a/drivers/input/touchscreen/edt-ft5x06.c
>b/drivers/input/touchscreen/edt-ft5x06.c
>index 27dccfc..af736e4 100644
>--- a/drivers/input/touchscreen/edt-ft5x06.c
>+++ b/drivers/input/touchscreen/edt-ft5x06.c
>@@ -175,6 +175,10 @@ static irqreturn_t edt_ft5x06_ts_isr(int irq, void *dev_id)
> 		if (type == TOUCH_EVENT_RESERVED)
> 			continue;
>
>+		/* ignore TOUCH_DOWN events, might have bogus coordinates */
>+		if (type == TOUCH_EVENT_DOWN)
>+			continue;
>+
> 		x = ((buf[0] << 8) | buf[1]) & 0x0fff;
> 		y = ((buf[2] << 8) | buf[3]) & 0x0fff;
> 		id = (buf[2] >> 4) & 0x0f;
>--
>1.7.10.4
>
>

Acked-by: Fugang Duan <B38611@freescale.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
