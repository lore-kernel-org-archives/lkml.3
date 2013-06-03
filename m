Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab3FCCsA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 22:48:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35980 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756433Ab3FCCrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 22:47:52 -0400
Date: Sun, 2 Jun 2013 19:47:47 -0700
From: Tyler Hicks <tyhicks@canonical.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: ecryptfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] eCryptfs: Cocci spatch "memdup.spatch"
Message-ID: <20130603024747.GA10466@boyd>
References: <1370079576.29224.7.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
In-Reply-To: <1370079576.29224.7.camel@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2013-06-01 11:39:36, Thomas Meyer wrote:
>=20
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---

Thanks Thomas - I've pushed this to my next branch.

Tyler

>=20
> diff -u -p a/fs/ecryptfs/messaging.c b/fs/ecryptfs/messaging.c
> --- a/fs/ecryptfs/messaging.c
> +++ b/fs/ecryptfs/messaging.c
> @@ -247,14 +247,13 @@ int ecryptfs_process_response(struct ecr
>  		goto unlock;
>  	}
>  	msg_size =3D (sizeof(*msg) + msg->data_len);
> -	msg_ctx->msg =3D kmalloc(msg_size, GFP_KERNEL);
> +	msg_ctx->msg =3D kmemdup(msg, msg_size, GFP_KERNEL);
>  	if (!msg_ctx->msg) {
>  		rc =3D -ENOMEM;
>  		printk(KERN_ERR "%s: Failed to allocate [%zd] bytes of "
>  		       "GFP_KERNEL memory\n", __func__, msg_size);
>  		goto unlock;
>  	}
> -	memcpy(msg_ctx->msg, msg, msg_size);
>  	msg_ctx->state =3D ECRYPTFS_MSG_CTX_STATE_DONE;
>  	wake_up_process(msg_ctx->task);
>  	rc =3D 0;
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe ecryptfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJRrAPSAAoJENaSAD2qAscKFZQP/1bAqqDLvoZuk0nCZWyYA0gt
NosS/kxp1l+svL2ZhK+oNQ46vPrFJybfXCSYbXJ9fXdqw9f6+6G84x62Yc0hvEjf
Bs7aUbRce1i08R+o1BeK/I7IMjexM80TNINcYNnGoM9qMvpeXqTUiCzOEvZKQH9z
18CaKa1frLTl4sS5btbMqBWcWJoxl8k3MsQ2RiHU+J7dzIC6UXqi/4OnMEAqOR9E
gWDVQ9f+AfHy93FawUmTQKPJoBkKKaw/1qxKwWbZVt7oiBssU1+q6RBXirinEfIP
YgZTxGedVMieec6ySvCBPh4AxEtUMBotwF4fwg1hYdKZFFbEEcsA09D6PVFusqMI
Bo/NovLGBeD5rTc7IXOIFhuQyPW8o5u8L8Ra/RPCzZrf8IdDUt8Z7WBqZgBwzwmH
CVvRICZQEJ7iXPDNqLTsWKLiyR/SpEcDa6AzRKmf19DrcfcYpStg+WRaCMMcoRam
InKyZhnFdY+DI1oscE6KhLMafEbc0yAaZJi489l2isi5ztRpjeDeDlIpmo8pvoam
4DRIHjcPjXLOQLJwCxhrV/qTCQcsxPX4t486Vd5XR4TQuYzLMWju0epzCd5x+g3e
Xjs7Sx9OP84FIkWjf0XRIf89a+RCvqctKSxAsAUm8iRM+tTsY5hfMEwkqwBOOukF
Qd7MzMa+QYN7u7MGf99z
=inyI
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
