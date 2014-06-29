Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbaF2CU0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 22:20:26 -0400
Received: from ozlabs.org ([103.22.144.67]:48151 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbaF2CUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 22:20:25 -0400
Date: Sun, 29 Jun 2014 12:20:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        kbuild test robot <fengguang.wu@intel.com>, kbuild@01.org,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-crypto@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] DRBG: cleanup of preprocessor macros
Message-ID: <20140629122015.43f5178a@canb.auug.org.au>
In-Reply-To: <1949550.LXKdkPOvgm@myon.chronox.de>
References: <4927386.WYHrRe3NJm@myon.chronox.de>
	<1949550.LXKdkPOvgm@myon.chronox.de>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/r2RpfK=210Dsaq_b2OqAnop"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/r2RpfK=210Dsaq_b2OqAnop
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Stephan,

On Sat, 28 Jun 2014 22:00:07 +0200 Stephan Mueller <smueller@chronox.de> wr=
ote:
>
> diff --git a/crypto/drbg.c b/crypto/drbg.c
> index 6679a26..03a230e 100644
> --- a/crypto/drbg.c
> +++ b/crypto/drbg.c
> @@ -102,8 +102,13 @@
>  #if !defined(CONFIG_CRYPTO_DRBG_HASH) && \
>  	!defined(CONFIG_CRYPTO_DRBG_HMAC) && \
>  	!defined(CONFIG_CRYPTO_DRBG_CTR)
> -#warning "The DRBG code is useless without compiling at least one DRBG t=
ype"
> -#endif
> +#define CRYPTO_DRBG_NONE_STRING "none "
> +static int __init drbg_init(void)
> +{
> +	pr_warn("DRBG: no DRBG core was compiled!\n");
> +	return -EFAULT;
> +}
> +#else

Wouldn't this be better handled by Kconfig so that we don't even try to
build this unless one of the required core modules is chosen?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/r2RpfK=210Dsaq_b2OqAnop
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTr3flAAoJEMDTa8Ir7ZwVpUYQAIzvzGuLo5R4I5C8z5PWTB06
Gdu+7Tps16ZNFfZGDs6SGfLz14HcXeJ7oCoKzDbNEwzuKpKjEYIXF9Oy1Dn7YIp5
tONPZfxZx0RMloBwFTDaotJfjVEhVQ4VRT/LOH7nWNPSBVmzBsSInM9IyrP9AiTY
zLxzVO34OgYPK5s3zdB7GeIPMN28dhjKNVr827Wlh5jcsj4Nt4ULK08U5cTn3oTa
aX3ctijS8vWmDKGFv4FPaKc44lcSRR8k5O0qT2N/5DsCl66dDGiC2hEVacRGpui4
p/Webmkjelpnm4+6BHDgHWYcHs6NCFcJkUi8o4J7CPtJb5MjdbYV+HAz6rbNA1gL
LGCSwyoI29gdZkR2eIr3wWfmBlZEi9Z/UOSI7GLJ+UJd8Gq5XMG5I8zxnY02olhT
EeltG9nuhuqwZlhkZqh3G8zI2tH4dWEUpGS7iZ0qrcvZHROfXrqXVJHZM+yC5rmM
9Fhb8qS0h9BufEARyNbWEmhFfhi+xPJfNd5cX+1mpD7pDLD8Ey3nsO2O94HvwXTO
dclQ0oyUS4eh9CXWMLcW4Hvr57WtL8PHHadBrvY1XQHvKX19c5UCBMKf0IqRE4da
x954BzBCvqg7g4WkPq7Ud24SHytuMnK8wAgL7qBYFLIZGOPzkaMWEOxNM6VhBfLu
WU7XmuWQSooVReV/NNi4
=qp+F
-----END PGP SIGNATURE-----

--Sig_/r2RpfK=210Dsaq_b2OqAnop--
