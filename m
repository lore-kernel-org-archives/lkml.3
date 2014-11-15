Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbaKOBls (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 20:41:48 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:45308 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754812AbaKOBlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 20:41:46 -0500
Date: Fri, 14 Nov 2014 19:41:43 -0600
From: Felipe Balbi <balbi@ti.com>
To: George McCollister <george.mccollister@gmail.com>
CC: Felipe Balbi <balbi@ti.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        "open list:OMAP DEVICE TREE..." <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 2/2] ARM: dts: Add devicetree for NovaTech OrionLXm
Message-ID: <20141115014143.GA808@saruman>
Reply-To: <balbi@ti.com>
References: <1415832094-20991-1-git-send-email-george.mccollister@gmail.com>
 <1415832094-20991-2-git-send-email-george.mccollister@gmail.com>
 <20141113005908.GA27381@saruman>
 <CAFSKS=PvoibYvP8fauFT8J7t_pRDK56-ZbRvOovu=Q5mrw9wpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
In-Reply-To: <CAFSKS=PvoibYvP8fauFT8J7t_pRDK56-ZbRvOovu=Q5mrw9wpA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Nov 14, 2014 at 04:47:02PM -0600, George McCollister wrote:
> Felipe,
>=20
> Thank you for your reply.

no problem

> >> +     vbat: fixedregulator@0 {
> >> +             compatible =3D "regulator-fixed";
> >> +             regulator-name =3D "vbat";
> >> +             regulator-min-microvolt =3D <5000000>;
> >> +             regulator-max-microvolt =3D <5000000>;
> >> +             regulator-boot-on;
> >> +     };
> >
> > I suppose this is the 5V on a power jack, or something like that ?
>=20
> It comes with one of three different power supplies (24 - 250VDC, 120
> - 240VAC, 12VDC input) all of which ultimately supply a fixed 5V and
> 3.3V.

Alright :-) Thanks. Do you mind adding a comment on this DTS stating
that just so people don't get confused ?

> >
> >> +     vmmcsd_fixed: fixedregulator@0 {
> >> +             compatible =3D "regulator-fixed";
> >> +             regulator-name =3D "vmmcsd_fixed";
> >> +             regulator-min-microvolt =3D <3300000>;
> >> +             regulator-max-microvolt =3D <3300000>;
> >
> > but this... I know every other board devices this as a fixed regulator,
> > but is it really a fixed regulator or is supplied by one of the LDOs on
> > the PMIC ?
> >
>=20
> It's actually fixed (not from TP65910).

Oh, so this 3.3V fixed rail is the same one derived from from the three
possible power supplies you described above ?

> >> +&am33xx_pinmux {
> >> +     mmc1_pins: pinmux_mmc1_pins {
> >> +             pinctrl-single,pins =3D <
> >> +                     0xf0 (PIN_INPUT_PULLUP | MUX_MODE0)     /* mmc0_=
dat3 */
> >> +                     0xf4 (PIN_INPUT_PULLUP | MUX_MODE0)     /* mmc0_=
dat2 */
> >> +                     0xf8 (PIN_INPUT_PULLUP | MUX_MODE0)     /* mmc0_=
dat1 */
> >> +                     0xfc (PIN_INPUT_PULLUP | MUX_MODE0)     /* mmc0_=
dat0 */
> >> +                     0x100 (PIN_INPUT_PULLUP | MUX_MODE0)    /* mmc0_=
clk */
> >> +                     0x104 (PIN_INPUT_PULLUP | MUX_MODE0)    /* mmc0_=
cmd */
> >> +             >;
> >> +     };
> >> +
> >> +     i2c0_pins: pinmux_i2c0_pins {
> >> +             pinctrl-single,pins =3D <
> >> +                     0x188 (PIN_INPUT_PULLUP | MUX_MODE0)    /* i2c0_=
sda.i2c0_sda */
> >> +                     0x18c (PIN_INPUT_PULLUP | MUX_MODE0)    /* i2c0_=
scl.i2c0_scl */
> >> +             >;
> >> +     };
> >> +
> >> +     i2c2_pins: pinmux_i2c2_pins {
> >> +             pinctrl-single,pins =3D <
> >> +                     0x178 (PIN_INPUT_PULLUP | MUX_MODE3)    /* uart1=
_ctsn.i2c2_sda */
> >> +                     0x17c (PIN_INPUT_PULLUP | MUX_MODE3)    /* uart1=
_rtsn.i2c2_scl */
> >
> > on thing to keep in mind, if you already have external pullups, you
> > might not want to add internal pullups as you'd end up with both
> > resistors in parallel. For I2C the danger is minimal (unless you have a
> > ton of bus capacitance, then it changes high/low time), but it's best to
> > write a more "pristine" DTS. (and sure, I know pretty much every board
> > makes this mistake, but it's best if we don't proliferate the error)
>=20
> I'll make sure this is correct and include any required changes in the
> next version of the patch series.

cool, thanks

> >> +&i2c0 {
> >> +     pinctrl-names =3D "default";
> >> +     pinctrl-0 =3D <&i2c0_pins>;
> >> +
> >> +     status =3D "okay";
> >> +     clock-frequency =3D <400000>;
> >> +
> >> +     serial_config1: serial_config1@20 {
> >> +             compatible =3D "nxp,pca9539";
> >> +             reg =3D <0x20>;
> >> +     };
> >> +
> >> +     serial_config2: serial_config2@21 {
> >> +             compatible =3D "nxp,pca9539";
> >> +             reg =3D <0x21>;
> >> +     };
> >> +
> >> +     tps: tps@2d {
> >> +             reg =3D <0x2d>;
> >
> > which TPS device ? no compatible ?
> >
> >> +/include/ "tps65910.dtsi"
> >
> > oh... okay.
>=20
> I'm assuming that means you're okay with this (if not please elaborate
> on how to improve it).

sure, i'm okay. But it's still nice to add a compatible to that tps
node, then again, it's added to tps65910.dtsi so that would be a very
minor nit.

> >> +&tps {
> >> +     vcc1-supply =3D <&vbat>;
> >> +     vcc2-supply =3D <&vbat>;
> >> +     vcc3-supply =3D <&vbat>;
> >> +     vcc4-supply =3D <&vbat>;
> >> +     vcc5-supply =3D <&vbat>;
> >> +     vcc6-supply =3D <&vbat>;
> >> +     vcc7-supply =3D <&vbat>;
> >> +     vccio-supply =3D <&vbat>;
> >> +
> >> +     regulators {
> >> +             vrtc_reg: regulator@0 {
> >> +                     regulator-always-on;
> >
> > this should not be always on, you want to pass this as supply to the RTC
> > module so it can manage it. It's also best to give names to all
> > regulators, so people know what they're used for.
>=20
> I think we may actually be able to turn this one and possibly two
> others off, I will investigate.
>=20
> I've come up with names for all of the regulators being used and will
> include the changes in the next version of the patch series.

Thanks, that helps reviewing the validity of your DTS binding too.

> >> +             };
> >> +
> >> +             vio_reg: regulator@1 {
> >> +                     regulator-always-on;
> >> +             };
> >> +
> >> +             vdd1_reg: regulator@2 {
> >> +                     regulator-name =3D "vdd_mpu";
> >> +                     regulator-min-microvolt =3D <600000>;
> >> +                     regulator-max-microvolt =3D <1500000>;
> >> +                     regulator-boot-on;
> >> +                     regulator-always-on;
> >> +             };
> >> +
> >> +             vdd2_reg: regulator@3 {
> >> +                     regulator-always-on;
> >> +             };
> >> +
> >> +             vdd3_reg: regulator@4 {
> >> +                     regulator-always-on;
> >> +             };
> >> +
> >> +             vdig1_reg: regulator@5 {
> >> +                     regulator-always-on;
> >> +             };
> >> +
> >> +             vdig2_reg: regulator@6 {
> >> +                     regulator-always-on;
> >> +             };
> >> +
> >> +             vpll_reg: regulator@7 {
> >> +                     regulator-always-on;
> >> +             };
> >> +
> >> +             vdac_reg: regulator@8 {
> >> +                     regulator-always-on;
> >> +             };
> >> +
> >> +             vaux1_reg: regulator@9 {
> >> +                     regulator-always-on;
> >> +             };
> >> +
> >> +             vaux2_reg: regulator@10 {
> >> +                     regulator-always-on;
> >> +             };
> >> +
> >> +             vaux33_reg: regulator@11 {
> >
> > isn't this the supply to the other MMC slot ?
>=20
> no, it's actually being used for the USB PHY. As I said above I will
> name all regulators being used.

cool, thanks

> >> +                     regulator-always-on;
> >> +             };
> >> +
> >> +             vmmc_reg: regulator@12 {
> >> +                     regulator-min-microvolt =3D <3300000>;
> >> +                     regulator-max-microvolt =3D <3300000>;
> >> +                     regulator-always-on;
> >> +             };
> >> +     };
> >> +};
> >> +
> >> +&sham {
> >> +     status =3D "okay";
> >> +};
> >> +
> >> +&aes {
> >> +     status =3D "okay";
> >> +};
> >
> > just making sure, are you really using them ?
>=20
> We may need them at some point, I'd like to keep them enabled.

fair enough.

> >> +&mmc1 {
> >> +     pinctrl-names =3D "default";
> >> +     pinctrl-0 =3D <&mmc1_pins>;
> >> +     bus-width =3D <4>;
> >> +     status =3D "okay";
> >> +     vmmc-supply =3D <&vmmc_reg>;
> >> +     ti,vcc-aux-disable-is-sleep;
> >
> > this binding isn't documented anywhere. What was it supposed to do ?
>=20
> I mentioned in the commit message that there is a micro SD slot.

Sure, that's fine. My comment is regarding
"ti,vcc-aux-disable-is-sleep", it's not documentated or used anywhere
:-)

cheers

--=20
balbi

--wac7ysb48OaltWcw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUZq9XAAoJEIaOsuA1yqREnnMQAI3idGjupcexFHgZROV5v4BF
XHNeCQbdA5DC4/hr4oLUhNI89V4jEm3mcr3QpN+IOhFcAQV14sh+heOGWg/BdX8R
wBXWO6a+B16PMOq+nGKvc1QZs+Xy0Qq1uarl5WI/t/CstCyD1CevdW55rkh75mMJ
i/lYEwCGVeh4ltHtz9MkV3NKUKlGcHKWJ1tfBg+/BkXYiVP84Vj72zttRaPvA9Wu
qlNZsKu/Guy4q3iWHpTAeZbqPE3Vr7pQPE+FZ2IMdeNjt0vL2hyCZMmAvMdOQMfZ
ChyIHUKiqFngjOonXNh8r7ldzHs/Tl79gQUL1tTs7ANjJfRS6QNmTKuBnjI9heoB
S+D8pczXfPLhtbls7gA143crtBrtMwX5eCZPcQnOMX+RI+e38na5UVjpB2bSfrqf
92QwAiJURHczEAUyO5baiTp1tChUW9vJ4Qs3fCPxxG2EdyxVyo/VD996LsYSEiXg
gUZmGLo8Lb/A6Lx5gMOJE3fuzeaUw1bxIaEYHs8TOCTxgaGBV2xZ41MQD84IrP0F
55LrtfAkU5YANrLTsj63ltq2HW9VG0Facc53xRepVeAks88Y73A73TB3y4SciLu4
lP/XLlgKcKJdAp0TOWI/vaMoNoat44WwvfGU9IMSY9yilfER+PMbl7uX0XT/4N2y
SrC4dNHyHFRPYpi8Kgbg
=gFq8
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
