Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516AbaFZTu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 15:50:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34921 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbaFZTu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 15:50:57 -0400
Date: Thu, 26 Jun 2014 14:50:52 -0500
From: Tyler Hicks <tyhicks@canonical.com>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: ecryptfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr, Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2] ecryptfs: Drop cast
Message-ID: <20140626195051.GB22973@boyd>
References: <20140626194159.GA7163@himangi-Dell>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="V0207lvV8h4k8FAm"
Content-Disposition: inline
In-Reply-To: <20140626194159.GA7163@himangi-Dell>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--V0207lvV8h4k8FAm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2014-06-27 01:11:59, Himangi Saraogi wrote:
> This patch does away with cast on void * and the if as it is unnecessary.
>=20
> The following Coccinelle semantic patch was used for making the change:
>=20
> @r@
> expression x;
> void* e;
> type T;
> identifier f;
> @@
>=20
> (
>   *((T *)e)
> |
>   ((T *)x)[...]
> |
>   ((T *)x)->f
> |
> - (T *)
>   e
> )
>=20
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> ---
> v2: remove the if statement
>  fs/ecryptfs/inode.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Thanks! This looks good to me. I'll take the patch from here.

Tyler

>=20
> diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
> index 4d6c7e4..e67f9f0 100644
> --- a/fs/ecryptfs/inode.c
> +++ b/fs/ecryptfs/inode.c
> @@ -53,9 +53,7 @@ static void unlock_dir(struct dentry *dir)
> =20
>  static int ecryptfs_inode_test(struct inode *inode, void *lower_inode)
>  {
> -	if (ecryptfs_inode_to_lower(inode) =3D=3D (struct inode *)lower_inode)
> -		return 1;
> -	return 0;
> +	return ecryptfs_inode_to_lower(inode) =3D=3D lower_inode;
>  }
> =20
>  static int ecryptfs_inode_set(struct inode *inode, void *opaque)
> --=20
> 1.9.1
>=20

--V0207lvV8h4k8FAm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTrHmbAAoJENaSAD2qAscKNk8QAMpTc/fJn00WdAENvtcHntZU
ZWDxhcGH2uNHPoYV/ROSk7Oh9k2T3AN2dlCDnRurMI9AuYgx+tHy1yeidWrOmE3v
+Muav8JC0oZR3iWA2dpPzJ47xwp6bbGLAftXk+51mERLATyJ5ukBiua1Bu+h0A/W
jYUA9J2TNIgjYMCgXPzN5pu0VswMkR8oy1Hi1FOL2jlhcOEPPczG/bIHInowDpPr
lTqwAp3Z3c3wiDT47xrtZOy/uNN8Ygm+tcxPeMIFwVDhMWRBt2gg5ra07GFyyJ/i
ghOFZPnqqBc6lEstUOvtcIFvpSfnpdIUVftk2sNZZxIAwY305wZ7g0/1Gm+rt7cp
fumMAz2UIORuJ4wY6ZvM7W2DsGIm1EzD3QoufD3WrV8XUvpm/EjyLGa9Gm2Jr0xf
4zkUe7ZEHQZoX4NEudvGCxhLvypSEB6DMJys9buYy8CF5/BaxwnuF1kj5DlJZ35m
es9RP57ZjNDiRl7sur883JGpaiX8XA85wpiH6V6llZai75wrP3254jjbusgXIV1B
vY2XDhlfFlf1TYzsknulJvzWbNIM7R5TRDRw5vZblr5J0W4yUbpW5ScIc5OSwSc8
nxSeKTAenCCZvn5S0OkS1pv0201vZWfhB8TSsPGX6tHti3YVJnG8tajTLU63UCQv
IhPWtxHzWP3wg2lU49UT
=Cl0H
-----END PGP SIGNATURE-----

--V0207lvV8h4k8FAm--
