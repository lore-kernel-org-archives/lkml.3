Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784Ab3LKPUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 10:20:25 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:50799 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab3LKPUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 10:20:23 -0500
Date: Wed, 11 Dec 2013 16:19:09 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Paul Walmsley <pwalmsley@nvidia.com>
Cc: Mikko Perttunen <mperttunen@nvidia.com>,
        Arto Merilainen <amerilainen@nvidia.com>,
        Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] gpu: host1x: clk_round_rate() can return a zero upon
 error
Message-ID: <20131211151908.GC31617@ulmo.nvidia.com>
References: <alpine.DEB.2.02.1312091746400.4127@tamien>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kfjH4zxOES6UT95V"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1312091746400.4127@tamien>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kfjH4zxOES6UT95V
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 09, 2013 at 06:00:12PM -0800, Paul Walmsley wrote:
>=20
> Treat both negative and zero return values from clk_round_rate() as
> errors.  This is needed since subsequent patches will convert
> clk_round_rate()'s return value to be an unsigned type, rather than a
> signed type, since some clock sources can generate rates higher than
> (2^31)-1 Hz.
>=20
> Eventually, when calling clk_round_rate(), only a return value of zero
> will be considered a error.  All other values will be considered valid
> rates.  The comparison against values less than 0 is kept to preserve
> the correct behavior in the meantime.
>=20
> Signed-off-by: Paul Walmsley <pwalmsley@nvidia.com>
> Cc: Mikko Perttunen <mperttunen@nvidia.com>
> Cc: Arto Merilainen <amerilainen@nvidia.com>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: Terje Bergstr=C3=B6m <tbergstrom@nvidia.com>
> ---
> Applies on v3.13-rc3.  See also:
>=20
> http://marc.info/?l=3Dlinux-arm-kernel&m=3D138542591313620&w=3D2
>=20
>  drivers/gpu/drm/tegra/hdmi.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/gpu/drm/tegra/hdmi.c b/drivers/gpu/drm/tegra/hdmi.c
> index 0cd9bc2056e8..8cf9d3aeb0cd 100644
> --- a/drivers/gpu/drm/tegra/hdmi.c
> +++ b/drivers/gpu/drm/tegra/hdmi.c
> @@ -959,7 +959,7 @@ static int tegra_output_hdmi_check_mode(struct tegra_=
output *output,
>  	parent =3D clk_get_parent(hdmi->clk_parent);
>=20
>  	err =3D clk_round_rate(parent, pclk * 4);
> -	if (err < 0)
> +	if (err <=3D 0)
>  		*status =3D MODE_NOCLOCK;
>  	else
>  		*status =3D MODE_OK;

Looks good. Out of curiosity, what are the plans on how to change the
clk_round_rate() API. I assume that at some point it will be modified
to return an unsigned long? At that point we'll need to update all
drivers as well to make sure the signed variables don't overflow.

Perhaps unsigned long long would be a better choice for future
compatibility?

Thierry

--kfjH4zxOES6UT95V
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSqIJsAAoJEN0jrNd/PrOhpNsQAJLU511q8MBG79GSUY/guo4x
12N5PBIZ1/r2AaMhongDGYMzgp8tjY00s1cQkFnM0U0SO8D0HU7Z/n5w8Y8iCS8k
FMWVe2zryy/anjSfTgNTCdN9LgaVOFiJZfrmnU5ld2dvDR4OCs8t7Ff0VY84oflr
o8KOhzxb9C4Qrv5cPNzOePtVh/kwncl7YA/4a7pNeBGBKs5v9mj3od5JwP6zEmk0
7XChM8UAPUM4AfB1025TVavRl1sAcvvMev+Q0T+D1aCef3ry73/GC19IQP2oUB8K
PWZu5e1+QBub4CBkLbYCzdHAa7/N0erR/BVkqB71mDpguwdMYjMBs6l/Hk2V0t/1
eqmrgC5uZQiknpK/CHA8fuHULZGa9QMF3d7ly1zC0oA5pwadbIhaPYVSY578sxZc
emBhAaJ8xqAK/5TpTHxjlZcYoVT9CQmkPlPyr+wZ6nJz/sgipYABRfTcSDU401eK
M6Z2gsB4pi2McUro8fvTV8Uz9rhdYWKHC8WHtFx5/IEaKAHVNvpq3T798Jhu29Bs
YYrxTqKVdDbutqHT1FsXPyxk2SpL877unoA3rT4A731sy7c3v+2LuA1OcIjbHjR8
+PnqsGmn0vc4yfZXMjUAml7I4sXHn46AFs30g3H8vvd6C41TVc5QoOWy1Hq+ae58
EB5CjlJ1OKUB+AgzADSk
=OXGm
-----END PGP SIGNATURE-----

--kfjH4zxOES6UT95V--
