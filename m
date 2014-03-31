Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbaCaXOo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 19:14:44 -0400
Received: from ozlabs.org ([203.10.76.45]:35893 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbaCaXOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 19:14:43 -0400
Date: Tue, 1 Apr 2014 10:14:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Conrad Meyer <cse.cem@gmail.com>, Conrad Meyer <cemeyer@uw.edu>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark <markk@clara.co.uk>
Subject: Re: [PATCH v2] fs: FAT: Add support for DOS 1.x formatted volumes
Message-Id: <20140401101436.a5be0a7a9d832a373155ee3e@canb.auug.org.au>
In-Reply-To: <20140331153232.1ea27e25cb4690e64da63782@linux-foundation.org>
References: <1396120235-27844-1-git-send-email-cse.cem@gmail.com>
	<20140331151337.f6a46a8fcab6206f4d21be08@linux-foundation.org>
	<CAG6CVpV6sxOc2ZH_xWRGc28N6W+M9iK6QbX-4bx326FON8B9GA@mail.gmail.com>
	<20140331153232.1ea27e25cb4690e64da63782@linux-foundation.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__1_Apr_2014_10_14_36_+1100_+ZiVBR7mifEXsemu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_Apr_2014_10_14_36_+1100_+ZiVBR7mifEXsemu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 31 Mar 2014 15:32:32 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> On Mon, 31 Mar 2014 15:21:17 -0700 Conrad Meyer <cse.cem@gmail.com> wrote:
>=20
> > >> +     if (get_unaligned_le16(&b->sector_size) !=3D 0 || b->sec_per_c=
lus !=3D 0 ||
> > >> +             b->reserved !=3D 0 || b->fats !=3D 0 ||
> > >> +             get_unaligned_le16(&b->dir_entries) !=3D 0 ||
> > >> +             get_unaligned_le16(&b->sectors) !=3D 0 || b->media !=
=3D 0 ||
> > >> +             b->fat_length !=3D 0 || b->secs_track !=3D 0 || b->hea=
ds !=3D 0 ||
> > >> +             b->secs_track !=3D 0 || b->heads !=3D 0)
> > >
> > > Impressive!
> >=20
> > I aim to please.
>=20
> No great improvements immediately occur to me ;)
>=20
> One could do
>=20
> 	/* nice comment */
> 	if (get_unaligned_le16(&b->sector_size) !=3D 0)
> 		return;
> 	/* another nice comment */
> 	if (b->sec_per_clus !=3D 0)
> 		return;
> 	...
>=20
> but one would quickly run out of nice comments.
>=20
> You could do s/ !=3D 0//g.

You could also put the boolean expression in a (hopefully expressively
named) helper function and do the tests separately there.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__1_Apr_2014_10_14_36_+1100_+ZiVBR7mifEXsemu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTOfbgAAoJEMDTa8Ir7ZwV+EgP/jy+9Pd9bTdQnvMB1Hi2qg5p
TvTb0rbNyZLRcT3DzM/MKOdj2TaciScw2+9QZUofsDByUmV76IrWr9UGd/newJxx
UH7WZt8KRM1lfb8taPFPmjUufsx+7ohj9emxN2QvouVKPI2xDgCNyB/ruB2hkfsj
ma0gjH5O7l7yo6fGgfe1J2aX/k1iPBMrlGwZ4DojgTtxG7ZnSW2JzsxituxIoHFL
krYwQBkPiy5XXPd+RNRoQbF3OzhUISfVha/5Tp+ORzpGDY3SOPgXdUKM/ZQ7wBuc
oXnGad0rkwzuJvLEvRW6Rs3f+0+ZDDmavBk1SZuKuv+mANpw6zzdaf/diKIB6VJI
TRWIKAd8UZiXJFc4IMBb5tAdySux+0cd0Pto1A7FlZThwQq5SoSQZvZblYiTgJ7Q
nkZ8JhobZ03/giLxIQgiJUyozhb1fbiLrhZI2YmF3O9gULzZYq8rXy/TKT6xyI4O
yM+yaUtNj76ZzmyBCJNTzDt60ttZi0TJApGFKY94lZXNjh+6HehwauZF/euT6J4G
TJO6zDcK9vH5n6CWIIe0e8YaKfIKv55xOkepFq/7PfxzzTIBwFU1UadURUYGspvD
91nE8FFc5srqZMElA+uJic5l17HAPOrRvhSe+OASTV4QfrarHoJVmUGnCSRFtYZs
spf5KmIDNu71AG3/5uOq
=w3qr
-----END PGP SIGNATURE-----

--Signature=_Tue__1_Apr_2014_10_14_36_+1100_+ZiVBR7mifEXsemu--
