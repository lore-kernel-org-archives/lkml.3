Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069Ab3HEUle (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 16:41:34 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50742 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754880Ab3HEUld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 16:41:33 -0400
Date: Mon, 5 Aug 2013 22:33:27 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>
Cc: Mike Turquette <mturquette@linaro.org>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: sun5i: dt: Use the A10s gates in the DTSI
Message-ID: <20130805203327.GY2911@lukather>
References: <1374618504-19391-1-git-send-email-maxime.ripard@free-electrons.com>
 <1374618504-19391-3-git-send-email-maxime.ripard@free-electrons.com>
 <51FBC4CE.8090009@elopez.com.ar>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2fowzm2eVyDiEwGH"
Content-Disposition: inline
In-Reply-To: <51FBC4CE.8090009@elopez.com.ar>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2fowzm2eVyDiEwGH
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Emilio,

On Fri, Aug 02, 2013 at 11:40:14AM -0300, Emilio L=F3pez wrote:
> El 23/07/13 19:28, Maxime Ripard escribi=F3:
> > The A10s has only a subset of the A10 gates. Now that the clock driver
> > has support for this gates set, switch to it in the DTSI.
> >=20
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>=20
> As I mentioned on the other patch, my board boots, so
>=20
> Tested-by: Emilio L=F3pez <emilio@elopez.com.ar>

Thanks.

> > ---
> >  arch/arm/boot/dts/sun5i-a10s.dtsi | 36 ++++++++++++++-----------------=
-----
> >  1 file changed, 14 insertions(+), 22 deletions(-)
> >=20
> > diff --git a/arch/arm/boot/dts/sun5i-a10s.dtsi b/arch/arm/boot/dts/sun5=
i-a10s.dtsi
> > index 0f0881a..b8fc1c2 100644
> > --- a/arch/arm/boot/dts/sun5i-a10s.dtsi
> > +++ b/arch/arm/boot/dts/sun5i-a10s.dtsi
> > @@ -95,20 +95,16 @@
> > =20
> >  		ahb_gates: ahb_gates@01c20060 {
> >  			#clock-cells =3D <1>;
> > -			compatible =3D "allwinner,sun4i-ahb-gates-clk";
> > +			compatible =3D "allwinner,sun5i-a10s-ahb-gates-clk";
> >  			reg =3D <0x01c20060 0x8>;
> >  			clocks =3D <&ahb>;
> > -			clock-output-names =3D "ahb_usb0", "ahb_ehci0",
> > -				"ahb_ohci0", "ahb_ehci1", "ahb_ohci1", "ahb_ss",
> > -				"ahb_dma", "ahb_bist", "ahb_mmc0", "ahb_mmc1",
> > -				"ahb_mmc2", "ahb_mmc3", "ahb_ms", "ahb_nand",
> > -				"ahb_sdram", "ahb_ace",	"ahb_emac", "ahb_ts",
> > -				"ahb_spi0", "ahb_spi1", "ahb_spi2", "ahb_spi3",
> > -				"ahb_pata", "ahb_sata", "ahb_gps", "ahb_ve",
> > -				"ahb_tvd", "ahb_tve0", "ahb_tve1", "ahb_lcd0",
> > -				"ahb_lcd1", "ahb_csi0", "ahb_csi1", "ahb_hdmi",
> > -				"ahb_de_be0", "ahb_de_be1", "ahb_de_fe0",
> > -				"ahb_de_fe1", "ahb_mp", "ahb_mali400";
> > +			clock-output-names =3D "ahb_usbotg", "ahb_ehci", "ahb_ohci",
> > +				"ahb_ss", "ahb_dma", "ahb_bist", "ahb_mmc0",
> > +				"ahb_mmc1", "ahb_mmc2",
>=20
> I noticed the vendor code also has "ahb_ms" here, it might be worth
> keeping it in mind.

What is this clock used for?

I couldn't find an IP in the user manual that could fit this MS
abbreviation.

>=20
> > "ahb_nand", "ahb_sdram",
> > +				"ahb_emac", "ahb_ts", "ahb_spi0", "ahb_spi1",
> > +				"ahb_spi2", "ahb_gps", "ahb_stimer", "ahb_ve",
> > +				"ahb_tve", "ahb_lcd", "ahb_csi", "ahb_hdmi",
> > +				"ahb_de_be", "ahb_de_fe", "ahb_iep", "ahb_mali400";
> >  		};
> > =20
> >  		apb0: apb0@01c20054 {
> > @@ -120,12 +116,11 @@
> > =20
> >  		apb0_gates: apb0_gates@01c20068 {
> >  			#clock-cells =3D <1>;
> > -			compatible =3D "allwinner,sun4i-apb0-gates-clk";
> > +			compatible =3D "allwinner,sun5i-a10s-apb0-gates-clk";
> >  			reg =3D <0x01c20068 0x4>;
> >  			clocks =3D <&apb0>;
> > -			clock-output-names =3D "apb0_codec", "apb0_spdif",
> > -				"apb0_ac97", "apb0_iis", "apb0_pio", "apb0_ir0",
> > -				"apb0_ir1", "apb0_keypad";
> > +			clock-output-names =3D "apb0_codec", "apb0_iis", "apb0_pio",
> > +				"apb0_ir", "apb0_keypad";
> >  		};
> > =20
> >  		/* dummy is pll62 */
> > @@ -145,15 +140,12 @@
> > =20
> >  		apb1_gates: apb1_gates@01c2006c {
> >  			#clock-cells =3D <1>;
> > -			compatible =3D "allwinner,sun4i-apb1-gates-clk";
> > +			compatible =3D "allwinner,sun5i-a10s-apb1-gates-clk";
> >  			reg =3D <0x01c2006c 0x4>;
> >  			clocks =3D <&apb1>;
> >  			clock-output-names =3D "apb1_i2c0", "apb1_i2c1",
> > -				"apb1_i2c2", "apb1_can", "apb1_scr",
> > -				"apb1_ps20", "apb1_ps21", "apb1_uart0",
> > -				"apb1_uart1", "apb1_uart2", "apb1_uart3",
> > -				"apb1_uart4", "apb1_uart5", "apb1_uart6",
> > -				"apb1_uart7";
> > +				"apb1_i2c2", "apb1_uart0", "apb1_uart1",
> > +				"apb1_uart2", "apb1_uart3";
> >  		};
> >  	};
> > =20
> >=20
>=20
> An update to the documentation mentioning these compatibles[1] and
> gates[2] would be great :)
>=20
> [1] Documentation/devicetree/bindings/clock/sunxi.txt
> [2] Documentation/devicetree/bindings/clock/sunxi/sun5i-a10s-gates.txt

Ah, right.

I'll send a v2 with the documentation. And I'll do the same for the A31
clock patches that also lacked this part.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--2fowzm2eVyDiEwGH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSAAwXAAoJEBx+YmzsjxAgS44P/RM8FcoeNn5smy61jBT3ubbh
XfVNtj3n3k+W4HtgUd/pgurmQHZIDyd+FD83P7PjkKBqdehjVwn9JGJEXgvkmCZH
N6q5dgtViLU3oeawHHdGFMkdXU9+L6yGbxWDOpJ7ZdEHCfft5AXCz8bZL2KoJJOg
JEJsiy3suMfc5UlG8iSXYZ8JhCpKQAFJNRkGVE9J7HNlwqYQHp874kAZxNTtAKuY
UU7iCGh4gRypVz2Uv7hs8BxF9T5sZiVw/etUWLjbZgm56l5xiDtTmNtrfqV6ggHG
KlH1vnWUr+F0rJcGYZIhvjdxwVTfeO0QSKDs1Tg2vj+PZRn1H4NRb4867v5ziALj
q4BzYo7D4mAPfR0vF26a+s4StpP1dFx36cKaMd2rwej9X4tQkRNfr8otkiAzB5iT
S7fiQGfc+HUvpbv4Q4oETD9zdajXfqknX9yZ/hiip+JWMqPi1ZPI7uEUXLvIzI9z
Sohbq967nVfyLh+esW0SDdRPDPn8eejKoRN5MTQU2/dDbbAv9Etk1xUSU+WSfvRM
s50GZ7ToP/yTyvUGAh5CZBBZwPFC6haTj1G5LdyY169cwfqzdDfqug8TK/6UykhY
ubZl75TzhdYOrGzh5V/E+uL65YrDqfmCuXnsZW+yuSgzRU7j3VSvMzhdC000qlto
ByA/vgsnwSoZSbDI/w1B
=cOzd
-----END PGP SIGNATURE-----

--2fowzm2eVyDiEwGH--
