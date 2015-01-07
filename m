Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933403AbbAGCL4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:11:56 -0500
Received: from mail-bn1bon0138.outbound.protection.outlook.com ([157.56.111.138]:31489
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933379AbbAGCLy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:11:54 -0500
From: "fugang.duan@freescale.com" <fugang.duan@freescale.com>
To: Stefan Agner <stefan@agner.ch>,
        Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "luwei.zhou@freescale.com" <luwei.zhou@freescale.com>,
        "LW@karo-electronics.de" <LW@karo-electronics.de>,
        "Frank.Li@freescale.com" <Frank.Li@freescale.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH] net: fec: Fix dual ethernet issue in VFxx
Thread-Topic: [PATCH] net: fec: Fix dual ethernet issue in VFxx
Thread-Index: AQHQKbelVfGyJmUy502usKjZPMiTlZyzLTOAgAC8ltA=
Date: Wed, 7 Jan 2015 02:11:51 +0000
Message-ID: <BLUPR03MB373B990180F59D2515E9065F5460@BLUPR03MB373.namprd03.prod.outlook.com>
References: <1420552052-4697-1-git-send-email-bhuvanchandra.dv@toradex.com>
 <43ef2a336673e63b89abaf1a71df29e0@agner.ch>
In-Reply-To: <43ef2a336673e63b89abaf1a71df29e0@agner.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.51]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@freescale.com; 
x-dmarcaction: None
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BN3PR0301MB1283;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1283;
x-forefront-prvs: 044968D9E1
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(51704005)(164054003)(377424004)(24454002)(189002)(377454003)(19580395003)(77156002)(62966003)(40100003)(97736003)(19580405001)(74316001)(101416001)(31966008)(54206007)(33656002)(4396001)(46102003)(105586002)(66066001)(106116001)(86362001)(102836002)(87936001)(99286002)(120916001)(76576001)(107046002)(2900100001)(99396003)(2950100001)(21056001)(92566001)(106356001)(122556002)(54356999)(76176999)(50986999)(54606007)(20776003)(77096005)(68736005)(64706001)(2656002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0301MB1283;H:BLUPR03MB373.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2015 02:11:51.9092
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR0301MB1283
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Agner <stefan@agner.ch> Sent: Tuesday, January 06, 2015 10:52 PM
> To: Bhuvanchandra DV
> Cc: linux-kernel@vger.kernel.org; Zhou Luwei-B45643; LW@karo-
> electronics.de; Li Frank-B20596; Duan Fugang-B38611; davem@davemloft.net
> Subject: Re: [PATCH] net: fec: Fix dual ethernet issue in VFxx
> 
> Fwiw, this patch really touches many devices and disables the quirk for
> some devices, but this is done by intent.
> 
> The quirk FEC_QUIRK_ENET_MAC was active for i.MX28, i.MX6Q, Vybrid
> (mvf600-fec) and i.MX6SX. However, the new quirk is only enabled for
> i.MX28. i.MX6Q doesn't need the quirk since there is one FEC instance
> only anyway. Vybrid and i.MX6SX have a MDIO bus for each instance.
> 
> Acked-by: Stefan Agner <stefan@agner.ch>

We cannot do it by adding a quirk.
For Vybrid and i.MX6SX and later i.MX7 serial,  there have their own MDIO bus for each MAC.
But, for board design, to save two pin (MDIO, MDC), MAC0 and MAC1 share the MDIO bus. For example, i.MX6SX sdb/sabreai/arm2 boards did like this.
So we must add one dts property to distinguish it, not a quirk. 

Thanks,
Andy
> 
> On 2015-01-06 14:47, Bhuvanchandra DV wrote:
> > On i.MX28, the MDIO bus is shared between the two RMII interfaces.
> > However, in newer designs, such as Vybrid, this is not the case. This
> > patch adds a quirk for the single MDIO case. This allows to use both
> > FEC interfaces working independently on Vybird.
> >
> > Signed-off-by: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
> > ---
> >  drivers/net/ethernet/freescale/fec.h      |    3 +++
> >  drivers/net/ethernet/freescale/fec_main.c |    7 ++++---
> >  2 files changed, 7 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/freescale/fec.h
> > b/drivers/net/ethernet/freescale/fec.h
> > index 469691a..c9515bc 100644
> > --- a/drivers/net/ethernet/freescale/fec.h
> > +++ b/drivers/net/ethernet/freescale/fec.h
> > @@ -425,6 +425,9 @@ struct bufdesc_ex {
> >   */
> >  #define FEC_QUIRK_BUG_CAPTURE		(1 << 10)
> >
> > +/* Controller has only one MDIO bus for interfacing external PHY's */
> > +#define FEC_QUIRK_SINGLE_MDIO		(1 << 11)
> > +
> >  struct fec_enet_priv_tx_q {
> >  	int index;
> >  	unsigned char *tx_bounce[TX_RING_SIZE]; diff --git
> > a/drivers/net/ethernet/freescale/fec_main.c
> > b/drivers/net/ethernet/freescale/fec_main.c
> > index 5ebdf8d..22b7748 100644
> > --- a/drivers/net/ethernet/freescale/fec_main.c
> > +++ b/drivers/net/ethernet/freescale/fec_main.c
> > @@ -91,7 +91,8 @@ static struct platform_device_id fec_devtype[] = {
> >  		.driver_data = 0,
> >  	}, {
> >  		.name = "imx28-fec",
> > -		.driver_data = FEC_QUIRK_ENET_MAC | FEC_QUIRK_SWAP_FRAME,
> > +		.driver_data = FEC_QUIRK_ENET_MAC | FEC_QUIRK_SWAP_FRAME |
> > +				FEC_QUIRK_SINGLE_MDIO,
> >  	}, {
> >  		.name = "imx6q-fec",
> >  		.driver_data = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT | @@ -
> 1952,7
> > +1953,7 @@ static int fec_enet_mii_init(struct platform_device *pdev)
> >  	 * mdio interface in board design, and need to be configured by
> >  	 * fec0 mii_bus.
> >  	 */
> > -	if ((fep->quirks & FEC_QUIRK_ENET_MAC) && fep->dev_id > 0) {
> > +	if ((fep->quirks & FEC_QUIRK_SINGLE_MDIO) && fep->dev_id > 0) {
> >  		/* fec1 uses fec0 mii_bus */
> >  		if (mii_cnt && fec0_mii_bus) {
> >  			fep->mii_bus = fec0_mii_bus;
> > @@ -2015,7 +2016,7 @@ static int fec_enet_mii_init(struct
> platform_device *pdev)
> >  	mii_cnt++;
> >
> >  	/* save fec0 mii_bus */
> > -	if (fep->quirks & FEC_QUIRK_ENET_MAC)
> > +	if (fep->quirks & FEC_QUIRK_SINGLE_MDIO)
> >  		fec0_mii_bus = fep->mii_bus;
> >
> >  	return 0;
