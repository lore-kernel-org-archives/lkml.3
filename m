Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025Ab3EXXbr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 19:31:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36550 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156Ab3EXXbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 19:31:46 -0400
Date: Fri, 24 May 2013 16:31:40 -0700
From: Tyler Hicks <tyhicks@canonical.com>
To: Paul Taysom <taysom@chromium.org>
Cc: Dustin Kirkland <dustin.kirkland@gazzang.com>, ecryptfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, olofj@chromium.org
Subject: Re: [PATCH] fs: ecryptfs: fixed msync to flush data
Message-ID: <20130524233139.GA4029@boyd>
References: <1369344703-22245-1-git-send-email-taysom@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
In-Reply-To: <1369344703-22245-1-git-send-email-taysom@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2013-05-23 14:31:43, Paul Taysom wrote:
> When msync is called on a memory mapped file, that
> data is not flushed to the disk.
>=20
> In Linux, msync calls fsync for the file. For ecryptfs,
> fsync just calls the lower level file system's fsync.
> Changed the ecryptfs fsync code to call filemap_write_and_wait
> before calling the lower level fsync.
>=20
> Addresses the problem described in http://crbug.com/239536
>=20
> Signed-off-by: Paul Taysom <taysom@chromium.org>
> ---

Thanks, Paul! I've pushed this to the eCryptfs next branch:

http://git.kernel.org/cgit/linux/kernel/git/tyhicks/ecryptfs.git/log/?h=3Dn=
ext

I also marked it for the stable kernel as affecting 3.6 and newer.

As a side note, we need to make ecryptfs_fsync() more selective about
what gets synced by using filemap_write_and_wait_range() and
vfs_fsync_range(). Since we're already calling vfs_fsync() for the
entire lower file, this patch is good enough for now.

Tyler

>  fs/ecryptfs/file.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
> index 201f0a0..16f509d 100644
> --- a/fs/ecryptfs/file.c
> +++ b/fs/ecryptfs/file.c
> @@ -295,6 +295,7 @@ static int ecryptfs_release(struct inode *inode, stru=
ct file *file)
>  static int
>  ecryptfs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
>  {
> +	filemap_write_and_wait(file->f_mapping);
>  	return vfs_fsync(ecryptfs_file_to_lower(file), datasync);
>  }
> =20
> --=20
> 1.8.2.1
>=20

--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJRn/hbAAoJENaSAD2qAscKTLoP/1rv6hWwsnLwlYx1XaGg5C/X
MC5GRK/lxwsC/vKBnXjJSDl4TXJzQeuaJDJUqjOugO5kj8O5aLjdwCgmtOpO4E26
AUvC7/Iw8PIrQq72DYlBB0Gh8kvro5RQ6nPeSy+rVcWS8BBFlpqCsaml4PhTFA/w
kZ4LCPifSLXqmXXU0LuhoC4YXnZecinWNWaHvjO/Z+j9EQ9sZZK2IKg/eQXYDzCj
vmBlOH58hxa42NVu5mRZ9exajPmmQLPq9OJx+ZBgghKt57x3bfORdy5+cgUwM25R
ucV77WZYzD6vyaCKzuKLOGTgL1L9709e4ctitDpFo+TU0fIhoUEAp4v/c5J+IpOm
STaT/Q4eV+p/4/BrQzH1XwSiowK/xFLXpVjWzy3H8fI31Rdee2Mu7x2DriDM+uts
XFoXiEjwbDYw/5FbgEhPpJYdpXkdaK6X8v59eqFL4v+tX2IWMe3FbXASfzOF+Ppx
HbH2CvAsIfeWBJ4uocOjJnYhlILj7wq1Q72x/BH50e2cdEPw/G7OCS6XOZeUluN8
7/ipjqlIR+0jfyIneI46ME7oqzVhUlx9lV6PIMzZ9eoEIuZ4djWO1HI3LV2cGJyl
bWaQiO6h8pmkiTXQPisPpV4Li0vxulRvwsgVJEOCFIFm3088THRuXo43eHUik5u7
wPKMq1/CMPsBhBAyIdm6
=Qk69
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
