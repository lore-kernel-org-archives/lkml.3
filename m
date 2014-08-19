Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbaHSFVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 01:21:50 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:57014 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbaHSFVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 01:21:48 -0400
Date: Tue, 19 Aug 2014 07:21:45 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Mark Brown <broonie@kernel.org>, Thierry Reding <treding@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: Re: [PATCH] regmap: fix of_regmap_get_endian()
Message-ID: <20140819052141.GA12859@ulmo>
References: <1408400044-2560-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
In-Reply-To: <1408400044-2560-1-git-send-email-swarren@wwwdotorg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 18, 2014 at 04:14:04PM -0600, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
>=20
> Commit d647c199510c ("regmap: add DT endianness binding support") has
> some issues. Specifically, if config->reg_format_endian is not explicitly
> set, it will be zero, i.e. REGMAP_ENDIAN_DEFAULT. The switch statement
> that looks up the *endian from DT for the type=3D=3DREGMAP_ENDIAN_VAL case
> doesn't change *endian in the type=3D=3DREGMAP_ENDIAN_REG case. However, =
the
> test immediately following, compares *endian against REGMAP_ENDIAN_NATIVE,
> and if not equal, returns *endian as is. This ends up returning
> REGMAP_ENDIAN_DEFAULT, which the calling code does not expect, eventually
> leading to e.g.:
>=20
> Unable to handle kernel NULL pointer dereference at virtual address 00000=
024
> ...
> [<c02efd64>] (regcache_cache_only) from [<c0465fa8>] (tegra30_ahub_probe+=
0x1b8/0x430)
> [<c0465fa8>] (tegra30_ahub_probe) from [<c02e196c>] (platform_drv_probe+0=
x2c/0x5c)
> [<c02e196c>] (platform_drv_probe) from [<c02e0580>] (driver_probe_device+=
0x10c/0x22c)
> [<c02e0580>] (driver_probe_device) from [<c02e072c>] (__driver_attach+0x8=
c/0x90)
>=20
> This patch solves this by:
> * When looking up the endianness from DT, don't change *endian at all if
>   there is no DT property; leave it set to REGMAP_ENDIAN_DEFAULT so the
>   code falls through to other data sources in the same way as before.
>   Now, the "unspecified" case acts the same for both REGMAP_ENDIAN_REG and
>   REGMAP_ENDIAN_VAL.
> * After potentially looking up the endianness from DT, check *endian
>   against REGMAP_ENDIAN_DEFAULT instead of REGMAP_ENDIAN_NATIVE to avoid
>   returning unexpected values.
>=20
> Also, clean up the code a bit:
>=20
> * Make the comments briefer, and only refer to the specific action taken
>   at their location. This makes most of the comments independent of DT,
>   and easier to follow.
> * Restore the overall default of REGMAP_ENDIAN_BIG if none of the config,
>   DT, or the bus specify any endianness. Since all busses specify an
>   endianness now, this makes no difference, but I saw no justification in
>   the patch description for changing the default default.
> * s/of_regmap_get_endian/regmap_get_endian/ since the function isn't DT-
>   specific, even if the reason it was originally added was to add some
>   DT-specific features.
>=20
> Reported-by: Thierry Reding <treding@nvidia.com>
> Fixes: d647c199510c ("regmap: add DT endianness binding support")
> Cc: Xiubo Li <Li.Xiubo@freescale.com>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
>  drivers/base/regmap/regmap.c | 58 ++++++++++++++------------------------=
------
>  1 file changed, 18 insertions(+), 40 deletions(-)

Thanks for fixing this, Stephen.

Tested-by: Thierry Reding <treding@nvidia.com>

--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT8t7lAAoJEN0jrNd/PrOhbE0P/jk+va0N9v7HJoCODIxhI25h
KUaTtuEzCqwiwMyk+ivyBa84qdHhbnZW5IgEArF1ZPN4ATRHAcrIPz6DJgc68aRq
67TE7871Dhofs0V5Env76y1ek15Nz+PBjQyqYDwIgZmKexOvE9V4dy1xhH0e49Yj
RUaeVy4EFRlI7LjSqAThgYqqIuSRijlq4hJQ1I5EjKqDHLQwM4sw5cypg/ckltwf
MIM59Mcg/8BXQovihTnWrVwjNWdU53Q9NWtY0WBVI6bDD6+3MhiCcuN+5zF9mkqT
n+KYq0S/oHAqmMtWYPAM3c1lYVdRB7y9HfPV22L/2ZqELZCQHLpOV9YebBcrUULl
815aztwLb/I9sjTlUM7XHfTXFqWma7of+Mry5WH6V0wZTPKzbdoD2jOHLi2PaqMg
PJY5dP8hwuB+JYJwXGlL4DQZGsgGyASc7FSZTj1llRibU7dJjE2EkFt1qFZhtVYE
B2sGk2m0DFdSFhAVHX3uT5s25JTeo0LlFD5NPDpnJBbYr+6NkIb+lqFHgJIfwW6B
ovaLOoMliMVy4Xg9YZGf6O0tEkpsd57VPKPOWZTfiSUzqQOOcWeKyFVVUSjzbIIB
J12of5muKriH7snXfU9KINjhamzHQdNBH4iiPDVkNCE+SLdVT1Ka+NmA9PSFa3c5
hdqJGEx8RLNrc3opfJLi
=qHTc
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
