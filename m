Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab3KNTw5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 14:52:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48523 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab3KNTwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 14:52:49 -0500
Date: Thu, 14 Nov 2013 11:52:43 -0800
From: Tyler Hicks <tyhicks@canonical.com>
To: "Geyslan G. Bem" <geyslan@gmail.com>
Cc: ecryptfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH] ecryptfs: Fix explicit null dereference
Message-ID: <20131114195238.GA7693@boyd>
References: <1384454534-27807-1-git-send-email-geyslan@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
In-Reply-To: <1384454534-27807-1-git-send-email-geyslan@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2013-11-14 15:42:14, Geyslan G. Bem wrote:
> If the condition 'ecryptfs_file_to_private(file)' takes false branch
> lower_file is dereferenced when NULL.
>=20
> Caught by Coverity: CIDs 1128834 and 1128833.
>=20
> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
> ---

Hello - Smatch picked up on this earlier in week and Dan analyzed the
situation here:

  http://article.gmane.org/gmane.comp.file-systems.ecryptfs.general/441

I agree with his assessment and proposed the following patch:

  http://article.gmane.org/gmane.comp.file-systems.ecryptfs.general/442

It makes Smatch happy and it should also make Coverity happy.

Tyler

>  fs/ecryptfs/file.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
> index 2229a74..1c0403a 100644
> --- a/fs/ecryptfs/file.c
> +++ b/fs/ecryptfs/file.c
> @@ -316,10 +316,12 @@ ecryptfs_unlocked_ioctl(struct file *file, unsigned=
 int cmd, unsigned long arg)
>  	struct file *lower_file =3D NULL;
>  	long rc =3D -ENOTTY;
> =20
> -	if (ecryptfs_file_to_private(file))
> -		lower_file =3D ecryptfs_file_to_lower(file);
> +	if (!ecryptfs_file_to_private(file))
> +		goto out;
> +	lower_file =3D ecryptfs_file_to_lower(file);
>  	if (lower_file->f_op->unlocked_ioctl)
>  		rc =3D lower_file->f_op->unlocked_ioctl(lower_file, cmd, arg);
> +out:
>  	return rc;
>  }
> =20
> @@ -330,10 +332,12 @@ ecryptfs_compat_ioctl(struct file *file, unsigned i=
nt cmd, unsigned long arg)
>  	struct file *lower_file =3D NULL;
>  	long rc =3D -ENOIOCTLCMD;
> =20
> -	if (ecryptfs_file_to_private(file))
> -		lower_file =3D ecryptfs_file_to_lower(file);
> +	if (!ecryptfs_file_to_private(file))
> +		goto out;
> +	lower_file =3D ecryptfs_file_to_lower(file);
>  	if (lower_file->f_op && lower_file->f_op->compat_ioctl)
>  		rc =3D lower_file->f_op->compat_ioctl(lower_file, cmd, arg);
> +out:
>  	return rc;
>  }
>  #endif
> --=20
> 1.8.4.2
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe ecryptfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBCgAGBQJShSoGAAoJENaSAD2qAscKMd4P/00y2Gbu0D3QDHJAw3iINBQI
BLJ9uD/+jebg27L2CODcatAzrjqsbxgGI8wKzOn0YqFiHze/5wKJUX78GgzlCLzA
Ho2RVqaae/i3eV+SHRGSYhAMCxMmhu6RjLks5SgGs2Ur8RuhpHHaNBUXEfmTA+YE
qHjli5VaQRv2rIlUOEANIvYAqMSKo0rMjXbcTfwjVdvdET6m2CJL2/YQBGo3Cjrl
hy9d4Us8VPR+BjSoLvtthNW3T36TdCJ2WyB1qwgTgqaF/BdRJjjEbhKqdHq57npc
N5IhMLOfW9IlrwNhJG0y+xMbKRn4RzTpQw1QbydV+sbyQcsunjdJ8VRjfu6T3LHg
gxKKqeYL40BNGG/zzNFqrV/3SgQKMz68wctuRxD33x2iVcwg01nh/aGLwJI4xlxs
QrWY1FjbB83fsLfn0Azbq5SQBwR7kMixSVa0lw14ExAc5FnqQmaNMWxVIeeL4T7p
5Srb2I2RTdYwR/6J1g7Xl2wt0EJ3UvD74z8b5djjAs+Uzz38ws05MQfowo89Zw+p
FHtLiEZ3whHM4MPgaEgTyB4EO+5gnGl6hhgl1vaPTNaLefaZSXeZJhFYjuEQzBYl
gptHGuZC4opQmcZUxQmv1rWgMHyM+EQleR0EfQeg+BEw19RC0VHWbMBC+x9X7ffV
rC/4iaLwQ/0MSe9Pwq5g
=RKn+
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
