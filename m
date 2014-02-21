Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbaBUSzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 13:55:09 -0500
Received: from top.free-electrons.com ([176.31.233.9]:39329 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750882AbaBUSzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 13:55:06 -0500
Date: Fri, 21 Feb 2014 19:54:15 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: David =?iso-8859-1?Q?Lanzend=F6rfer?= 
	<david.lanzendoerfer@o2s.ch>,
        devicetree@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mike Turquette <mturquette@linaro.org>,
        Simon Baatz <gmbnomis@gmail.com>,
        Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        linux-mmc@vger.kernel.org, Chris Ball <chris@printf.net>,
        linux-kernel@vger.kernel.org,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        linux-sunxi@googlegroups.com, Tejun Heo <tj@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7 5/8] ARM: dts: sun7i: Add support for mmc
Message-ID: <20140221185415.GD3931@lukather>
References: <20140217095907.15040.81893.stgit@pagira.o2s.ch>
 <20140217100241.15040.24836.stgit@pagira.o2s.ch>
 <20140218142221.GJ3142@lukather>
 <530377EE.8010909@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WK3l2KTTmXPVedZ6"
Content-Disposition: inline
In-Reply-To: <530377EE.8010909@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WK3l2KTTmXPVedZ6
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 18, 2014 at 04:10:38PM +0100, Hans de Goede wrote:
> Hi,
>=20
> On 02/18/2014 03:22 PM, Maxime Ripard wrote:
> >On Mon, Feb 17, 2014 at 11:02:41AM +0100, David Lanzend=F6rfer wrote:
> >>Signed-off-by: David Lanzend=F6rfer <david.lanzendoerfer@o2s.ch>
> >>Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> >>---
> >>  arch/arm/boot/dts/sun7i-a20-cubieboard2.dts     |    8 +++
> >>  arch/arm/boot/dts/sun7i-a20-cubietruck.dts      |    8 +++
> >>  arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts |   23 +++++++++
> >>  arch/arm/boot/dts/sun7i-a20.dtsi                |   61 ++++++++++++++=
+++++++++
> >>  4 files changed, 100 insertions(+)
> >>
> >
> >I'd prefer to have three patches here:
> >    - One that add the controllers
> >    - One that add the pin muxing options
> >    - One that enable the controllers on the various boards.
> >
> >>diff --git a/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts b/arch/arm/boo=
t/dts/sun7i-a20-cubieboard2.dts
> >>index 5c51cb8..ae800b6 100644
> >>--- a/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts
> >>+++ b/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts
> >>@@ -34,6 +34,14 @@
> >>  			};
> >>  		};
> >>
> >>+		mmc0: mmc@01c0f000 {
> >>+			pinctrl-names =3D "default", "default";
> >>+			pinctrl-0 =3D <&mmc0_pins_a>;
> >>+			pinctrl-1 =3D <&mmc0_cd_pin_reference_design>;
> >
> >This can be made a single pinctrl group, you don't need the pinctrl-1
> >stuff, it only complicates the node.
>=20
> Then how do we deal with boards which use a different gpio for card-detec=
t ?
>=20
> In that case we don't want to change the mux setting of the reference
> design cd pin. IOW I believe that having 2 separate pinctrl settings for
> this is the rigt thing todo. I would prefer using just mmc0_cd_pin_a inst=
ead
> of _reference_design though.
>=20
> Oh wait, you're probably talking about using:
> 			pinctrl-0 =3D <&mmc0_pins_a>, <&mmc0_cd_pin_reference_design>;
>=20
> Yes that would be better.

Yep, exactly :)

> >
> >>+			cd-gpios =3D <&pio 7 1 0>; /* PH1 */
> >>+			status =3D "okay";
> >>+		};
> >>+
> >>  		pinctrl@01c20800 {
> >>  			led_pins_cubieboard2: led_pins@0 {
> >>  				allwinner,pins =3D "PH20", "PH21";
> >>diff --git a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts b/arch/arm/boot=
/dts/sun7i-a20-cubietruck.dts
> >>index f9dcb61..370cef84 100644
> >>--- a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
> >>+++ b/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
> >>@@ -19,6 +19,14 @@
> >>  	compatible =3D "cubietech,cubietruck", "allwinner,sun7i-a20";
> >>
> >>  	soc@01c00000 {
> >>+		mmc0: mmc@01c0f000 {
> >>+			pinctrl-names =3D "default", "default";
> >>+			pinctrl-0 =3D <&mmc0_pins_a>;
> >>+			pinctrl-1 =3D <&mmc0_cd_pin_reference_design>;
> >>+			cd-gpios =3D <&pio 7 1 0>; /* PH1 */
> >>+			status =3D "okay";
> >>+		};
> >>+
> >>  		pinctrl@01c20800 {
> >>  			led_pins_cubietruck: led_pins@0 {
> >>  				allwinner,pins =3D "PH7", "PH11", "PH20", "PH21";
> >>diff --git a/arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts b/arch/arm=
/boot/dts/sun7i-a20-olinuxino-micro.dts
> >>index ead3013..685ec06 100644
> >>--- a/arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts
> >>+++ b/arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts
> >>@@ -34,7 +34,30 @@
> >>  			};
> >>  		};
> >>
> >>+		mmc0: mmc@01c0f000 {
> >>+			pinctrl-names =3D "default", "default";
> >>+			pinctrl-0 =3D <&mmc0_pins_a>;
> >>+			pinctrl-1 =3D <&mmc0_cd_pin_reference_design>;
> >>+			cd-gpios =3D <&pio 7 1 0>; /* PH1 */
> >>+			status =3D "okay";
> >>+		};
> >>+
> >>+		mmc3: mmc@01c12000 {
> >>+			pinctrl-names =3D "default", "default";
> >>+			pinctrl-0 =3D <&mmc3_pins_a>;
> >>+			pinctrl-1 =3D <&mmc3_cd_pin_olinuxinom>;
> >>+			cd-gpios =3D <&pio 7 11 0>; /* PH11 */
> >>+			status =3D "okay";
> >>+		};
> >>+
> >>  		pinctrl@01c20800 {
> >>+			mmc3_cd_pin_olinuxinom: mmc3_cd_pin@0 {
> >>+				allwinner,pins =3D "PH11";
> >>+				allwinner,function =3D "gpio_in";
> >>+				allwinner,drive =3D <0>;
> >>+				allwinner,pull =3D <1>;
> >>+			};
> >>+
> >>  			led_pins_olinuxino: led_pins@0 {
> >>  				allwinner,pins =3D "PH2";
> >>  				allwinner,function =3D "gpio_out";
> >>diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i=
-a20.dtsi
> >>index 9ff0948..5b55414 100644
> >>--- a/arch/arm/boot/dts/sun7i-a20.dtsi
> >>+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
> >>@@ -355,6 +355,46 @@
> >>  			#size-cells =3D <0>;
> >>  		};
> >>
> >>+		mmc0: mmc@01c0f000 {
> >>+			compatible =3D "allwinner,sun5i-a13-mmc";
> >>+			reg =3D <0x01c0f000 0x1000>;
> >>+			clocks =3D <&ahb_gates 8>, <&mmc0_clk>;
> >>+			clock-names =3D "ahb", "mod";
> >>+			interrupts =3D <0 32 4>;
> >>+			bus-width =3D <4>;
> >
> >This belongs to the board, the controller itself is able to handle
> >several bus width.
>=20
> I believe that providing some form of default in the dtsi makes sense
> here and all boards we've seen sofar always use 4 bits, we can always
> override this from the dts file itself.

There's already a documented default that is 1. Plus, I still believe
in a strict separation between what's in the SoC being in the DTSI and
what's in the board being in the DTS.

Apart from being more rigorous, it also has the advantage of being
*much* clearer whenever your read a board DTS, since you don't have to
actually open several DTS(I) to get what's going on.

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--WK3l2KTTmXPVedZ6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTB6DXAAoJEBx+YmzsjxAgfDQP/jhODhoUVlFZOXmPYVObdRaG
GFI6ATasXh9yhO2rdl9ntehcOaLVkMFfaCh5fTQfJSgTqDxNQS9aSG0EBfxcCXZh
u0/b586N0DExZNdzmeKih3NokxyZQ3+Wek25IvD+979GNRVfqkAM5wkmx5zVEV4+
SVFvWuEwK/F4rLaR3jesleHvec64JGuYyrgrfJEzR/4phAWS/EgT1rTbGC4pE9Bp
arFyikiGhyEC2a99Lfu54PeenEhoUEVOnVhDK4ekL9egDk3mE7o+ZJLPoUeWi0/M
x6/OjhObSM61Fj2e1rUVc41q9riPItU7CZsKxNOBdqC+aJw4BXMbgoyUJYilpa3M
kLhSmnRYvBl70HPKqs+hMHWI/M6nPw3eK0hJ5SlWuV/OUr2XjXmYDeX58hNexY23
RJoJSeigAZVTdvf3i5tzibS0q0KUUJvhEb4cv/U3RrpBs1Y6IfzztkBpPyVMsp/7
fVj5EvwSRCBqq4V6y904jB6z378k4OX4EM4Tzjk0eiDn8TwDDRZnqWV/tBs1igG3
Kir/JvYKrEjLdN4ffkJwdDzKTpKZKzvTH5nUIs4L6UDpp5zn1FAjtq5LqyXRPfKT
awUKuCSHiIo6qDNeo/POL+OABlWK8NVA/rPeNue3msTnsE1JduNRfXmA0QyV1Jki
oQStcRDzVOTMUNi/3WsE
=cbK6
-----END PGP SIGNATURE-----

--WK3l2KTTmXPVedZ6--
