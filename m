Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbaJLA1r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 20:27:47 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:54068 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbaJLA1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 20:27:46 -0400
Content-Type: multipart/signed; boundary="Apple-Mail=_12E0D558-5204-4E4C-BF73-638B38A767AF"; protocol="application/pgp-signature"; micalg=pgp-sha1
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH] char: hw_random: core.c:  Changed from using strncpy to strlcpy
From: Mark D Rustad <mrustad@gmail.com>
In-Reply-To: <1413067004-10925-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Sat, 11 Oct 2014 17:27:41 -0700
Cc: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        Torsten Duwe <duwe@lst.de>, "Theodore Ts'o" <tytso@mit.edu>,
        Jason Cooper <jason@lakedaemon.net>, Amit Shah <amit.shah@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Kees Cook <keescook@chromium.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Message-Id: <09FC08CC-027E-443A-83C3-CC4C1D978743@gmail.com>
References: <1413067004-10925-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail=_12E0D558-5204-4E4C-BF73-638B38A767AF
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Oct 11, 2014, at 3:36 PM, Rickard Strandqvist =
<rickard_strandqvist@spectrumdigital.se> wrote:

> Changed from using strncpy to strlcpy to simplify the code

Actually you changed from using strncat to strlcat.

> Signed-off-by: Rickard Strandqvist =
<rickard_strandqvist@spectrumdigital.se>
> ---
> drivers/char/hw_random/core.c |   12 ++++--------
> 1 file changed, 4 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/char/hw_random/core.c =
b/drivers/char/hw_random/core.c
> index aa30a25..1500cfd 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -281,7 +281,6 @@ static ssize_t hwrng_attr_available_show(struct =
device *dev,
> 					 char *buf)
> {
> 	int err;
> -	ssize_t ret =3D 0;
> 	struct hwrng *rng;
>=20
> 	err =3D mutex_lock_interruptible(&rng_mutex);
> @@ -289,16 +288,13 @@ static ssize_t hwrng_attr_available_show(struct =
device *dev,
> 		return -ERESTARTSYS;
> 	buf[0] =3D '\0';
> 	list_for_each_entry(rng, &rng_list, list) {
> -		strncat(buf, rng->name, PAGE_SIZE - ret - 1);
> -		ret +=3D strlen(rng->name);
> -		strncat(buf, " ", PAGE_SIZE - ret - 1);
> -		ret++;
> +		strlcat(buf, rng->name, PAGE_SIZE);
> +		strlcat(buf, " ", PAGE_SIZE);
> 	}
> -	strncat(buf, "\n", PAGE_SIZE - ret - 1);
> -	ret++;
> +	strlcat(buf, "\n", PAGE_SIZE);
> 	mutex_unlock(&rng_mutex);
>=20
> -	return ret;
> +	return strlen(buf);
> }
>=20
> static DEVICE_ATTR(rng_current, S_IRUGO | S_IWUSR,
> --=20
> 1.7.10.4

--=20
Mark Rustad, MRustad@gmail.com


--Apple-Mail=_12E0D558-5204-4E4C-BF73-638B38A767AF
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJUOcr9AAoJEDwO/+eO4+5uGVEP+wfLq5St2/Pd0v3wCRQABrOc
5BvcTbccmVr9mbSXnV4hQJ1PBfi/iFwPxtFZtsqvTG6vfm1BcAftSDqqGg0Efk8L
JJzG9yiR7s4XQLFXAbxYvQS+dcQG+5EM0knZ4QW4yoUZ0lYeOpjf4p4QUAkM0vEG
MA0boX7uO/L7dh4MwPDfIaaU25QYUKhmmTGZPBI0rBgoKCVEW9qCk97zT+M0bJPJ
s+93qo5l4iJM9hhbtdgs/JzPCKSQuTzgJeV+RBOqkJhKBasI+DC6NrqNT6WgXWOq
LqwGHfaAcotNBawenm0IZvQNgn1FPLIDqKTSGwp72RnMdbqetZnJ6nHBA5vWqoUz
gApKXrKnzmSM8q2v1FRqUTFIpwBJQMoa5TZcXTkozB8OpLq8gFPa02wmYUgAglbS
Km9VVDZdV2nR25gyVZCk95YoFTNI5wq+MZz+qwOrG6yxhjXW3peA6MzWc7FQNUsD
yFHPfxrXYbQGevNhGmKAZKvvMYeaWREx6mxaeV+dVPOJPPjuseEZk/F1nhbPoBBW
1LM2J0ca0r6q/y76ghWRS5yb+ZrDvKjtAe/DEX7JcILpzR8WVqJgH/ZOAPNMQ1Xh
OD55vYGx5IRsLrj8HRXizRvDWuss7OpHxvGnlhzc1Kf6v50mujsYZ673+o3yAX4k
/YxhkjuRuW7LvDE2eNXJ
=zxET
-----END PGP SIGNATURE-----

--Apple-Mail=_12E0D558-5204-4E4C-BF73-638B38A767AF--
