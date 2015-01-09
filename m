Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065AbbAIDAe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 22:00:34 -0500
Received: from mail-bl2on0111.outbound.protection.outlook.com ([65.55.169.111]:31393
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752110AbbAIDAd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 22:00:33 -0500
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
Thread-Index: AQHQKbelVfGyJmUy502usKjZPMiTlZyzLTOAgAC8ltCAAIyuAIABGwRggAEFVoCAAHtY0A==
Date: Fri, 9 Jan 2015 03:00:30 +0000
Message-ID: <BLUPR03MB37305F1987D65A4E0A24F3CF5440@BLUPR03MB373.namprd03.prod.outlook.com>
References: <1420552052-4697-1-git-send-email-bhuvanchandra.dv@toradex.com>
 <43ef2a336673e63b89abaf1a71df29e0@agner.ch>
 <BLUPR03MB373B990180F59D2515E9065F5460@BLUPR03MB373.namprd03.prod.outlook.com>
 <fe59d331ecef890284cd005ae62bc236@agner.ch>
 <BLUPR03MB3737C3BCB45CA74A4073E85F5470@BLUPR03MB373.namprd03.prod.outlook.com>
 <971bb29592c6ff4e786a988d850e1956@agner.ch>
In-Reply-To: <971bb29592c6ff4e786a988d850e1956@agner.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.51]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@freescale.com; 
x-dmarcaction: None
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:CY1PR0301MB1290;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1290;
x-forefront-prvs: 04519BA941
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(24454002)(189002)(377424004)(377454003)(51704005)(199003)(106116001)(110136001)(46102003)(106356001)(87936001)(105586002)(102836002)(93886004)(50986999)(107046002)(76176999)(54356999)(54606007)(99286002)(2656002)(19580395003)(4396001)(99396003)(120916001)(19580405001)(21056001)(76576001)(68736005)(77096005)(92566001)(62966003)(64706001)(2950100001)(97736003)(31966008)(77156002)(20776003)(2900100001)(66066001)(86362001)(575784001)(101416001)(33656002)(40100003)(122556002)(54206007)(74316001)(183404003)(414714003)(473944003);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB1290;H:BLUPR03MB373.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2015 03:00:30.1527
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR0301MB1290
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Agner <stefan@agner.ch> Sent: Friday, January 09, 2015 2:59 AM
> To: Duan Fugang-B38611
> Cc: Bhuvanchandra DV; linux-kernel@vger.kernel.org; Zhou Luwei-B45643;
> LW@karo-electronics.de; Li Frank-B20596; davem@davemloft.net; u.kleine-
> koenig@pengutronix.de; shawn.guo@linaro.org
> Subject: RE: [PATCH] net: fec: Fix dual ethernet issue in VFxx
> 
> On 2015-01-08 04:33, fugang.duan@freescale.com wrote:
> > From: Stefan Agner <stefan@agner.ch> Sent: Wednesday, January 07, 2015
> > 6:30 PM
> >> To: Duan Fugang-B38611
> >> Cc: Bhuvanchandra DV; linux-kernel@vger.kernel.org; Zhou
> >> Luwei-B45643; LW@karo-electronics.de; Li Frank-B20596;
> >> davem@davemloft.net
> >> Subject: RE: [PATCH] net: fec: Fix dual ethernet issue in VFxx
> >>
> >> On 2015-01-07 03:11, fugang.duan@freescale.com wrote:
> >> > From: Stefan Agner <stefan@agner.ch> Sent: Tuesday, January 06,
> >> > 2015
> >> > 10:52 PM
> >> >> To: Bhuvanchandra DV
> >> >> Cc: linux-kernel@vger.kernel.org; Zhou Luwei-B45643; LW@karo-
> >> >> electronics.de; Li Frank-B20596; Duan Fugang-B38611;
> >> >> davem@davemloft.net
> >> >> Subject: Re: [PATCH] net: fec: Fix dual ethernet issue in VFxx
> >> >>
> >> >> Fwiw, this patch really touches many devices and disables the
> >> >> quirk for some devices, but this is done by intent.
> >> >>
> >> >> The quirk FEC_QUIRK_ENET_MAC was active for i.MX28, i.MX6Q, Vybrid
> >> >> (mvf600-fec) and i.MX6SX. However, the new quirk is only enabled
> >> >> for i.MX28. i.MX6Q doesn't need the quirk since there is one FEC
> >> >> instance only anyway. Vybrid and i.MX6SX have a MDIO bus for each
> instance.
> >> >>
> >> >> Acked-by: Stefan Agner <stefan@agner.ch>
> >> >
> >> > We cannot do it by adding a quirk.
> >> > For Vybrid and i.MX6SX and later i.MX7 serial,  there have their
> >> > own MDIO bus for each MAC.
> >> > But, for board design, to save two pin (MDIO, MDC), MAC0 and MAC1
> >> > share the MDIO bus. For example, i.MX6SX sdb/sabreai/arm2 boards
> >> > did like this.
> >>
> >> Hm, so those board use a circumstance which was SoC specific back at
> >> i.MX28 time. IMHO, "Out of luck" the shared MDIO bus is the first one
> >> even for those boards, hence this SoC specific work around still works.
> >> So I still think for the i.MX28 case, the quirk would be a viable
> >> solution, but not for those boards, I agree.
> >>
> >> > So we must add one dts property to distinguish it, not a quirk.
> >>
> >> Just adding a property to the FEC instance who's MDIO bus is in use
> >> seems somewhat archaic. There is a MDIO bus description for other
> >> SoC, do you have in mind how this should look like for fec?
> >>
> >> --
> >> Stefan
> 
> (added Uwe to CC since he added the device tree support for MDIO bus)
> 
> > In general,  MAC2 use MAC1 MDIO bus. Because MAC1 is registered
> > firstly, then register MAC2.
> > We can invent one property like "shared-mii-bus" for MAC1 to tell
> > driver there have other MACs use itself mii bus.
> > Of course, the property needs to add for MAC2 device node to tell
> > driver it will share the MAC1 mii bus.
> 
> There is actually already lot of device tree support for MDIO bus
> description in place (see of_mdiobus_register call in the fec_main
> driver), just the device tree's do not make a lot use of it currently.
> 
> The vf610-twr.dts has both FEC enabled as well as the quirk is enabled in
> the driver for Vybrid. I tested the Tower System Module TWR-SER2 with
> Vybrid. This module has two ethernet PHY's, but _both_ are connected to
> the first RMII's MDIO bus (FEC0). Thanks to the quirk, both ports work
> fine.
> 
> As a side note: Don't be fooled that there are both MDIO buses available
> on the elevator: The module makes use of the MDIO of the first RMII
> signals only, see TWR-SER2 schematic.
> 
> I then disabled the quirk and altered the device tree (patch courtesy of
> Bhuvan):
> 
> diff --git a/arch/arm/boot/dts/vf610-twr.dts b/arch/arm/boot/dts/vf610-
> twr.dts index a0f7621..876c80a 100644
> --- a/arch/arm/boot/dts/vf610-twr.dts
> +++ b/arch/arm/boot/dts/vf610-twr.dts
> @@ -129,13 +129,28 @@
> 
>  &fec0 {
>         phy-mode = "rmii";
> +       phy-handle = <&ethphy0>;
>         pinctrl-names = "default";
>         pinctrl-0 = <&pinctrl_fec0>;
>         status = "okay";
> +
> +       fec0mdio: mdio {
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +
> +               ethphy0: ethernet-phy@0 {
> +                       reg = <0>;
> +               };
> +
> +               ethphy1: ethernet-phy@1 {
> +                       reg = <1>;
> +               };
> +       };
>  };
> 
>  &fec1 {
>         phy-mode = "rmii";
> +       phy-handle = <&ethphy1>;
>         pinctrl-names = "default";
>         pinctrl-0 = <&pinctrl_fec1>;
>         status = "okay";
> 
> This worked also fine! Hence we actually already have all device tree
> support needed. For the case we try to solve (using the MDIO bus of each
> RMII), a device tree like this should be sufficient:
> 
> &fec0 {
> 	phy-mode = "rmii";
> 	phy-handle = <&ethphy0>;
> ...
> 
> 	fec0mdio: mdio {
> 		#address-cells = <1>;
> 		#size-cells = <0>;
> 
> 		ethphy0: ethernet-phy@0 {
> 			reg = <0>;
> 		};
> 	};
> };
> 
> &fec1 {
> ...
> 	phy-handle = <&ethphy1>;
> ...
> 
> 	fec1mdio: mdio {
> 		#address-cells = <1>;
> 		#size-cells = <0>;
> 
> 		ethphy1: ethernet-phy@1 {
> 			reg = <1>;
> 		};
> 	};
> };
> 
> Unfortunately, the quirk FEC_QUIRK_ENET_MAC leads to fec_enet_mii_init
> return early for the _second_ FEC. Even if the PHY's would be properly
> described in dt, parsing is prevented by that quirk.
> 
> Hence my suggestion is this:
> - Implement the FEC_QUIRK_SINGLE_MDIO and add it to as in this patch,
> which makes the quirk always work for i.MX28 even without dt changes...
> (backward compatible)
> - Fix the Tower device tree using the patch above to make the Tower work
> again
> - i.MX6SX is similar to Vybrid in that regard, adding a patch similar to
> the one above should make the SX boards work too
> - i.MX6S/D/Q is not affected since only one FEC instance is available
> - i.MX7 is not yet merged, so a proper device tree description can be
> used upfront
> 
> This would break old device trees with newer kernels for i.MX6SX and
> Vybrid.. The first is quite new, and the latter is not very widespread,
> IMHO this would be acceptable. Also, the device tree just did not
> describe the hardware completely. "Out of a luck" (just because the MDIO
> quirk for the i.MX28 SoC is active for all SoC's)..., it currently
> works...
> 
> Alternatively, we can add the FEC_QUIRK_SINGLE_MDIO quirk to driver_data
> of imx6sx-fec and mvf600-fec. Then, check early if a MDIO bus description
> is available. This would keep the current device tree's working while
> having support to describe other boards in device tree's in the future
> (something along these lines):
> 
> diff --git a/drivers/net/ethernet/freescale/fec_main.c
> b/drivers/net/ethernet/freescale/fec_main.c
> index 5ebdf8d..527eb3e 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -1952,7 +1952,8 @@ static int fec_enet_mii_init(struct platform_device
> *pdev)
>          * mdio interface in board design, and need to be configured by
>          * fec0 mii_bus.
>          */
> -       if ((fep->quirks & FEC_QUIRK_ENET_MAC) && fep->dev_id > 0) {
> +       node = of_get_child_by_name(pdev->dev.of_node, "mdio");
> +       if (!node && fep->quirks & FEC_QUIRK_SINGLE_MDIO && fep->dev_id
> > 0) {
>                 /* fec1 uses fec0 mii_bus */
>                 if (mii_cnt && fec0_mii_bus) {
>                         fep->mii_bus = fec0_mii_bus; @@ -2001,7 +2002,6
> @@ static int fec_enet_mii_init(struct platform_device *pdev)
>         for (i = 0; i < PHY_MAX_ADDR; i++)
>                 fep->mii_bus->irq[i] = PHY_POLL;
> 
> -       node = of_get_child_by_name(pdev->dev.of_node, "mdio");
>         if (node) {
>                 err = of_mdiobus_register(fep->mii_bus, node);
>                 of_node_put(node);
> 
> 
> However, IMHO this would add a quirk to SoC's which actually are not
> affected... Hence I would prefer to not add that quirk on those SoC's and
> just break the (uncomplete) device tree's....
> 

I suggest using one patch to fix all SOCs and boards issue. Don't leave the issue for other boards.

i.MX serial with two MACs always have two MDIO bus, whether sharing MDIO bus only depend on boards design.
For example, i.MX6SX silicon, freescale reference boards use sharing MDIO bus, maybe customer's boards use independent MDIO bus (two MII bus).

There have four combination for i.MX28, i.MX6SX, Vybird, and the i.MX7....
1. MAC1 share MAC0 mii bus,  and no "phy_node" property and no "mdio" sub-node in dts. [legacy]
2. MAC1 share MAC0 mii bus,  and have "phy_node" property in both MAC node,  and only MAC0 node has "mdio" sub-node in dts.
3. MAC0 and MAC1 use independent MII bus,  and no "phy_node" property and no "mdio" sub-node in dts. [legacy]
4. MAC0 and MAC1 use independent MII bus,   and have "phy_node" property in both MAC node,  and only MAC0 node has "mdio" sub-node in dts.

For all these cases, your above patches cannot handle these.
So I still insist to add another property for this to avoid the existing dts files change.

Regards,
Andy
