Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab3IWPVm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 11:21:42 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:64042 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab3IWPVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 11:21:41 -0400
Date: Mon, 23 Sep 2013 17:20:20 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH] regulator: core: Always use return value when
 regulator_dev_lookup() fails
Message-ID: <20130923151956.GA22941@ulmo>
References: <1379949283-5885-1-git-send-email-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
In-Reply-To: <1379949283-5885-1-git-send-email-broonie@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 23, 2013 at 04:14:43PM +0100, Mark Brown wrote:
> From: Mark Brown <broonie@linaro.org>
>=20
> Ensure that the return value is always set when we return now that the
> logic has changed for regulator_get_optional() so we don't get missing
> codes leaking out.
>=20
> Reported-by: Thierry Reding <treding@nvidia.com>
> Signed-off-by: Mark Brown <broonie@linaro.org>
> ---
>  drivers/regulator/core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index fabbf32..6333080 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -1281,12 +1281,13 @@ static struct regulator *_regulator_get(struct de=
vice *dev, const char *id,
>  	if (rdev)
>  		goto found;
> =20
> +	regulator =3D ERR_PTR(ret);
> +
>  	/*
>  	 * If we have return value from dev_lookup fail, we do not expect to
>  	 * succeed, so, quit with appropriate error value
>  	 */
>  	if (ret && ret !=3D -ENODEV) {
> -		regulator =3D ERR_PTR(ret);
>  		goto out;
>  	}

Perhaps remove the { and } now that there's only the "goto out;" left?

Tested-by: Thierry Reding <treding@nvidia.com>

--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSQFwcAAoJEN0jrNd/PrOhZzgQAJT2uHWhOkVKIKP0VGpPs5/B
AGp2pClQTZRGO8OFlqNqcvpZw02b03zVpGDSTx+AwSmUzhe5Gc/oArIjQciBEAWx
AhDZBmXU3Ip/LXi0jb5Fi4yUOONLfpRvHen3v5dHmHyLgk6FhpkKobrOy1G8K8+C
aVxbniXCQJY+23J1rqEi1LBN+unMJk7IZ1qokkKldj3nSPu5xh86JZbSoBPfsxPx
PHFu6TetCM9VRcWshXPPtgrVxiEuHe9plrQ17JrzWIt5FXqZYL2ifBmQxDsqSpvb
hmNS7jrh5eYJN/JGoBZp+SRir14p/q1hrnS9QT0zE0upAcZkKLk5wkbdZhw3x+fH
lEA5hekUXzxJSW1udwD4QGOJpR2KJUeRirPwXbsz/gL3vAYJrnhOsPVjiMWAFNcP
h27cJiNiyJ2FtppHJ9vwYu/BP+oqVLIkCsxRyuXDOP9koU/p8z3o3i6qWlk+bKxq
+RTv9QlQHuHQluc1/WYxpXSqRKdqYC+xifuH/6U3TrqmsefRHAL0WZ8dt5X12uwV
dZyizimv5TIwWx7C/QCW9ToUqbZHLoL+BI5ZTEVw7gIkL+tHwUt4UPO1GCgqjC4s
8Y7AsFDFiRN/TV0jSCYH3NmZrVo98RuDJG4JZFa9k1sP0gS3Pc5ZNIFUvj40quo3
0PBsHiz+t3f5gnjTKoGo
=uSn6
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
