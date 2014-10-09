Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbaJIW0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 18:26:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60060 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaJIW0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 18:26:18 -0400
Date: Thu, 9 Oct 2014 17:26:12 -0500
From: Tyler Hicks <tyhicks@canonical.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: Re: [PATCH] ecryptfs: remove unneeded buggy code in
 ecryptfs_do_create()
Message-ID: <20141009222611.GB24046@boyd>
References: <1411418371-11953-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="0ntfKIWw70PvrIHh"
Content-Disposition: inline
In-Reply-To: <1411418371-11953-1-git-send-email-khoroshilov@ispras.ru>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0ntfKIWw70PvrIHh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alexey - thanks for the patch.

On 2014-09-23 00:39:31, Alexey Khoroshilov wrote:
> There is a bug in error handling of lock_parent() in ecryptfs_do_create():
> lock_parent() acquries mutex even if dget_parent() fails, so mutex should=
 be unlocked anyway.
>=20
> But dget_parent() does not fail, so the patch just removes unneeded buggy=
 code.
>=20
> Found by Linux Driver Verification project (linuxtesting.org).
>=20
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

This looks good to me and I've included it in the pull request that I
just sent to Linus. Thanks!

Tyler

> ---
>  fs/ecryptfs/inode.c | 7 -------
>  1 file changed, 7 deletions(-)
>=20
> diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
> index d4a9431ec73c..97735c75085f 100644
> --- a/fs/ecryptfs/inode.c
> +++ b/fs/ecryptfs/inode.c
> @@ -192,12 +192,6 @@ ecryptfs_do_create(struct inode *directory_inode,
> =20
>  	lower_dentry =3D ecryptfs_dentry_to_lower(ecryptfs_dentry);
>  	lower_dir_dentry =3D lock_parent(lower_dentry);
> -	if (IS_ERR(lower_dir_dentry)) {
> -		ecryptfs_printk(KERN_ERR, "Error locking directory of "
> -				"dentry\n");
> -		inode =3D ERR_CAST(lower_dir_dentry);
> -		goto out;
> -	}
>  	rc =3D vfs_create(lower_dir_dentry->d_inode, lower_dentry, mode, true);
>  	if (rc) {
>  		printk(KERN_ERR "%s: Failure to create dentry in lower fs; "
> @@ -215,7 +209,6 @@ ecryptfs_do_create(struct inode *directory_inode,
>  	fsstack_copy_inode_size(directory_inode, lower_dir_dentry->d_inode);
>  out_lock:
>  	unlock_dir(lower_dir_dentry);
> -out:
>  	return inode;
>  }
> =20
> --=20
> 1.9.1
>=20

--0ntfKIWw70PvrIHh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUNwuDAAoJENaSAD2qAscKlhoQALK4pMcztWmwpqsFkPYxYFeT
8/IbovX6JlekwhZh2FFb1QAyuN+zFn3OFWDCphSzQOnJQPc1RCySpIWVGJl/8p9p
tosfzVjFfaJM3qwstgBiHYWF9FkOjB4wlxCYVU7DBfNEo1oCroIIZCWUhyHdFmv0
WY79uckzA39M4ynsxMKRGfVcGwUHgPWm3JMYAyl5xXhi/sqoRlQcKZ3RWXqb+O0H
CD67Q7mUYaLA+XF3EV76K4asfMWy1SMJcnGpHfOCvOdZkaWwjI/ect1Lcj4fv+9l
+DgOjwnh+h2QehoxEvWRNgUAaz4jdtHWI2XS8OlhkJUzgIl02/rGNfjQ/EyosPbE
ULlNnbLD/OANfOSr1Bp6KYWTebYxrNVgjas/NE3pZb4tn2zrt5IbzT/Lrf94ZY29
8LrUVbuOFEOlg+g4+2Bkd3W7eGkL5WA0gveGmgsb5jeKLF1uoJNd4slG/blrwwWT
55abtWmA5XyvQragz8u144zsIU6Kl7RuqbVNuMX2g1pi2APGbh6/bshtc/BpSDnH
optov0V/dbDa9oGUk4lMaz0EWul/3cfAvOUNNs+ooUiK0KtRAiWb7gYURl5zon+k
4GRDgrRIa5vhPjsBnB53mU1pJ5JUZbZP2FXI3VS0Df8rb0x6mOjl/6wObWJroOYt
WcpYnF8J/VB4KNAA33k+
=lOFH
-----END PGP SIGNATURE-----

--0ntfKIWw70PvrIHh--
