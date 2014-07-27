Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbaG0E6b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 00:58:31 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:36305 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbaG0E63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 00:58:29 -0400
Content-Type: multipart/signed; boundary="Apple-Mail=_4732D5F5-DC11-4065-A311-AE00A326EAEE"; protocol="application/pgp-signature"; micalg=pgp-sha1
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH] crypto: ablkcipher.c:  Cleaning up missing null-terminate in conjunction with strncpy
From: Mark D Rustad <mrustad@gmail.com>
In-Reply-To: <1406383757-1753-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Sat, 26 Jul 2014 21:58:25 -0700
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <22C5E3AE-403A-48B7-86EC-F6E4AC42D4A5@gmail.com>
References: <1406383757-1753-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail=_4732D5F5-DC11-4065-A311-AE00A326EAEE
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Rickard,

On Jul 26, 2014, at 7:09 AM, Rickard Strandqvist =
<rickard_strandqvist@spectrumdigital.se> wrote:

> Replacing strncpy with strlcpy to avoid strings that lacks null =
terminate.
>=20
> Signed-off-by: Rickard Strandqvist =
<rickard_strandqvist@spectrumdigital.se>
> ---
> crypto/ablkcipher.c |    8 ++++----
> 1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
> index 40886c4..e446eef 100644
> --- a/crypto/ablkcipher.c
> +++ b/crypto/ablkcipher.c
> @@ -384,8 +384,8 @@ static int crypto_ablkcipher_report(struct sk_buff =
*skb, struct crypto_alg *alg)
> {
> 	struct crypto_report_blkcipher rblkcipher;
>=20
> -	strncpy(rblkcipher.type, "ablkcipher", sizeof(rblkcipher.type));
> -	strncpy(rblkcipher.geniv, alg->cra_ablkcipher.geniv ?: =
"<default>",
> +	strlcpy(rblkcipher.type, "ablkcipher", sizeof(rblkcipher.type));
> +	strlcpy(rblkcipher.geniv, alg->cra_ablkcipher.geniv ?: =
"<default>",
> 		sizeof(rblkcipher.geniv));
>=20
> 	rblkcipher.blocksize =3D alg->cra_blocksize;
> @@ -465,8 +465,8 @@ static int crypto_givcipher_report(struct sk_buff =
*skb, struct crypto_alg *alg)
> {
> 	struct crypto_report_blkcipher rblkcipher;
>=20
> -	strncpy(rblkcipher.type, "givcipher", sizeof(rblkcipher.type));
> -	strncpy(rblkcipher.geniv, alg->cra_ablkcipher.geniv ?: =
"<built-in>",
> +	strlcpy(rblkcipher.type, "givcipher", sizeof(rblkcipher.type));
> +	strlcpy(rblkcipher.geniv, alg->cra_ablkcipher.geniv ?: =
"<built-in>",
> 		sizeof(rblkcipher.geniv));
>=20
> 	rblkcipher.blocksize =3D alg->cra_blocksize;

It looks like all of these patches in the crypto area are introducing =
information leaks, including the one that first made me worry and =
respond. There were no bugs here (unless someone were to introduce a =
crypto method with a name longer than 63 characters), because stncpy =
fills the remainder of the destination with 0.

There are times when strncpy is the right function.

--=20
Mark Rustad, MRustad@gmail.com


--Apple-Mail=_4732D5F5-DC11-4065-A311-AE00A326EAEE
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJT1IbxAAoJEDwO/+eO4+5uRYUP/jP2w2A0HmbcKogSUXg0xZ1O
2B18qTxF+yvTelxPzyZ9fbn4ZCMNENl8x3cBthkx0ScROPZWi9lQTo4kCZECGu1j
C8FcDUbSC4Oop+2wApRaOX5qVRv4Ai9xKtQxIISEyzvsu+PlOAMzqIoXMPLee7B7
ICo4C13f1lzsU0aiP8EwcyHY5Z9kG4UqaBFDBqCqf9xBwppJGBa6p7rTLruIqeTl
mOyg5FpKHiReqPPjpDcmrVYXSbynU0nDJitPnL6c6Pvf45Y28qSD6IagHb5G2lOL
0yXLRrIHBvxU2uqSFMwvOEZsoQ0j4Z6a+ZoH4K9m+hRY7r+0r5jbZKvGRFaISPle
i0okhkdOz8z4KUz+6maOleJlMDk9jRFbc5Zwv2aPJ7ex1YaYg6QeUlhqedpeO/G4
wqi9YYwdYfEqkd8LNi0E63LCLaH374kG67MZxNfyuKabF1f5fO0rc3hrTcv/Nwri
lV0DHSl3Iqz397NHsF0jqaj+ULLVj4DczvTRaXuxT2hPljb67qe6KFrQX0Esv6vM
QDgvKDwdbW+GRIr0K3J/Hz40MLd0t/6r+q4Zhd9h7pqL5jIcM1jZAg6yhWY3nBii
SWcAioElP20iM/bqv43rfuuqQ4VNSLTnU/w8QgrC+YxR71HwvBGaPOFK8mt5X/zA
LWRWEe4WZMxNZMp6k4kP
=DZf5
-----END PGP SIGNATURE-----

--Apple-Mail=_4732D5F5-DC11-4065-A311-AE00A326EAEE--
