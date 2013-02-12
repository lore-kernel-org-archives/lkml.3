Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933679Ab3BLSND (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 13:13:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50773 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933109Ab3BLSNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 13:13:01 -0500
Date: Tue, 12 Feb 2013 10:12:56 -0800
From: Tyler Hicks <tyhicks@canonical.com>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-kernel@vger.kernel.org,
        Dustin Kirkland <dustin.kirkland@gazzang.com>,
        ecryptfs@vger.kernel.org
Subject: Re: [PATCH linux-next] ecryptfs: ecryptfs_msg_ctx_alloc_to_free():
 remove kfree() redundant null check
Message-ID: <20130212181256.GB7728@boyd>
References: <1360692229-60655-1-git-send-email-tim.gardner@canonical.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="BwCQnh7xodEAoBMC"
Content-Disposition: inline
In-Reply-To: <1360692229-60655-1-git-send-email-tim.gardner@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BwCQnh7xodEAoBMC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2013-02-12 11:03:49, Tim Gardner wrote:
> smatch analysis:
>=20
> fs/ecryptfs/messaging.c:101 ecryptfs_msg_ctx_alloc_to_free() info:
>  redundant null check on msg_ctx->msg calling kfree()
>=20
> Cc: Tyler Hicks <tyhicks@canonical.com>
> Cc: Dustin Kirkland <dustin.kirkland@gazzang.com>
> Cc: ecryptfs@vger.kernel.org
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>

Thanks, Tim. Pushed to the next branch at
git://git.kernel.org/pub/scm/linux/kernel/git/tyhicks/ecryptfs.git

Tyler

> ---
>  fs/ecryptfs/messaging.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/fs/ecryptfs/messaging.c b/fs/ecryptfs/messaging.c
> index 8d7a577..308fdf2 100644
> --- a/fs/ecryptfs/messaging.c
> +++ b/fs/ecryptfs/messaging.c
> @@ -97,8 +97,7 @@ static void ecryptfs_msg_ctx_free_to_alloc(struct ecryp=
tfs_msg_ctx *msg_ctx)
>  void ecryptfs_msg_ctx_alloc_to_free(struct ecryptfs_msg_ctx *msg_ctx)
>  {
>  	list_move(&(msg_ctx->node), &ecryptfs_msg_ctx_free_list);
> -	if (msg_ctx->msg)
> -		kfree(msg_ctx->msg);
> +	kfree(msg_ctx->msg);
>  	msg_ctx->msg =3D NULL;
>  	msg_ctx->state =3D ECRYPTFS_MSG_CTX_STATE_FREE;
>  }
> --=20
> 1.7.9.5
>=20

--BwCQnh7xodEAoBMC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJRGoYoAAoJENaSAD2qAscKOykP/ArUInTgvTmbLtJcm363xa3p
Praf+PGWI4iaEIrq2X8EtOWBesQQd3OZ5otGRtmArzVm2QEsWmrqmJWI7NdcYmct
mYxJyNGt2iU7Re+baf8HiC//NAPcP7b4y1Un+yUJ3xuurb7klqYnYwTAjGdl1QSd
Alpgm1dFS+N7HebaSsz0ylHx9tcSS7jGEQrdPPvLUwfMsgK5whlIRQcnv3ghYxPo
zkh+Dic72Cx2HZ6ZDLUejezFm1cyZkmmpfQglC9Eu8gXQEu1waV74kmfoVC6TrHb
GQalZB9WuICYnuNMm48pztSP9PwDu8LGh2n7oMFk+GC6766G2rSIluyNvPMVi6ss
ZpM4TOkwh4AKNElFNSaZRyiR6siCH6fF15LuaB2mFmoiS9SfSD9u3jjKcJJX5dWu
SGRq5Bf1ncBQUyk/7WF2VU8PW7RKUWWATVQlPLQ53Ypc/c6I+mNtvWt3zt4JzR9D
HdZwk2Ia5bW3cw8tKLKnn8LLxHo89rfW3LawpMSl8oBq7IOLzb8mHVfzbj0AvtQY
YJZqnChHm1qDu8g5rv2csf0cuWK4X09UBP4pftX08F3k8gEUrV9x+iua6B82TX9d
RfhNUbS2eh/d6DUPFn4hUwCrVnKrLTTb9aqv4qOMGhyvGr1bXd0lIdi8h9gJB/WB
YMQRa+Cm2ZimgzTI0mRF
=FI0p
-----END PGP SIGNATURE-----

--BwCQnh7xodEAoBMC--
