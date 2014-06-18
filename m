Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450AbaFRXUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 19:20:00 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44885 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756353AbaFRXT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 19:19:57 -0400
Date: Wed, 18 Jun 2014 18:19:23 -0500
From: Felipe Balbi <balbi@ti.com>
To: Nishanth Menon <nm@ti.com>
CC: <balbi@ti.com>, <devicetree@vger.kernel.org>, <linux@arm.linux.org.uk>,
        Josh Elliot <jelliott@ti.com>, Tony Lindgren <tony@atomide.com>,
        Rajendra Nayak <rnayak@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Darren Etheridge <detheridge@ti.com>, <r.sricharan@ti.com>,
        <robh+dt@kernel.org>, Benoit Cousson <bcousson@baylibre.com>,
        <galak@codeaurora.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 2/2] arm: dts: add support for AM437x StarterKit
Message-ID: <20140618231923.GA9855@saruman.home>
Reply-To: <balbi@ti.com>
References: <1403106200-777-1-git-send-email-balbi@ti.com>
 <1403106200-777-3-git-send-email-balbi@ti.com>
 <53A1BADD.7050309@ti.com>
 <20140618193113.GC4570@saruman.home>
 <53A20A7D.3060508@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
In-Reply-To: <53A20A7D.3060508@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jun 18, 2014 at 04:54:05PM -0500, Nishanth Menon wrote:
> On 06/18/2014 02:31 PM, Felipe Balbi wrote:
> >On Wed, Jun 18, 2014 at 11:14:21AM -0500, Nishanth Menon wrote:
> >>On 06/18/2014 10:43 AM, Felipe Balbi wrote:
> >>>Add support for TI's AM437x StarterKit Evaluation
> >>>Module.
> >>
> >>is there a link for this platform?
> >
> >internal only
>=20
> but will eventually be sold externally? I assume this is not an TI

probably, but there's nothing public yet.

> internal only board.

correct assumption for all I know.

> [...]
> >>>+
> >>>+	matrix_keypad: matrix_keypad@0 {
> >>>+		compatible =3D "gpio-matrix-keypad";
> >>
> >>no pinctrl needed?
> >
> >pins are gpio by default
>=20
> Might be good to explicitly configure it - no strong opinions though
> -> GPIOs are always good to pinctrl up esp if bootloader screws up at
> a later date.

I find that very unlikely and don't quite like the idea of accessing
registers unnecessarily. OTOH, I don't quite care, to be frank.

> >>>+&i2c0 {
> >>>+        status =3D "okay";
> >>>+        pinctrl-names =3D "default";
> >>>+        pinctrl-0 =3D <&i2c0_pins>;
> >>
> >>what speed are you running this on? -> also can you align these to 1
> >
> >100kHz ?
>=20
> Rule of thumb is to do the following: MIN(MAX_FREQ(D1),
> MAX_FREQ(D2).... MAX_FREQ(Dn)); where D1..n are all the peripherals on
> this i2c bus.

hehe, right.

> >>>+		interrupt-controller;
> >>>+		#interrupt-cells =3D <2>;
> >>>+
> >>>+		dcdc1: regulator-dcdc1 {
> >>>+			compatible =3D "ti,tps65218-dcdc1";
> >>>+			/* VDD_CORE limits min of OPP50 and max of OPP100 */
> >>>+			regulator-name =3D "vdd_core";
> >>>+			regulator-min-microvolt =3D <912000>;
> >>>+			regulator-max-microvolt =3D <1144000>;
> >>>+			regulator-boot-on;
> >>>+			regulator-always-on;
> >>>+		};
> >>>+
> >>>+		dcdc2: regulator-dcdc2 {
> >>>+			compatible =3D "ti,tps65218-dcdc2";
> >>>+			/* VDD_MPU limits min of OPP50 and max of OPP_NITRO */
> >>>+			regulator-name =3D "vdd_mpu";
> >>>+			regulator-min-microvolt =3D <912000>;
> >>>+			regulator-max-microvolt =3D <1378000>;
> >>>+			regulator-boot-on;
> >>>+			regulator-always-on;
> >>>+		};
> >>>+
> >>>+		dcdc3: regulator-dcdc3 {
> >>>+			compatible =3D "ti,tps65218-dcdc3";
> >>>+			regulator-name =3D "vdds_ddr";
> >>no voltage ?
> >
> >has no users in kernel. Also, it comes out with default, and correct,
> >voltage.
>=20
> Device tree is description of hardware, not just who uses what in OS
> of interest.

then we should start "fixing" every single DTS in the kernel because I'm
sure even LEDs and keypads are tied to some sort of supply, as is the
case with this board. No driver will use it though.

Also, I couldn't find anywhere which voltage is dcdc3 outputing and
there's no shunt anywhere (other than a 0 ohm resistor) to measure
voltage. So I kinda have my hands tied here.

(goes review schematics)

actually there's 0.05 ohm sense resistor. Hopefully it's easy to access.

> you might consider u-boot to use the same device tree at a later date and
> having complete details about the hardware is always the norm.
>=20
> I suggest setting the voltage here to be complete even if there are no
> current users.
>=20
> >>>+	edt-ft5306@38 {
> >>>+		status =3D "okay";
> >>>+		compatible =3D "edt,edt-ft5306", "edt,edt-ft5x06";
> >>>+		pinctrl-names =3D "default";
> >>>+		pinctrl-0 =3D <&edt_ft5306_ts_pins>;
> >>>+		reg =3D <0x38>;
> >>>+		interrupt-parent =3D <&gpio0>;
> >>>+		interrupts =3D <31 0>;
> >>>+
> >>>+		wake-gpios =3D <&gpio1 28 GPIO_ACTIVE_HIGH>;
> >>
> >>why wake-gpios? we should be using pinctrl with interrupt-extended to
> >>do wakeup sequence, no?
> >
> >sure, can you patch the edt driver ? I'll fix the DTS after that gets
> >merged
>=20
> If you really want to go down that road, so you could probably help
> review the pinctrl patches I posted to enable pinctrl wakeup[1]?
>=20
> Come on, as of today, there is no ability to suspend AM437x without
> doing [1], let alone talk about wakeup gpio vs interrupt-extended. and
> do we really want to wakeup from suspend when touch screen is touched?
>=20
> Do you expect wake-gpio to work even after doing interrupt based
> solution? I am no edt driver expert... maybe you can help me here.

you missed the point entirely. This pin is not used for the touchscreen
to wake SoC up, it's the other way around, see how the pin is an
*output*. Pull it low and the touchscreen won't generate IRQs, won't
respond to i2c accesses, etc. Pull it high, and the thing wakes up.

> >>>+&mmc1 {
> >>>+	status =3D "okay";
> >>>+	vmmc-supply =3D <&dcdc4>;
> >>>+	bus-width =3D <4>;
> >>>+	pinctrl-names =3D "default";
> >>>+	pinctrl-0 =3D <&mmc1_pins>;
> >>
> >>just for style, wonder if moving the pinctrl just after status is bette=
r?
> >
> >why ? makes no difference.
>=20
> it does not - I agree, except, when you look at all other nodes:
> status=3D"okay"
> pinctrl
> other things..
>=20
> it is just a symmetry thing, I guess..

little bit of ocd, but sure.

> >>>+	cd-gpios =3D <&gpio0 6 GPIO_ACTIVE_HIGH>;
> >>>+};
> >>>+
> >>>+&usb2_phy1 {
> >>>+	status =3D "okay";
> >>>+};
> >>>+
> >>>+&usb1 {
> >>>+	dr_mode =3D "peripheral";
> >>>+	status =3D "okay";
> >>>+};
> >>>+
> >>>+&usb2_phy2 {
> >>>+	status =3D "okay";
> >>>+};
> >>>+
> >>>+&usb2 {
> >>>+	dr_mode =3D "host";
> >>>+	status =3D "okay";
> >>>+};
> >>none of the above need pinctrl? no regulator supplies?
> >
> >pins in default states, drivers don't use regulators.
>=20
> USB works without a supply? even a fixed voltage supply? that is
> weird.

take a look at the minicom output I posted if you don't believe. Well,
to be exact, tps63010 [1] is the one which generates the regulated V5_0D
which is used as VBUS_USB. The enable pin in that device is tied to the
3v3 rail (dcdc4 regulator in the PMIC as most everything else) but
there's no way (otherwise) to control that thing. There's no control
bus, no way to write a driver.

Since the board will anyways turn off if you disable the 3v3 rail, it's
pretty much pointless to figure out a hack just to add this to DTS.

[1] http://www.ti.com/product/TPS63010

--=20
balbi

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJToh57AAoJEIaOsuA1yqRE+LMP/jpd74wkm1V6wonBsbIH997y
MWhlmZPtB2WLLDwLnqNXimtcPaWGVw/T5RaW0SsANGIJ0VT+we4Nw6nWGZguYSTu
yi3y4TSNhLvl34/p5EkjRuv6uNAGVXt3yiaDY9/w77yojTVzlOmRMMDQa+eQJyGG
EGZVWdOhRtqoW+9fJ/xqr+5opMIZ0FaUL2k2+txYnUrXpSIiGxmoW8QGpCh1pKW3
KBufFcAn3bxT9xT+hBuOVpth5wGVIBlKUzLzUHVkT/a/dWGEPMmwXO5B7p95jT9d
q+leLZVcOoO7eT2lN9JbQgkHmDCqX4dHE7lsfq3ptT37/jtxL+8uJsbg9LL9N7ro
WYlpaC2VBcuS8uTnVAw8sPhCtlHf01tazxY2iJsNX6mLUdHbIEQ3/zok6ZmhbtCL
qoJWD0Dyfz2jmvcTcvJJmKdSzGXGP4ALxPLubM6hRSTywUBrqBmslA/DPe6AuuRs
rwO1AXJdt5IGld8tuHiaTbSB1R/0DFeySMefwPaeKf5NsWNGnNd/dYupbasUkKHD
GR0iFTSILl0stQR/ZWsN5E8c2RimnUkp2u1FYBBix1P/9PcSMTnXJeK6e8FulO73
9CzCK05lIpCREGOrmxNaQ0sHtYMkVIr6+Mfmd0VO5Tx2aJyru1nOnumRzJOu3VzH
9SftZTHQTWFsDbgyZFLk
=jEvi
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
