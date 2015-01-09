Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbbAIInd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 03:43:33 -0500
Received: from mail-bl2on0132.outbound.protection.outlook.com ([65.55.169.132]:21001
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754304AbbAIInc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 03:43:32 -0500
From: "fugang.duan@freescale.com" <fugang.duan@freescale.com>
To: Stefan Agner <stefan@agner.ch>
CC: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "luwei.zhou@freescale.com" <luwei.zhou@freescale.com>,
        "LW@karo-electronics.de" <LW@karo-electronics.de>,
        "Frank.Li@freescale.com" <Frank.Li@freescale.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>
Subject: RE: [PATCH] net: fec: Fix dual ethernet issue in VFxx
Thread-Topic: [PATCH] net: fec: Fix dual ethernet issue in VFxx
Thread-Index: AQHQKbelVfGyJmUy502usKjZPMiTlZyzLTOAgAC8ltCAAIyuAIABGwRggAEFVoCAAHtY0IAAZSWAgAAEpwA=
Date: Fri, 9 Jan 2015 08:43:29 +0000
Message-ID: <BLUPR03MB373C95CD17B1CBBCE2DF72EF5440@BLUPR03MB373.namprd03.prod.outlook.com>
References: <1420552052-4697-1-git-send-email-bhuvanchandra.dv@toradex.com>
 <43ef2a336673e63b89abaf1a71df29e0@agner.ch>
 <BLUPR03MB373B990180F59D2515E9065F5460@BLUPR03MB373.namprd03.prod.outlook.com>
 <fe59d331ecef890284cd005ae62bc236@agner.ch>
 <BLUPR03MB3737C3BCB45CA74A4073E85F5470@BLUPR03MB373.namprd03.prod.outlook.com>
 <971bb29592c6ff4e786a988d850e1956@agner.ch>
 <BLUPR03MB37305F1987D65A4E0A24F3CF5440@BLUPR03MB373.namprd03.prod.outlook.com>
 <cc982a9f7e35329fd4f43ba706087351@agner.ch>
In-Reply-To: <cc982a9f7e35329fd4f43ba706087351@agner.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.51]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@freescale.com; 
x-dmarcaction: None
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:CY1PR0301MB1226;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1226;
x-forefront-prvs: 04519BA941
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(377454003)(189002)(377424004)(51704005)(24454002)(106356001)(46102003)(92566001)(68736005)(99286002)(105586002)(2900100001)(31966008)(2950100001)(74316001)(107046002)(76576001)(106116001)(110136001)(102836002)(77096005)(66066001)(97736003)(50986999)(87936001)(120916001)(122556002)(19580395003)(93886004)(54206007)(2656002)(62966003)(40100003)(76176999)(77156002)(4396001)(86362001)(101416001)(21056001)(20776003)(64706001)(54356999)(33656002)(19580405001)(54606007)(99396003);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB1226;H:BLUPR03MB373.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2015 08:43:29.0713
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR0301MB1226
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Agner <stefan@agner.ch> Sent: Friday, January 09, 2015 4:22 PM
> To: Duan Fugang-B38611
> Cc: Bhuvanchandra DV; linux-kernel@vger.kernel.org; Zhou Luwei-B45643;
> LW@karo-electronics.de; Li Frank-B20596; davem@davemloft.net; u.kleine-
> koenig@pengutronix.de; shawn.guo@linaro.org
> Subject: RE: [PATCH] net: fec: Fix dual ethernet issue in VFxx
> 
> On 2015-01-09 04:00, fugang.duan@freescale.com wrote:
> > From: Stefan Agner <stefan@agner.ch> Sent: Friday, January 09, 2015
> > 2:59 AM
> >> To: Duan Fugang-B38611
> >> Cc: Bhuvanchandra DV; linux-kernel@vger.kernel.org; Zhou
> >> Luwei-B45643; LW@karo-electronics.de; Li Frank-B20596;
> >> davem@davemloft.net; u.kleine- koenig@pengutronix.de;
> >> shawn.guo@linaro.org
> >> Subject: RE: [PATCH] net: fec: Fix dual ethernet issue in VFxx
> >>
[snip]
> 
> Currently, MAC1 is broken in case 3 on Vybrid (as well as i.MX6XS and
> i.MX7, because the FEC_QUIRK_ENET_MAC is enabled for all of them).
> 
> > For all these cases, your above patches cannot handle these.
> 
> Yes, in it's current state, I agree. A new revision is required.
> 
> > So I still insist to add another property for this to avoid the
> > existing dts files change.
> 
> But I don't think adding another device tree property is helping here.
> There is already a device tree standard how to describe the MDIO buses,
> why not just make use of them?
> 
> I will create a v2 patchset, so we have a new base to discuss this
> further.
> 
Don't invent new property, and compatible with above four cases (avoid existing dts changing), it is difficult.
Looking forward to your next patchset.

Regards,
Andy
