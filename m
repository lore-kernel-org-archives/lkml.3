Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224AbaFSDF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 23:05:58 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53566 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756081AbaFSDF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 23:05:56 -0400
Date: Wed, 18 Jun 2014 22:05:20 -0500
From: Felipe Balbi <balbi@ti.com>
To: Nishanth Menon <nm@ti.com>
CC: <balbi@ti.com>, <devicetree@vger.kernel.org>, <linux@arm.linux.org.uk>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>, Rajendra Nayak <rnayak@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Darren Etheridge <detheridge@ti.com>, <r.sricharan@ti.com>,
        <robh+dt@kernel.org>, Josh Elliot <jelliott@ti.com>,
        <galak@codeaurora.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 2/2] arm: dts: add support for AM437x StarterKit
Message-ID: <20140619030520.GA13805@saruman.home>
Reply-To: <balbi@ti.com>
References: <1403106200-777-1-git-send-email-balbi@ti.com>
 <1403106200-777-3-git-send-email-balbi@ti.com>
 <53A1BADD.7050309@ti.com>
 <20140618193113.GC4570@saruman.home>
 <53A20A7D.3060508@ti.com>
 <20140618231923.GA9855@saruman.home>
 <53A24A39.4080100@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
In-Reply-To: <53A24A39.4080100@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jun 18, 2014 at 09:26:01PM -0500, Nishanth Menon wrote:
> On 06/18/2014 06:19 PM, Felipe Balbi wrote:
> [...]
> >>>>>Add support for TI's AM437x StarterKit Evaluation
> >>>>>Module.
> >>>>
> >>>>is there a link for this platform?
> >>>
> >>>internal only
> >>
> >>but will eventually be sold externally? I assume this is not an TI
> >
> >probably, but there's nothing public yet.
> >
> >>internal only board.
> >
> >correct assumption for all I know.
>=20
> Yikes.. ok.. I'd let Tony et.al make the call on this, I guess.

would we really block a DTS just because there's no public wiki page
available (yet) ?

Sounds a bit extreme to me.

> >>>>>+	edt-ft5306@38 {
> >>>>>+		status =3D "okay";
> >>>>>+		compatible =3D "edt,edt-ft5306", "edt,edt-ft5x06";
> >>>>>+		pinctrl-names =3D "default";
> >>>>>+		pinctrl-0 =3D <&edt_ft5306_ts_pins>;
> >>>>>+		reg =3D <0x38>;
> >>>>>+		interrupt-parent =3D <&gpio0>;
> >>>>>+		interrupts =3D <31 0>;
> >>>>>+
> >>>>>+		wake-gpios =3D <&gpio1 28 GPIO_ACTIVE_HIGH>;
> >>>>
> >>>>why wake-gpios? we should be using pinctrl with interrupt-extended to
> >>>>do wakeup sequence, no?
> >>>
> >>>sure, can you patch the edt driver ? I'll fix the DTS after that gets
> >>>merged
> >>
> >>If you really want to go down that road, so you could probably help
> >>review the pinctrl patches I posted to enable pinctrl wakeup[1]?
> >>
> >>Come on, as of today, there is no ability to suspend AM437x without
> >>doing [1], let alone talk about wakeup gpio vs interrupt-extended. and
> >>do we really want to wakeup from suspend when touch screen is touched?
> >>
> >>Do you expect wake-gpio to work even after doing interrupt based
> >>solution? I am no edt driver expert... maybe you can help me here.
> >
> >you missed the point entirely. This pin is not used for the touchscreen
> >to wake SoC up, it's the other way around, see how the pin is an
> >*output*. Pull it low and the touchscreen won't generate IRQs, won't
> >respond to i2c accesses, etc. Pull it high, and the thing wakes up.
>=20
> Aaah.. My apologies.. I was confused. Thanks for clarifying.

np

> [...]
> >>>>>+	cd-gpios =3D <&gpio0 6 GPIO_ACTIVE_HIGH>;
> >>>>>+};
> >>>>>+
> >>>>>+&usb2_phy1 {
> >>>>>+	status =3D "okay";
> >>>>>+};
> >>>>>+
> >>>>>+&usb1 {
> >>>>>+	dr_mode =3D "peripheral";
> >>>>>+	status =3D "okay";
> >>>>>+};
> >>>>>+
> >>>>>+&usb2_phy2 {
> >>>>>+	status =3D "okay";
> >>>>>+};
> >>>>>+
> >>>>>+&usb2 {
> >>>>>+	dr_mode =3D "host";
> >>>>>+	status =3D "okay";
> >>>>>+};
> >>>>none of the above need pinctrl? no regulator supplies?
> >>>
> >>>pins in default states, drivers don't use regulators.
> >>
> >>USB works without a supply? even a fixed voltage supply? that is
> >>weird.
> >
> >take a look at the minicom output I posted if you don't believe. Well,
> >to be exact, tps63010 [1] is the one which generates the regulated V5_0D
> >which is used as VBUS_USB. The enable pin in that device is tied to the
> >3v3 rail (dcdc4 regulator in the PMIC as most everything else) but
> >there's no way (otherwise) to control that thing. There's no control
> >bus, no way to write a driver.
> >
> >Since the board will anyways turn off if you disable the 3v3 rail, it's
> >pretty much pointless to figure out a hack just to add this to DTS.
> >
> >[1] http://www.ti.com/product/TPS63010
>=20
> I am sure to trust you on the test log :) ->  but then from dts descripti=
on
> perspective, it is good if we describe the supplies, even as a always on
> fixed-regulator. We had instances like 2430SDP ethernet where... umm... we
> originally missed describing ethernet supply and boom, one fine morning, =
no
> more nfs filesystem - I mean, it is a one off scenario there, but describ=
ing
> regulators helps us atleast understand the power tree of the board a litt=
le
> better.
>=20
> Again, no strong opinions on my side, it is a good thing to do is all
> I feel about it.

you mean something like:

	V5_0D: fixedregulator@0 {
		compatible =3D "regulator-fixed";
		regulator-name =3D "V5_0D";
		regulator-min-microvolt =3D <5000000>;
		regulator-max-microvolt =3D <5000000>;
		regulator-boot-on;
		regulator-always-on;
		vin-supply =3D <&dcdc4>;
	};

	VBUS_USB: fixedregulator@1 {
		compatible =3D "regulator-fixed";
		regulator-name =3D "VBUS_USB";
		regulator-min-microvolt =3D <5000000>;
		regulator-max-microvolt =3D <5000000>;
		regulator-boot-on;
		regulator-always-on;
		vin-supply =3D <&V5_0D>;
	};

I can add that, but note that it's *solely* to make sysfs look nice. And
if that's the case, most likely *every* DTS file in tree today as
incomplete. OTOH, I really consider this to be hugely unnecessary
because of the fact that board will turn off if 3v3 (dcdc4) is disabled.

--=20
balbi

--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTolNvAAoJEIaOsuA1yqREVG4P/1gK7gnUW7jimJzUc0fmGabk
e80I8zSYsAl+JoUARINpqeKSg/6X5Clg7pQttaIqUOxGfBL7L/LBL9UbUu34XJto
pK1feddh98mTEPlCDsMELV6W2OSg9mcksX0g0MmerHeUx/biRUQBPkJzCGXU91Z8
Td/wH/6in9hY47o+WJx9A2dCP+am/ibr9QsUsx7Rf5vFuWyMdZgM9PGtTjEjFnZN
POc1IMUzX61cMGV2ttq8cF3R3vYrS9qq2QPVPO6prBXI7QQYhcbwEMg1FggtB037
vK4H3ER9IoAvLg8DYppQs/aZ3HbwcCOUbDyu50VFpvf3rt0GRcn0wkhjq8gexu0J
ErootrLTJrBzqjMYDg263bIkUuWEv0m4QD4dwNq3S7s4Ob0OtYw04kUZMhzwQ9YI
reJU71ocQkXuvOoyaqwyQ6LByO+CfHEj9Eu4Vb2yElIuTyjMCjrJPR6mMRax+hwg
HdBBhIkJ5XsE0wtxeCxeFGCEhchdf2BjQpOPMGuViVdHMz6dHm67T8c1+0bdi0/2
afMHN85sAXwEnLx9KYeKhhRsZY45cgk5/qriH2LE0c1wKX7kCXJqC8cY40r/KGsV
pnPW+K3ZCaKyJCuXZnmZx9tgwVq7RDmeKnZLNqZVDvfBpbMf73D28nopfYDA2/Xk
MOVAzdSvbZ12DVdL897b
=nDt4
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
