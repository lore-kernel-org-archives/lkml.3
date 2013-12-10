Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab3LJIGw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:06:52 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:37352 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab3LJICl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:02:41 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] afs: proc cells and rootcell are writeable
Date: Tue, 10 Dec 2013 09:02:37 +0100
User-Agent: KMail/1.13.7 (Linux/3.12.0-5-generic; KDE/4.11.3; x86_64; ; )
Cc: linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
References: <201311201430.56135@pali>
In-Reply-To: <201311201430.56135@pali>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart18741960.cN2F2aPSBm";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201312100902.37942@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart18741960.cN2F2aPSBm
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 20 November 2013 14:30:55 Pali Roh=C3=A1r wrote:
> Both proc files are writeable and used for configuring cells.
> But there is missing correct mode flag for writeable files.
> Without this patch both proc files are read only.
>=20
> diff --git a/fs/afs/proc.c b/fs/afs/proc.c
> index 526e4bb..276cb6e 100644
> --- a/fs/afs/proc.c
> +++ b/fs/afs/proc.c
> @@ -147,11 +147,11 @@ int afs_proc_init(void)
>  	if (!proc_afs)
>  		goto error_dir;
>=20
> -	p =3D proc_create("cells", 0, proc_afs, &afs_proc_cells_fops);
> +	p =3D proc_create("cells", S_IFREG | S_IRUGO | S_IWUSR,
> proc_afs, &afs_proc_cells_fops); if (!p)
>  		goto error_cells;
>=20
> -	p =3D proc_create("rootcell", 0, proc_afs,
> &afs_proc_rootcell_fops); +	p =3D proc_create("rootcell",
> S_IFREG | S_IRUGO | S_IWUSR, proc_afs,
> &afs_proc_rootcell_fops); if (!p)
>  		goto error_rootcell;

Hello, can somebody review my patch?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart18741960.cN2F2aPSBm
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlKmyp0ACgkQi/DJPQPkQ1J99wCfWhMYfTbws3Cz3AB+/sq12jGe
CB8AniDL+DEU0vjQn19GGphkBgvYsEGX
=I2yg
-----END PGP SIGNATURE-----

--nextPart18741960.cN2F2aPSBm--
