Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbaCNTur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 15:50:47 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57520 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754963AbaCNTub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 15:50:31 -0400
Date: Fri, 14 Mar 2014 14:48:25 -0500
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>, <balbi@ti.com>, <tony@atomide.com>,
        <george.cherian@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 7/8] ARM: dts: dra7: Add USB related nodes
Message-ID: <20140314194825.GA21808@saruman.home>
Reply-To: <balbi@ti.com>
References: <1394197751-28984-1-git-send-email-rogerq@ti.com>
 <1394197751-28984-8-git-send-email-rogerq@ti.com>
 <5322DC0E.1020600@ti.com>
 <5322F20C.50600@ti.com>
 <53231829.3060602@ti.com>
 <53232185.6090305@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
In-Reply-To: <53232185.6090305@ti.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 14, 2014 at 05:34:29PM +0200, Roger Quadros wrote:
> On 03/14/2014 04:54 PM, Kishon Vijay Abraham I wrote:
> >=20
> >=20
> > On Friday 14 March 2014 05:41 PM, Roger Quadros wrote:
> >> On 03/14/2014 12:38 PM, Kishon Vijay Abraham I wrote:
> >>> Hi Roger,
> >>>
> >>> On Friday 07 March 2014 06:39 PM, Roger Quadros wrote:
> >>>> Add nodes for the Super Speed USB controllers, omap-control-usb,
> >>>> USB2 PHY and USB3 PHY devices.
> >>>>
> >>>> Remove ocp2scp1 address space from hwmod data as it is
> >>>> now provided via device tree.
> >>>>
> >>>> Signed-off-by: Roger Quadros <rogerq@ti.com>
> >>>> ---
> >>>>    arch/arm/boot/dts/dra7.dtsi               | 110 +++++++++++++++++=
+++++++++++++
> >>>>    arch/arm/mach-omap2/omap_hwmod_7xx_data.c |  10 ---
> >>>>    2 files changed, 110 insertions(+), 10 deletions(-)
> >>>>
> >>>> diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dt=
si
> >>>> index 597979b..1e73900 100644
> >>>> --- a/arch/arm/boot/dts/dra7.dtsi
> >>>> +++ b/arch/arm/boot/dts/dra7.dtsi
> >>>> @@ -811,6 +811,116 @@
> >>>>                clocks =3D <&sata_ref_clk>;
> >>>>                ti,hwmods =3D "sata";
> >>>>            };
> >>>> +
> >>>> +        omap_control_usb2phy1: control-phy@4a002300 {
> >>>> +            compatible =3D "ti,control-phy-usb2";
> >>>> +            reg =3D <0x4a002300 0x4>;
> >>>> +            reg-names =3D "power";
> >>>> +        };
> >>>> +
> >>>> +        omap_control_usb3phy1: control-phy@4a002370 {
> >>>> +            compatible =3D "ti,control-phy-pipe3";
> >>>> +            reg =3D <0x4a002370 0x4>;
> >>>> +            reg-names =3D "power";
> >>>> +        };
> >>>> +
> >>>> +        omap_control_usb2phy2: control-phy@0x4a002e74 {
> >>>> +            compatible =3D "ti,control-phy-usb2-dra7";
> >>>> +            reg =3D <0x4a002e74 0x4>;
> >>>> +            reg-names =3D "power";
> >>>> +        };
> >>>> +
> >>>> +        /* OCP2SCP1 */
> >>>> +        ocp2scp@4a080000 {
> >>>> +            compatible =3D "ti,omap-ocp2scp";
> >>>> +            #address-cells =3D <1>;
> >>>> +            #size-cells =3D <1>;
> >>>> +            ranges;
> >>>> +            reg =3D <0x4a080000 0x20>;
> >>>> +            ti,hwmods =3D "ocp2scp1";
> >>>> +
> >>>> +            usb2_phy1: phy@4a084000 {
> >>>> +                compatible =3D "ti,omap-usb2";
> >>>> +                reg =3D <0x4a084000 0x400>;
> >>>> +                ctrl-module =3D <&omap_control_usb2phy1>;
> >>>> +                clocks =3D <&usb_phy1_always_on_clk32k>,
> >>>> +                     <&usb_otg_ss1_refclk960m>;
> >>>> +                clock-names =3D    "wkupclk",
> >>>> +                        "refclk";
> >>>> +                #phy-cells =3D <0>;
> >>>> +            };
> >>>> +
> >>>> +            usb2_phy2: phy@4a085000 {
> >>>> +                compatible =3D "ti,omap-usb2";
> >>>> +                reg =3D <0x4a085000 0x400>;
> >>>> +                ctrl-module =3D <&omap_control_usb2phy2>;
> >>>> +                clocks =3D <&usb_phy2_always_on_clk32k>,
> >>>> +                     <&usb_otg_ss2_refclk960m>;
> >>>> +                clock-names =3D    "wkupclk",
> >>>> +                        "refclk";
> >>>> +                #phy-cells =3D <0>;
> >>>> +            };
> >>>> +
> >>>> +            usb3_phy1: phy@4a084400 {
> >>>> +                compatible =3D "ti,omap-usb3";
> >>>> +                reg =3D <0x4a084400 0x80>,
> >>>> +                      <0x4a084800 0x64>,
> >>>> +                      <0x4a084c00 0x40>;
> >>>> +                reg-names =3D "phy_rx", "phy_tx", "pll_ctrl";
> >>>> +                ctrl-module =3D <&omap_control_usb3phy1>;
> >>>> +                clocks =3D <&usb_phy3_always_on_clk32k>,
> >>>> +                     <&sys_clkin1>,
> >>>> +                     <&usb_otg_ss1_refclk960m>,
> >>>> +                     <&dpll_core_h13x2_ck>;
> >>>> +                clock-names =3D    "wkupclk",
> >>>> +                        "sysclk",
> >>>> +                        "refclk",
> >>>> +                        "optclk";
> >>>
> >>> Do we use this 'optclk' in driver?
> >>
> >> No we don't. Still the device seems to work without it.
> >> This is supposed to be USB_LFPS_TX_GFCLK or USB3PHY_REF_CLK.
> >=20
> > I think it should be enabled. Did you check the status of this clock
> > in CM_L3INIT_CLKSTCTRL? Moreover USB_LFPS_TX_GFCLK is an interface
> > clock, so IIUC setting the module mode will enable it.
> >=20
> > Btw how did you tell dpll_core_h13x2_ck enables USB_LFPS_TX_GFCLK?
> >=20
>=20
> From the clock tree tool. It looks like the clock is gated
> automatically with the module mode as you suggested. I'll get rid of
> this clock reference then.

note that we can change the input clock of some parts of dwc3, maybe
that's why it works without, we're probably using another clock as
input.

--=20
balbi

--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTI10IAAoJEIaOsuA1yqREsB0P/Ro1DFR1pM02+qBmrvp5/Khh
7fz9ScTmjayUDWBMSR1aNQLjm2q/G4sGPgrfbMZZ7WVuyHTQJLKWhR/yJEw+6Ct7
7kIbHSFGNB/iegC649UYO/qgbjqgA+e4Y9WWsgt1T3REfzHke5M30NlID0VaLw/r
JM5pCOVblLWt+KM+hyEo3ydZFZsQ0szBOTcY1flCj41Kh/11PX7PQK1X10ryWBHD
zavhSwSTvjhnbQ7frIKvQ8GqbPpbFDMIakmB+NecWCpPqMc0DD1PNBTWT10F6lqO
fY+hamslS1/mk7FDmRpOMoT9EqAMs7KhcD+h+iTys5kEWo50QyNxVJM58vGNSnz0
pAAMl+5Y4LOyocEaE75/hs3JPnPSYXvZ8q0wMGtQ1E7MXwqWCHnNpyuagIX9mLaf
aQD/tIrW3BTlVnW/xahNNYZSJOGTHNcG4bTYXUO49tZ1OObBPbbDrYL9pAFdGBB/
ghFgMJzPjzTUV2/b03UfoimczA4N8XLXBUUY2bE+FIr3QYAfX4sg4rpQvfBZOwbB
x763Js7ng78tyriKRpS92w0CN0P0ZoqXkhI5wDAv20FBbGf9DbtMMgfnqqHJLX11
GG1DijpemBjHr01yfjuqRS935wt/hXJGlZhOgmYBTJZSOIBwVnsiK8SvA3ebeBOe
nquSNEHcC12BA3791Q/Q
=/Gt4
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
