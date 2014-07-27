Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592AbaG0Cf0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 22:35:26 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:55614 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaG0CfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 22:35:25 -0400
Content-Type: multipart/signed; boundary="Apple-Mail=_713D8B29-4C80-44BD-BC84-E5FBF798FF3D"; protocol="application/pgp-signature"; micalg=pgp-sha1
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH] crypto: rng.c:  Cleaning up missing null-terminate in conjunction with strncpy
From: Mark D Rustad <mrustad@gmail.com>
In-Reply-To: <1406384308-2269-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Sat, 26 Jul 2014 19:35:22 -0700
Cc: Neil Horman <nhorman@tuxdriver.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <B1C69CE0-CA18-4853-B4EB-15B0D0F107E7@gmail.com>
References: <1406384308-2269-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail=_713D8B29-4C80-44BD-BC84-E5FBF798FF3D
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Rickard,

On Jul 26, 2014, at 7:18 AM, Rickard Strandqvist =
<rickard_strandqvist@spectrumdigital.se> wrote:

> Replacing strncpy with strlcpy to avoid strings that lacks null =
terminate.
>=20
> Signed-off-by: Rickard Strandqvist =
<rickard_strandqvist@spectrumdigital.se>
> ---
> crypto/rng.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/crypto/rng.c b/crypto/rng.c
> index e0a25c2..c3d4fb3 100644
> --- a/crypto/rng.c
> +++ b/crypto/rng.c
> @@ -65,7 +65,7 @@ static int crypto_rng_report(struct sk_buff *skb, =
struct crypto_alg *alg)
> {
> 	struct crypto_report_rng rrng;
>=20
> -	strncpy(rrng.type, "rng", sizeof(rrng.type));
> +	strlcpy(rrng.type, "rng", sizeof(rrng.type));
>=20
> 	rrng.seedsize =3D alg->cra_rng.seedsize;

Not to pick on this patch in particular, but you need to be careful =
about changing strncpy to strlcpy. Although strlcpy ensures termination, =
it does not prevent information leakage - strncpy ensures that the =
entire destination buffer is written. When leakage is a concern, it is =
better to use strncpy and then to store a zero in the last location of =
the buffer to ensure termination.

These "simple" transformations can be risky - and many of these do not =
represent any sort of problem when the source is smaller than the =
destination. I hope information leakage is being considered.

--=20
Mark Rustad, MRustad@gmail.com


--Apple-Mail=_713D8B29-4C80-44BD-BC84-E5FBF798FF3D
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJT1GVqAAoJEDwO/+eO4+5urRYQALOCuZdPLRuvOZyVkEkzqLOE
/IxV048SqzYO71GSnyD0WlVkrNZ3z9SzeuaTJOjRr4Z5jeWK29c2GlEzfE2JUtt1
goQYbvRBU3aQ/tCT460Y3XRDwiiXhsQoyIemOcoXz1IsvKidffMvYIjGamBdWeKY
znjC1Ipw/jXeWHjSvnQdPh2hLA656XLrwX2vKLWsOhALPneTAGWzn4MjyposMsjc
u245P8z1SY92RbwQi+PktG9/VaA2fMsfIaHj99hXoigx+sNE6EmzoISUsnNp1F1W
wq0ZSrC9c+XDqxL7ivsHDtBq4u8ciCQKeTUuU85CuaCUoI/vSVKvUaEfVaesU/lL
rmhd40NJLQHn3WqLcTy2PlqfKClA0QFhhKB1y7CoW7FdJ4mk3XaAc6PIyrtVsesq
NKJMeeBdTQxczfvGPZUUtYsjXPf8qvkBMWJxgVnyKaCSVAxp0tVlpag4egd9t4ZT
3ZswTenZ0/yRTIDcr/05KZiMAPwyKz/aMOzwFkWSpBIJIVwBe8mxBpKxjtZW3dYX
AOwxDHSaWC2wqxaeX6RWryu47GH6mV6Xf+QMss7A2+1mV/RpfT7bMeYHZ+3VteCl
JKdWTslEaYnntKaKGf3iQ9302shmntgRKYqmwPYmhKZeNVEzSRvn/8TL9Z0Gaey3
5Z91eQjdsvxOV2YQkxNs
=WCx+
-----END PGP SIGNATURE-----

--Apple-Mail=_713D8B29-4C80-44BD-BC84-E5FBF798FF3D--
