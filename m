Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab3HEJAh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 05:00:37 -0400
Received: from sauhun.de ([89.238.76.85]:58976 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754836Ab3HEJAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 05:00:36 -0400
Date: Mon, 5 Aug 2013 11:00:30 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: add sanity check to i2c_put_adapter
Message-ID: <20130805090030.GC2980@katana>
References: <1375359046-17472-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LwW0XdcUbUexiWVK"
Content-Disposition: inline
In-Reply-To: <1375359046-17472-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LwW0XdcUbUexiWVK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 01, 2013 at 02:10:46PM +0200, Sebastian Hesselbarth wrote:
> i2c_put_adapter dereferences i2c_adapter pointer passed without check
> for NULL. This adds a check for non-NULL pointer to allow i2c_put_adapter
> called with NULL and behave the same way i2c_release_client does already.

What about using WARN for the NULL case to point out the ref-counting
imbalance?

>=20
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Wolfram Sang <wsa@the-dreams.de>
> Cc: linux-i2c@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/i2c/i2c-core.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index f32ca29..d075df6 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -1825,7 +1825,8 @@ EXPORT_SYMBOL(i2c_get_adapter);
> =20
>  void i2c_put_adapter(struct i2c_adapter *adap)
>  {
> -	module_put(adap->owner);
> +	if (adap)
> +		module_put(adap->owner);
>  }
>  EXPORT_SYMBOL(i2c_put_adapter);
> =20
> --=20
> 1.7.10.4
>=20

--LwW0XdcUbUexiWVK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR/2muAAoJEBQN5MwUoCm2ExcQAIDORAhVfRYlRkt8MXRMXQjp
1p6eIyb6Bz+qp6g95kwqBr6I+DFaRiJhB4djUwiw75+sTTModn7OAsVuwAEZ6s+V
N8IsOGkqoOuFp8cRU0+JnzqvjHCkp4S5RQ3m2btu1+mdsbvxgG1WSIe0rykIUKGq
E9w6W9OLsVsUco4xp6IID0JKedmdrUMdgEOApKVOMNhmDIU9J98uO+7n6dDk8r02
X+IIxglodyOf+QTDBEUWoE9GulZOFPrSungzY3IwZxhASQgesV6RDP2S/s+mZEin
DY057uUkcBKN3ooX8tOxcuSE+P0mugVFpoJFxF9konMpsqdAxrxDeJZZKOBjiegY
RAxyca2pF7b+Pp3RJL2gufQJQl+LQ9cBLW964ph11qhKQTiwsSU+hOv2c7JKewJ0
OoMiOxChcfEhy+ePnG7APjqSVWgLsvgjBa7EkhSyHEd2r+4I3KqtYjESKjwzWDfS
nFu7y8wK5qifXcXzDyfsIzrovtjffRdVA4e8Ogo1wXBhevHpLP5p4YwwD3aLrz9w
HL4gZ7ImxJ+FZNPvji0fWiFk2616fgeRdzhhxO0d6fqdIADwydy7oPna+KBMfOc0
2a2C4gUaW94Ncq9AZXwxSs3/klOPkII+Ybfm+N0bA2AgMuza0r1rjQbGtyS2oDYF
L+uOuLFl4NFUa41Sf3gj
=0y9K
-----END PGP SIGNATURE-----

--LwW0XdcUbUexiWVK--
