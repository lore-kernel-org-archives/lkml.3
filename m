Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbbAHEHI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 23:07:08 -0500
Received: from mail-bl2on0127.outbound.protection.outlook.com ([65.55.169.127]:63488
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751082AbbAHEHG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 23:07:06 -0500
X-Greylist: delayed 1082 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Jan 2015 23:07:06 EST
From: "fugang.duan@freescale.com" <fugang.duan@freescale.com>
To: Stefan Agner <stefan@agner.ch>
CC: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "luwei.zhou@freescale.com" <luwei.zhou@freescale.com>,
        "LW@karo-electronics.de" <LW@karo-electronics.de>,
        "Frank.Li@freescale.com" <Frank.Li@freescale.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH] net: fec: Fix dual ethernet issue in VFxx
Thread-Topic: [PATCH] net: fec: Fix dual ethernet issue in VFxx
Thread-Index: AQHQKbelVfGyJmUy502usKjZPMiTlZyzLTOAgAC8ltCAAIyuAIABGwRg
Date: Thu, 8 Jan 2015 03:33:20 +0000
Message-ID: <BLUPR03MB3737C3BCB45CA74A4073E85F5470@BLUPR03MB373.namprd03.prod.outlook.com>
References: <1420552052-4697-1-git-send-email-bhuvanchandra.dv@toradex.com>
 <43ef2a336673e63b89abaf1a71df29e0@agner.ch>
 <BLUPR03MB373B990180F59D2515E9065F5460@BLUPR03MB373.namprd03.prod.outlook.com>
 <fe59d331ecef890284cd005ae62bc236@agner.ch>
In-Reply-To: <fe59d331ecef890284cd005ae62bc236@agner.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.52]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@freescale.com; 
x-dmarcaction: None
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BN3PR0301MB1217;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1217;
x-forefront-prvs: 0450A714CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(377424004)(189002)(51704005)(199003)(24454002)(377454003)(120916001)(99396003)(20776003)(77096005)(86362001)(54206007)(92566001)(40100003)(122556002)(76576001)(107046002)(99286002)(106356001)(106116001)(66066001)(105586002)(101416001)(68736005)(33656002)(102836002)(31966008)(2950100001)(64706001)(2900100001)(46102003)(87936001)(62966003)(77156002)(2656002)(54606007)(19580405001)(19580395003)(4396001)(76176999)(50986999)(54356999)(93886004)(74316001)(97736003)(110136001)(21056001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0301MB1217;H:BLUPR03MB373.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2015 03:33:20.3167
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR0301MB1217
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Agner <stefan@agner.ch> Sent: Wednesday, January 07, 2015 6:30 PM
> To: Duan Fugang-B38611
> Cc: Bhuvanchandra DV; linux-kernel@vger.kernel.org; Zhou Luwei-B45643;
> LW@karo-electronics.de; Li Frank-B20596; davem@davemloft.net
> Subject: RE: [PATCH] net: fec: Fix dual ethernet issue in VFxx
> 
> On 2015-01-07 03:11, fugang.duan@freescale.com wrote:
> > From: Stefan Agner <stefan@agner.ch> Sent: Tuesday, January 06, 2015
> > 10:52 PM
> >> To: Bhuvanchandra DV
> >> Cc: linux-kernel@vger.kernel.org; Zhou Luwei-B45643; LW@karo-
> >> electronics.de; Li Frank-B20596; Duan Fugang-B38611;
> >> davem@davemloft.net
> >> Subject: Re: [PATCH] net: fec: Fix dual ethernet issue in VFxx
> >>
> >> Fwiw, this patch really touches many devices and disables the quirk
> >> for some devices, but this is done by intent.
> >>
> >> The quirk FEC_QUIRK_ENET_MAC was active for i.MX28, i.MX6Q, Vybrid
> >> (mvf600-fec) and i.MX6SX. However, the new quirk is only enabled for
> >> i.MX28. i.MX6Q doesn't need the quirk since there is one FEC instance
> >> only anyway. Vybrid and i.MX6SX have a MDIO bus for each instance.
> >>
> >> Acked-by: Stefan Agner <stefan@agner.ch>
> >
> > We cannot do it by adding a quirk.
> > For Vybrid and i.MX6SX and later i.MX7 serial,  there have their own
> > MDIO bus for each MAC.
> > But, for board design, to save two pin (MDIO, MDC), MAC0 and MAC1
> > share the MDIO bus. For example, i.MX6SX sdb/sabreai/arm2 boards did
> > like this.
> 
> Hm, so those board use a circumstance which was SoC specific back at
> i.MX28 time. IMHO, "Out of luck" the shared MDIO bus is the first one
> even for those boards, hence this SoC specific work around still works.
> So I still think for the i.MX28 case, the quirk would be a viable
> solution, but not for those boards, I agree.
> 
> > So we must add one dts property to distinguish it, not a quirk.
> 
> Just adding a property to the FEC instance who's MDIO bus is in use seems
> somewhat archaic. There is a MDIO bus description for other SoC, do you
> have in mind how this should look like for fec?
> 
> --
> Stefan

In general,  MAC2 use MAC1 MDIO bus. Because MAC1 is registered firstly, then register MAC2.
We can invent one property like "shared-mii-bus" for MAC1 to tell driver there have other MACs use itself mii bus.
Of course, the property needs to add for MAC2 device node to tell driver it will share the MAC1 mii bus.

Whether add "shared-mii-bus" property depends on customer boards design.
The problem is related to boards design, not related to SOC itself, so I think add property is feasible. 

I don't know whether there have better solution for this.

Regards,
Andy
