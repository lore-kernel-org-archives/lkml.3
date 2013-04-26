Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546Ab3DZTtR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 15:49:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64394 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755677Ab3DZTtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 15:49:15 -0400
Date: Fri, 26 Apr 2013 21:49:08 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Bibek Basu <bbasu@nvidia.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linus.walleij@linaro.org,
        swarren@wwwdotorg.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: DT: tegra: pinctrl suspend resume hook
Message-ID: <20130426194908.GA3302@avionic-0098.mockup.avionic-design.de>
References: <1366740542-26127-1-git-send-email-bbasu@nvidia.com>
 <1366740542-26127-2-git-send-email-bbasu@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
In-Reply-To: <1366740542-26127-2-git-send-email-bbasu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:5OSf6eekV4oUBXPMK+6PAhRXWDCK8LwRKtLxH8mcYqp
 REUlHZOv62nNNsydkV4p8DCnPRUHaTuaQialLtqJfTjzqoIRo5
 qmgxoE+Oh7zkhmuU3oaRT6jQ/WU3eGG9NK9ix2UX3Q8zGnI9Es
 f75C4hsxBiVZbVjOi/b+5bf6QZ+EGUALVO0mBbame175kmZYRn
 0PlASKsYTEKbw8S1cpBu7rQ4l9GNyS33Iq/An4bN+HzB3iDn4v
 NMVPPxuOQpz/HhJMv6MisHDiOXLLhTwX5faHSTSDV+Yw0Yp+pW
 5rJcikQZjEs/WZinlLkRqnd3YsFQyZvAfyGLCN/5OvCvV1uqfQ
 Q7JWl0XOYnZIX+idXTs8VqLrB3SPWgXUkzGCRAwuekDOpCvZbf
 ljniisf2spRGLzBhwFkkQ3HvGdHIbdnuyr03XYy4+t74WvUjUK
 Q5cPh
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 23, 2013 at 11:39:02PM +0530, Bibek Basu wrote:
> Make pinmux as the first node of tegra DT
> so as to achieve pinctrl as last device to suspend and
> first device to resume.

I don't think this is a good idea. For one it encodes Linux specific
implementation details within the device tree. Furthermore I seem to
remember that the device tree makes no guarantees that the order of
nodes in the blob is the same as the order in the DTS.

That said I don't have a good alternative. Perhaps one solution would be
to use suspend_late() and resume_early() for the pinmux driver since
they will be called after and before the suspend() and resume()
callbacks of all other devices, respectively. Other than that I wasn't
able to find anything about forcing a particular order during suspend
and resume.

Cc'ing Rafael and the linux-pm mailing list, maybe somebody among them
knows a proper solution.

Thierry

>=20
> Signed-off-by: Bibek Basu <bbasu@nvidia.com>
> ---
>  arch/arm/boot/dts/tegra114.dtsi | 12 ++++++------
>  arch/arm/boot/dts/tegra20.dtsi  | 16 ++++++++--------
>  arch/arm/boot/dts/tegra30.dtsi  | 13 +++++++------
>  3 files changed, 21 insertions(+), 20 deletions(-)
>=20
> diff --git a/arch/arm/boot/dts/tegra114.dtsi b/arch/arm/boot/dts/tegra114=
=2Edtsi
> index a58a761..36596ae 100644
> --- a/arch/arm/boot/dts/tegra114.dtsi
> +++ b/arch/arm/boot/dts/tegra114.dtsi
> @@ -11,6 +11,12 @@
>  		serial3 =3D &uartd;
>  	};
> =20
> +	pinmux: pinmux {
> +		compatible =3D "nvidia,tegra114-pinmux";
> +		reg =3D <0x70000868 0x148		/* Pad control registers */
> +		       0x70003000 0x40c>;	/* Mux registers */
> +	};
> +
>  	host1x {
>  		compatible =3D "nvidia,tegra114-host1x", "simple-bus";
>  		reg =3D <0x50000000 0x00028000>;
> @@ -165,12 +171,6 @@
>  		interrupt-controller;
>  	};
> =20
> -	pinmux: pinmux {
> -		compatible =3D "nvidia,tegra114-pinmux";
> -		reg =3D <0x70000868 0x148		/* Pad control registers */
> -		       0x70003000 0x40c>;	/* Mux registers */
> -	};
> -
>  	/*
>  	 * There are two serial driver i.e. 8250 based simple serial
>  	 * driver and APB DMA based serial driver for higher baudrate
> diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.d=
tsi
> index a5a9615..6d8a663 100644
> --- a/arch/arm/boot/dts/tegra20.dtsi
> +++ b/arch/arm/boot/dts/tegra20.dtsi
> @@ -12,6 +12,14 @@
>  		serial4 =3D &uarte;
>  	};
> =20
> +	pinmux: pinmux {
> +		compatible =3D "nvidia,tegra20-pinmux";
> +		reg =3D <0x70000014 0x10   /* Tri-state registers */
> +		       0x70000080 0x20   /* Mux registers */
> +		       0x700000a0 0x14   /* Pull-up/down registers */
> +		       0x70000868 0xa8>; /* Pad control registers */
> +	};
> +
>  	host1x {
>  		compatible =3D "nvidia,tegra20-host1x", "simple-bus";
>  		reg =3D <0x50000000 0x00024000>;
> @@ -196,14 +204,6 @@
>  		interrupt-controller;
>  	};
> =20
> -	pinmux: pinmux {
> -		compatible =3D "nvidia,tegra20-pinmux";
> -		reg =3D <0x70000014 0x10   /* Tri-state registers */
> -		       0x70000080 0x20   /* Mux registers */
> -		       0x700000a0 0x14   /* Pull-up/down registers */
> -		       0x70000868 0xa8>; /* Pad control registers */
> -	};
> -
>  	das {
>  		compatible =3D "nvidia,tegra20-das";
>  		reg =3D <0x70000c00 0x80>;
> diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.d=
tsi
> index 9f33086..b4b79f0 100644
> --- a/arch/arm/boot/dts/tegra30.dtsi
> +++ b/arch/arm/boot/dts/tegra30.dtsi
> @@ -12,6 +12,13 @@
>  		serial4 =3D &uarte;
>  	};
> =20
> +	pinmux: pinmux {
> +		compatible =3D "nvidia,tegra30-pinmux";
> +		reg =3D <0x70000868 0xd4    /* Pad control registers */
> +		       0x70003000 0x3e4>; /* Mux registers */
> +	};
> +
> +
>  	host1x {
>  		compatible =3D "nvidia,tegra30-host1x", "simple-bus";
>  		reg =3D <0x50000000 0x00024000>;
> @@ -216,12 +223,6 @@
>  		interrupt-controller;
>  	};
> =20
> -	pinmux: pinmux {
> -		compatible =3D "nvidia,tegra30-pinmux";
> -		reg =3D <0x70000868 0xd4    /* Pad control registers */
> -		       0x70003000 0x3e4>; /* Mux registers */
> -	};
> -
>  	/*
>  	 * There are two serial driver i.e. 8250 based simple serial
>  	 * driver and APB DMA based serial driver for higher baudrate
> --=20
> 1.8.1.5
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
>=20

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJReto0AAoJEN0jrNd/PrOhHOIP/AoVaKHlXOEJSfUnzM7CLuE7
O/rqy9TVbyE8O5XE/D3UlYC7XXkY6sfbG/qbZBsBJeVDzhpVuL0NZ3ShMGBmcUqi
t6M9zZ+IIMgS+NMA3ycX0VS5secqdzrfTeJEsU+vWgDsAqbXBpUiS3JA9Knwnszw
S94GeeSBu+tdftTaVn9HioYyA5cK7b8JTcvRbmEYRw2p3yqMLClLQTeDxTxGFDVL
tCWKFPq9Rk38yC/Q6EoVw0nUJQPFzbKg2oXoXjb94D9LaLbY+TZVGrvBnJyQhVjz
gVNn603h14hy0PA0ITImgMqaY0qpOXwaSljjHDkfsoUazWXYiE6h50Ar/vySfW+X
GS+xwJvs0/Oh7/CaRpXKUK5oL9GZaxr1EDgOivncfQ4yySrhovZ2R+cbWgnKgSZH
8cSECEvLhl+I5tNlvCbgB1zosV+BqONv+4dxkfxjR8x8CaKauVbD5uqZ7SPirfca
IYy41x3nwbyYBmwYcO70DNFxfiNlhXCW9Iz9So87dBW0D+889OjKPGQuanBdsGlR
EM31tS9anj9oodtStjkJ3Upi8M0f8mFWBkmT5n64EATEh2jB5UA2w1+twJeLHQSj
2BJdfP3WN61R6nlwkyirNb43D9JJlJ1OocdTfd/vAOn9Tmyheifip4Y/X3qegx5H
20AZts0FszTUXU3sWy/9
=Jaed
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
