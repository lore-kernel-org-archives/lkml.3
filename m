Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966265AbaFTJkI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 05:40:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35794 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966096AbaFTJkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 05:40:04 -0400
Date: Fri, 20 Jun 2014 11:35:20 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Houcheng Lin <houcheng@gmail.com>
Cc: linus.walleij@linaro.org, gnurou@gmail.com, grant.likely@linaro.org,
        robh+dt@kernel.org, dbaryshkov@gmail.com, dwmw2@infradead.org,
        p.zabel@pengutronix.de, stephen.gallimore@st.com,
        srinivas.kandagatla@st.com, ulf.hansson@linaro.org, sre@kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH v3] reset: Add a defer reset object to send board
 specific reset
Message-ID: <20140620093520.GZ19730@lukather>
References: <1403098673-3058-1-git-send-email-houcheng@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lBP+FhBL9XXtPs84"
Content-Disposition: inline
In-Reply-To: <1403098673-3058-1-git-send-email-houcheng@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lBP+FhBL9XXtPs84
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 18, 2014 at 09:37:53PM +0800, Houcheng Lin wrote:
> The Problem
> -----------
> The reset signal on a hardware board is send either:
>     - during machine initialization
>     - during bus master's initialization
>=20
> In some hardware design, devices on bus need a non-standard and extra res=
et
> signal after bus is initialied. Most reason is to wake up device from han=
ging
> state.
>=20
> The board spefic reset code can not be put into machine init code, as it =
is
> too early. This code can not also be put onto chip's driver, as it is boa=
rd
> specific and not suitable for a common chip driver.

I don't see why not. I don't get the difference with an optional
regulator, or an optional GPIO, or whatever. And there's already some
support for such a case, with reset_control_get_optional.

>=20
> Defer Reset Object
> ------------------
> The defer reset object is to resolve this issue, developer can put a defe=
r-
> reset device on the board's dts file and enable DEFER RESET OBJECT CONFIG.
> During driver init-calls, a defer-reset object is created and issue reset=
 signal
> after the enclosing device is initialized.
>=20
> This eliminate the need to rewrite a driver module with only one purpose:=
 sending
> a board specific reset. This also allow mainstream kernel to support many=
 boards
> that modify the common drivers to send board specific reset. Configuring =
defer-reset
> device in dts leave the board specific reset rules on board level and sim=
ple to
> maintain.
>=20
> Example dts File
> ----------------
> Example 1:
>     defer_reset_vbus {
>         compatible =3D "defer-reset";
>         reset-gpios =3D <&gpx3 5 GPIO_ACTIVE_LOW>;

This doesn't follow the generic reset bindings.

>         duration =3D <5>;
>     };
>=20
> Example 2:
>     defer_reset_vbus {
>         compatible =3D "defer-reset";
>         reset-gpios =3D <&gpx3 5 GPIO_ACTIVE_HIGH>;
>         duration =3D <0>;
>     };
>=20
> Block Diagram of dts File
> -------------------------
>     +-------------------------------------+
>     | usb-ehci-chip@1211000               |
>     |   +-------------------------+       |
>     |   | defer-reset(gpx3)       |       |
>     |   +-------------------------+       |
>     +-------------------------------------+

And this goes against the current way of doing things, with the resets
property holding a phandle.

Why not just having something like:

usb {
    compatible =3D "whatever";
    resets =3D <&rst_gpio <duration>>;
}

Which uses the generic bindings, and doesn't require anything fancy
either in the driver or the DT.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--lBP+FhBL9XXtPs84
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTpABYAAoJEBx+YmzsjxAgkxwP/jplfibS2D69Nwqr6BTOo5Xi
IShKBbKEVz6PzH54yKWorvSoc478H9hMzYo5uHqBMyvkol3jXibGKsEk58/c6lli
9lbnBLzJ90uRZm/hRZ1XULmtezX8qsdxcaDd6DK2gw1KYUomKQwxdl6vDshJxXCh
7Wg5dU62ycq8oZhr84B00lxiY2iIXI2wEbHtbBQpqIehcnhqL5L4tJQ6gKeFVxLo
CuXImxFuRudN9E20ZWvq9HLGAYN+N1nO2x6+ljlHR1vGdrwkmaMAuclfjUrSLZPE
Vf3x6/LMZCkpFM7fkpK5REDGoAsFfDBfb4I2bqwanY/AE9/kRbmCsSlKCEWfiPCj
YptHk/ZqxX8fBg3lJxEqpj8exdfOHbPnx6MTsz7DxbYdoSOOfRiOb3f3ce3HLlIY
VIlkx4ZcUk+sj/jJidziAJy9Nf+gzTQW8vLTSBkYLqTNkd3Ne7fsnmVLxzxJ7UzN
f25lj1bOJW7FryDuDgYASGi9QccGoXRzdmQWV/w/NrSpyDDtEiJoWJWoVNzbxi74
uLVQp6kuiwdxFxcWGlO64dgOW0OmVbR6xpxJzBnZoiOYz/z5zkpOyheAG7Vl5XqQ
2URZ/wAJqeKcH9gEGc4Hyqilzzae9Qzvl5wLIXwMYqW7/WngUizHV68KJCA7kyIr
XYnreTo5IGk++Zo5VM1Q
=a8uA
-----END PGP SIGNATURE-----

--lBP+FhBL9XXtPs84--
