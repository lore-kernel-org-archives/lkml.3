Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbbAYQKH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 11:10:07 -0500
Received: from down.free-electrons.com ([37.187.137.238]:58638 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751227AbbAYQKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 11:10:04 -0500
Date: Sun, 25 Jan 2015 17:06:25 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>, Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 6/9] ARM: dts: sunxi: Add usb3_vbus regulator to
 common regulators dtsi
Message-ID: <20150125160625.GH8470@lukather>
References: <1422188530-1794-1-git-send-email-wens@csie.org>
 <1422188530-1794-7-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2oox5VnwalALFvA7"
Content-Disposition: inline
In-Reply-To: <1422188530-1794-7-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2oox5VnwalALFvA7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 25, 2015 at 08:22:07PM +0800, Chen-Yu Tsai wrote:
> Some SoCs have a total of 4 possible USB controllers. One such example
> is the A80, which has one USB3 dual role device and 3 EHCI/OHCI pairs.
>=20
> Add a common VBUS regulator for the last host controller.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> ---
>  arch/arm/boot/dts/sunxi-common-regulators.dtsi | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/sunxi-common-regulators.dtsi b/arch/arm/bo=
ot/dts/sunxi-common-regulators.dtsi
> index e02baa66b33c..97fe8d73c4f7 100644
> --- a/arch/arm/boot/dts/sunxi-common-regulators.dtsi
> +++ b/arch/arm/boot/dts/sunxi-common-regulators.dtsi
> @@ -130,6 +130,16 @@
>  		status =3D "disabled";
>  	};
> =20
> +	reg_usb3_vbus: usb3-vbus {
> +		compatible =3D "regulator-fixed";
> +		pinctrl-names =3D "default";
> +		regulator-name =3D "usb3-vbus";
> +		regulator-min-microvolt =3D <5000000>;
> +		regulator-max-microvolt =3D <5000000>;
> +		enable-active-high;
> +		status =3D "disabled";
> +	};
> +

If the A80 is the only user so far, maybe that would make more sense
to have it in the A80 dtsi? Especially since this regulator doesn't
really do anything else than reg_vcc5v0.

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--2oox5VnwalALFvA7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUxRSBAAoJEBx+YmzsjxAgIhsP/3al6+9rvBl+KBN1vuxlFCQo
dH84folpyRVRxongNZM5gvnYWELlf8+Nup70BSSwJvGYvHGHLYk1uP8kiPLkJWku
vlnB/uliy0Taywf/H/hf8l+UajSBXwtmRIYY9QRB6y4xt3J5El85UpS7TxcJtljF
mqTo0p6PHX/4PPgf3RTDWYsOtY7jL9M9vycPUWXkZQNOSYD30au9I/2wfeFsQEZ/
yXFzUwFsgqBrEU75hXyfUKqo8RQn3rHiiw/FNZzEYzexHya4oCICeNDNAr7Et9WY
KJFNQ6w9860qq6lkv1W4w4/uMjloMwnSNSC/lHBdGKaJVLS0cMbfNqnR5Q4N18of
9v+2bJ2a3lNWyFY9+xDWI+996e3+Sk1mjC6Gzhv6jGj9XlJgXyknHCxzFzwatKHk
O6+g8K529V4W4O2wdDcHRgGmc9H3N3mEz4qxArFBNzjri6Tcz9DH6OuwP133LiqZ
MOFD4ytuMyhT/Y6JQbtqjKoRY8nJIR2scQ1atbmnqPY++TRtjhz3oMSRg8AtxYS6
l1rfIkLlRjNtUgJCtAd6Nigg6Vmjo6eUdgx+RH8Y+QgE0eXPy+egPC7LmXMp3PXp
oF/PZLcgrzBthCBIwhPjVxo7RWwMBV4Af7RSqikiiAPfx26XOJV/nAuQUZdi0HLH
Gp5JhU6MVCLvgkSi+UJr
=PrD2
-----END PGP SIGNATURE-----

--2oox5VnwalALFvA7--
