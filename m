Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab3H1M0H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 08:26:07 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:52941 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab3H1M0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 08:26:05 -0400
Date: Wed, 28 Aug 2013 14:25:30 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mikko Perttunen <mperttunen@nvidia.com>
Cc: tbergstrom@nvidia.com, dri-devel@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] ARM: tegra: Add host1x, dc and hdmi to Tegra114
 device tree
Message-ID: <20130828122529.GB32254@ulmo>
References: <1377686459-16634-1-git-send-email-mperttunen@nvidia.com>
 <1377686459-16634-5-git-send-email-mperttunen@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U+BazGySraz5kW0T"
Content-Disposition: inline
In-Reply-To: <1377686459-16634-5-git-send-email-mperttunen@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--U+BazGySraz5kW0T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 28, 2013 at 01:40:58PM +0300, Mikko Perttunen wrote:
> Add host1x, dc (display controller) and hdmi devices to Tegra114
> device tree.

"DC" and "HDMI".

>=20
> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
> ---
>  arch/arm/boot/dts/tegra114.dtsi | 43 +++++++++++++++++++++++++++++++++++=
++++++
>  1 file changed, 43 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/tegra114.dtsi b/arch/arm/boot/dts/tegra114=
=2Edtsi
> index 2905145..ce5a95c 100644
> --- a/arch/arm/boot/dts/tegra114.dtsi
> +++ b/arch/arm/boot/dts/tegra114.dtsi
> @@ -27,6 +27,49 @@
>  			(GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>;
>  	};
> =20
> +	host1x {
> +		compatible =3D "nvidia,tegra114-host1x", "nvidia,tegra30-host1x",

I don't think that's correct. The Tegra114 host1x is not backwards
compatible with the Tegra30 host1x.

That said, I have a local patch that is a bit more complete in that it
adds other host1x devices as listed in the TRM as well. But I'll leave
it up to Stephen how he prefers to handle that. It should be fine to
defer adding nodes for additional hardware blocks when the supporting
drivers are merged. We've done it for other devices as well.

> +				"simple-bus";
> +		reg =3D <0x50000000 0x00028000>;
> +		interrupts =3D <GIC_SPI 65 IRQ_TYPE_LEVEL_HIGH>,
> +				<GIC_SPI 67 IRQ_TYPE_LEVEL_HIGH>;

I think this should be indented with the previous line. Also other SoC
=2Edtsi files use a single entry, as in:

		interrupts =3D <GIC_SPI 65 IRQ_TYPE_LEVEL_HIGH
			      GIC_SPI 67 IRQ_TYPE_LEVEL_HIGH>;

> +		hdmi {
> +			compatible =3D "nvidia,tegra114-hdmi";
> +			reg =3D <0x54280000 0x00040000>;
> +			interrupts =3D <GIC_SPI 75 IRQ_TYPE_LEVEL_HIGH>;
> +			clocks =3D <&tegra_car TEGRA114_CLK_HDMI>,
> +				    <&tegra_car TEGRA114_CLK_PLL_D_OUT0>;

Any reason why we can't use pll_d2_out0 here, like we do on Tegra30?

Thierry

--U+BazGySraz5kW0T
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSHew5AAoJEN0jrNd/PrOhTkoP/3qwPfx8cVuCLWML6/208U5p
xIsqg/coh0yQyhj2ma6y+Tv74mDc5fXx+RATcY+Uf6ewRQ1uU74OpRguUHjd++hc
kMuIgtNePcKIdaEArE5ggIYtePf9RPeR47ykjFZutB78ERQldAe1Qhw6HMj1Te+p
ByOnQYNsEeo48n/0t68s54tZtJ3mw9wmPXRHjXtcdRK4DW11gAhLOOT0cUJ9py9K
WYdrOmcY++ZY8ycEaudo/1sH1FjiZxpjK4c+pRwE25tFIIrvW0aFhBP0hKt/wIgt
kja/g2CYRg+ky9z5xvEm2tDn3+S+mYIrCkhHvVTrMLzLRl7nn/WZIp0aOvnqkk6Z
OXjbZOkWqMXtgOjAXmDhQlNDsj4ZCf8L1OuEmqqsSmqo5+hyzdQmNxU1TQOzQSN5
lc3EZ/7hdgSYaqAQ6MtQXJaTxtbAZBGSWkF6uqmheDcrQmsXiSCEvuM2ntawz2+q
TIYWui2UvwT5YjcFcPOGncKnvL3X3Eia/2nqXmRl+pm0DlfZGNz2ngOcietUbIs7
VXA+8itMxKpVSptRTtnsYtrwk5n68oD2TRYZ6JkkJeuMXVNal6yOT/sftNNtN2Jp
mAS6jkWWXS6KTvNYBRIBzLXRJd6nk5eYIRDJrWwbzpIdpZaqrT/jpcqVJj62UJMY
TQjozjPuWMXZ1/PzoFfd
=aKAM
-----END PGP SIGNATURE-----

--U+BazGySraz5kW0T--
