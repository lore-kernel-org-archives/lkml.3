Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbaK1IkG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 03:40:06 -0500
Received: from down.free-electrons.com ([37.187.137.238]:38055 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750985AbaK1IkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 03:40:04 -0500
Date: Fri, 28 Nov 2014 09:37:06 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>
Subject: Re: linux-next: manual merge of the sunxi tree with the arm-soc tree
Message-ID: <20141128083706.GT25249@lukather>
References: <20141128103617.13a1821c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0WGqsT62A4RTsSXf"
Content-Disposition: inline
In-Reply-To: <20141128103617.13a1821c@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0WGqsT62A4RTsSXf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Nov 28, 2014 at 10:36:17AM +1100, Stephen Rothwell wrote:
> Hi Maxime,
>=20
> Today's linux-next merge of the sunxi tree got a conflict in
> arch/arm/boot/dts/sun6i-a31.dtsi between commit 3fd0c05da46c ("Revert
> "ARM: dts: sunxi: Use sun4i-a10-apb1-clk for sun6i/sun8i apb2
> clocks."") from the arm-soc tree and commit 74c947ab33c9 ("ARM: dts:
> sunxi: Use sun4i-a10-apb1-clk for sun6i/sun8i apb2 clocks") from the
> sunxi tree.
>=20
> I fixed it up (I just used the arm-soc version for now) and can carry
> the fix as necessary (no action is required).
>=20
> --=20
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>=20
> diff --cc arch/arm/boot/dts/sun6i-a31.dtsi
> index 529c73803976,f47156b6572b..000000000000
> --- a/arch/arm/boot/dts/sun6i-a31.dtsi
> +++ b/arch/arm/boot/dts/sun6i-a31.dtsi
> @@@ -217,19 -229,11 +229,19 @@@
>   					"apb1_daudio1";
>   		};
>  =20
>  -		apb2: clk@01c20058 {
>  +		apb2_mux: apb2_mux@01c20058 {
>  +			#clock-cells =3D <0>;
>  +			compatible =3D "allwinner,sun4i-a10-apb1-mux-clk";
>  +			reg =3D <0x01c20058 0x4>;
>  +			clocks =3D <&osc32k>, <&osc24M>, <&pll6 0>, <&pll6 0>;
>  +			clock-output-names =3D "apb2_mux";
>  +		};
>  +
>  +		apb2: apb2@01c20058 {
>   			#clock-cells =3D <0>;
> - 			compatible =3D "allwinner,sun6i-a31-apb2-div-clk";
> + 			compatible =3D "allwinner,sun4i-a10-apb1-clk";
>   			reg =3D <0x01c20058 0x4>;
> - 			clocks =3D <&apb2_mux>;
> + 			clocks =3D <&osc32k>, <&osc24M>, <&pll6 0>, <&pll6 0>;
>   			clock-output-names =3D "apb2";
>   		};
>  =20

I'm not exactly sure why there is still conflicts between my branches
and arm-soc, since the previous branch that generates these conflicts
was supposed to be dropped, but the correct fix is:

		apb2: clk@01c20058 {
			#clock-cells =3D <0>;
			compatible =3D "allwinner,sun4i-a10-apb1-clk";
			reg =3D <0x01c20058 0x4>;
			clocks =3D <&osc32k>, <&osc24M>, <&pll6 0>, <&pll6 0>;
			clock-output-names =3D "apb2";
		};

with the apb2_mux node dropped entirely.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--0WGqsT62A4RTsSXf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUeDQyAAoJEBx+YmzsjxAgA9EQAL3wd58qbe08NZaZT8xhq7lX
gwDIDEM0n4buH/cVOAdsrWGmvn8ZdNDeSS7K+n0SMpghiV0DLfuEKhTkmt+tRUpZ
tTIc+jF+c5onS23RpxCTF7YYfucXSUMzxZ1oRa8WlaRQR60TENiX6DI6z20LjgxK
q3/apUscyyl72ncBPRfH89UYHv3d4+RCSLTLVYvbGXaeA+5cA6/RrFKzF0DIjyGd
5Tdn5W/ZrbhKvNqMVzxP7MBPuxOAdqNFTUuy+lPIudobIR8Mi1BHhocA46LD+h3a
hhCddDZl3glLWjSofeubnuTIroOZER8QOXrIiK5kcJDspUFaoX2+GyDYJwhlI4wl
Bml23UVGaf5lWI7MRXlWhQiWkiY90FptlxGWn8Hm9+0SCLnh/C0eGM9CltSE+rvd
5N8sxHnDFjZVpGFbjwQmXFBccXAj4Wp82+Z+2XiC3fkwgb1ptJYiNS+VBZpm6nEy
AtI1de8e59rX85TLqLUr5I+ZgPHFraqL1RIkGv9rLyXaixjkaR8N4XkfZ8jOQV1R
7FZOig4RuZvgGog8qh4ohLOFQcVxWUbBEKN7pPi4Ii+fxckb8XtodV0SJzaSTyQq
7yETbfxLvo2VKNgIXCansc/8eDjk5tSbdgpu5baHHukDAw6xoxQF/3QigaImf9+W
8P43wylwxFmMDRrCcH8N
=xTCB
-----END PGP SIGNATURE-----

--0WGqsT62A4RTsSXf--
