Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965693AbaFRKAP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 06:00:15 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52095 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965200AbaFRKAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 06:00:14 -0400
Date: Wed, 18 Jun 2014 11:57:59 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Linus Walleij <linus.walleij@linaro.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Subject: Re: [PATCH v2 08/20] ARM: sun6i: DT: Rename PLL6 to PLL6x2 and add
 fixed-factor-clock for PLL6
Message-ID: <20140618095759.GL19730@lukather>
References: <1403016777-15121-1-git-send-email-wens@csie.org>
 <1403016777-15121-9-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pFej7zHSL6C5fFIz"
Content-Disposition: inline
In-Reply-To: <1403016777-15121-9-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pFej7zHSL6C5fFIz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 17, 2014 at 10:52:45PM +0800, Chen-Yu Tsai wrote:
> The PLL6 clock driver actually manages the PLL6x2 output of PLL6, so
> rename the node accordingly, and add a halved fixed-factor-clock for
> normal PLL6 output used by most modules.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> ---
>  arch/arm/boot/dts/sun6i-a31.dtsi | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/arm/boot/dts/sun6i-a31.dtsi b/arch/arm/boot/dts/sun6i-a=
31.dtsi
> index a9dfa12..12d558b 100644
> --- a/arch/arm/boot/dts/sun6i-a31.dtsi
> +++ b/arch/arm/boot/dts/sun6i-a31.dtsi
> @@ -94,11 +94,20 @@
>  			clock-output-names =3D "pll1";
>  		};
> =20
> -		pll6: clk@01c20028 {
> +		pll6x2: clk@01c20028 {
>  			#clock-cells =3D <0>;
>  			compatible =3D "allwinner,sun6i-a31-pll6-clk";
>  			reg =3D <0x01c20028 0x4>;
>  			clocks =3D <&osc24M>;
> +			clock-output-names =3D "pll6x2";
> +		};
> +
> +		pll6: pll6_clk {
> +			#clock-cells =3D <0>;
> +			compatible =3D "fixed-factor-clock";
> +			clock-div =3D <2>;
> +			clock-mult =3D <1>;
> +			clocks =3D <&pll6x2>;
>  			clock-output-names =3D "pll6";
>  		};

Hmm, nope. The output of PLL6 is 24M * N * K / 2, and this is what we
support in the driver.

This change is backward, and should be the other way around. Have PLL6
running at it's usual speed, and then have PLL62X be a fixed-factor.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--pFej7zHSL6C5fFIz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJToWKmAAoJEBx+YmzsjxAgkckP+wer6Qink/KWyr0pU+No7aAg
fLWZ4xU7VVMWcrUHgj7Iv2L2Yb8kPlhv24+YtlNsBG0RnTUijtYfRL6YT7T/EE/U
jRoq2oCPM+zFl4h1JQ5PAITIqMkCpHP5Oa1Vo5drFRZZc57I19ugKZxgZQe8rif6
Jrp1uhGZuZ4IpelSpgfCqnqdXiiuj73Unn1hl4x5Fxthq1LjOm6+rywai+9ex5Z1
CBrCRpEAfffV94ewAQsj2/Wa/APChkW1RLhnKxG7jFG0GMu/dscKy/p9ppEld3gb
+j2Q/V1j6o6KAJkKidWckC1ok/NHmzlTO8cDSYQGAZ3D+ZSiZnutODQluP63zCwr
ydYWJqnACiwZh6EkolAsf5zZlLhIf33nehdlSd24GDdYfeMLoTC0kY5VWIvIi3Uz
WsIPdlA81c6Zc244JC7Tww24fVygx7oVT0uDUhLMqKzApiNimA6RSAoQYfsTSbcH
9e66R+qlpndn4TJg5BSQS7ASSBEA4+VI4JJ/Mz6KZwgJ2MJF+CzXP1BfKhjWlZfJ
EAc+7aps+yqPVd+XR/3DXjdlUrjsjyZ1+jTK/F5gCpI2H19WM+xBwOFTD/1yIEER
frGvpvoHOR1ttzWeby/QTIao3H6SqOADDKZ8/lss784PMEfNFk+DKH50bST7DQmd
WKEDWrdNMDye25i5BV3z
=TEtl
-----END PGP SIGNATURE-----

--pFej7zHSL6C5fFIz--
