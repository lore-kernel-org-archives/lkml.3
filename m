Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbaHNAfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 20:35:43 -0400
Received: from ozlabs.org ([103.22.144.67]:56574 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408AbaHNAfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 20:35:41 -0400
Date: Thu, 14 Aug 2014 10:35:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: problem importing the akpm-current tree
Message-ID: <20140814103535.4c143f0c@canb.auug.org.au>
In-Reply-To: <20140814102754.29ecc247@canb.auug.org.au>
References: <20140814102754.29ecc247@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/16uY2zlwCjb2VVMN7a_lg2q"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/16uY2zlwCjb2VVMN7a_lg2q
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Thu, 14 Aug 2014 10:27:54 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> While importing mmotm 2014-08-13-14-29, I get the following:
>=20
> $ git am --patch-format=3Dmbox ../mmotm/broken-out/drivers-gpu-drm-nouvea=
u-fix-build.patch
> Applying: drivers/gpu/drm/nouveau: fix build
> error: patch failed: drivers/gpu/drm/nouveau/core/include/nvif/unpack.h:1
> error: drivers/gpu/drm/nouveau/core/include/nvif/unpack.h: patch does not=
 apply
> Patch failed at 0001 drivers/gpu/drm/nouveau: fix build
>=20
> the problem is that the files altered by that patch are symlinks in the
> git tree and the patch tries to turn them into real files with #includes
> of the symlink target.
>=20
> I skipped the patch and I guess your problem arose from applying a git
> patch to a non git tree which created real files whose contents were
> just the symlink target names.

Yeah, its your origin.patch ... which is produced by git and includes
the symlinks (search for "new file mode 120000"), but quilt applied
with patch.  I don't actually apply that patch when I import your tree,
I merge the appropriate part of Linus's tree and so in this case get
the actual symlinks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/16uY2zlwCjb2VVMN7a_lg2q
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT7ARbAAoJEMDTa8Ir7ZwVeMYP/iJL8Rf5jrZVU5b6GGoxhq6K
F8ypYaBxH9IDnbFwg8l6aJzzDjRn8do7mxERayYx9squlGuCDZ8qjNOnpz7kS0mC
qgcxS/U7W88j3TvpxhM9m2H8mym04rkPvCv9zUfI9WyjaGCAPAGnnggps+1dxxsJ
M0pltbr7sdpq2NIFvGdg3+s8u+0h8f+sAEK3vbh2mMiR7IrNxHBFYhmHRiHJgvAn
RYglLO6Om0iidbxz4jrHqGS6jUsKIngewL+CEF3hRy7K0DCYAy1wScPQV9EmsL6T
NhiOEgu+AbD2HH9JSyzqCIHsnlWecKgpmVzRYa7CTa3cxFQFKpdgwoVqS5L1vPHn
Zi8MBszlxoN+rGHJzJbMcgpIG4UYn7KNKVnbuQnmVVYIqpO5bTbidy9dJOc4CFVf
aIS5dBMd1U3mIcJzb6bY4eNGxEa+PxUDytefmb1yBPBd45DTMD3+JwXr2CJYnibM
6xcOqJ0QBni/ho3cWqpQmv9Vebwu2rs0sL0Y0yX1eBVz3zP9JoOW68yrrHYvylI/
P4MrlcZxsBZ4a+aQ7H99WuftNvdjwOsJGxOs/crJdlA1tYIw8CGMVLX+Hh6BD/w+
QPAG5gi5J1ed//NdJWIso99FPNPXC9De7cdac4OkAHDn2ebMFDlIrN5ahAJv83yM
xAaKmV5sj2VhGeBhBoU0
=/wHt
-----END PGP SIGNATURE-----

--Sig_/16uY2zlwCjb2VVMN7a_lg2q--
