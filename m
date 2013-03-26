Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab3CZVfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 17:35:54 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53660 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab3CZVfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 17:35:52 -0400
Date: Wed, 27 Mar 2013 08:35:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kent Overstreet <koverstreet@google.com>, Jens Axboe <axboe@kernel.dk>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the final tree (akpm
 and block tree related)
Message-Id: <20130327083535.22ef6a9046f4b53e161481de@canb.auug.org.au>
In-Reply-To: <20130326131051.a47fe83fdbdab4b824394f18@linux-foundation.org>
References: <20130326170554.f9f113fa24a1e5ec6d5d1ee6@canb.auug.org.au>
	<20130326195523.GB24935@google.com>
	<20130326131051.a47fe83fdbdab4b824394f18@linux-foundation.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__27_Mar_2013_08_35_35_+1100_oU+2PWIEExDLhd6Z"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__27_Mar_2013_08_35_35_+1100_oU+2PWIEExDLhd6Z
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Guys,

On Tue, 26 Mar 2013 13:10:51 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> On Tue, 26 Mar 2013 12:55:23 -0700 Kent Overstreet <koverstreet@google.co=
m> wrote:
>=20
> > On Tue, Mar 26, 2013 at 05:05:54PM +1100, Stephen Rothwell wrote:
> > >=20
> > > After merging the final tree, today's linux-next build
> > > produced this warning:
> > >=20
> > > fs/bio.c: In function 'submit_bio_wait':
> > > fs/bio.c:786:17: warning: assignment from incompatible pointer type [=
enabled by default]
> > >=20
> > > This is due to an interaction between commit 9e882242c ("block: Add
> > > submit_bio_wait(), remove from md") from the block tree and commit
> > > "block: prep work for batch completion" from the akpm tree.
> >=20
> > In hindsight maybe it would've been better if the batch completion stuff
> > had gone in via Jens' tree, though I'm sure there would've still been
> > some conflicts.
> >=20
> > What's the procedure for me to fix these? I can send you a fixup patch
> > but if you've pushed this version of linux-next somewhere public I'm not
> > sure where to look.
>=20
> Stephen and I quietly fix up this sort of thing.

Yeah, though a hint might be nice.  It looks like these completion
routines just need the batch argument added, right?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__27_Mar_2013_08_35_35_+1100_oU+2PWIEExDLhd6Z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRUhSnAAoJEECxmPOUX5FEsmYP/ibnOQ1ec5StpAJkWQBEk8tn
YF4N+6ysvwgRF59uTfB1NH/XktF/RMtwCUwIF+dXYDPm0BXKB69uSUwtdLgpwHX7
rvHcXuYebPrzPlvLHO9bMTU9VN47waBMrfPKXUXVJvHJoeRg7Jz8ZqIy86SNCaK4
BWUGZ1Jzy6lMWUTI4NF1C+qqvJEvM2dYNBow1WzPJG/i0JPLt5l8AfaLZz3b039K
c9NA1UojBqmUs8DFIqYTY4WWFfLa2+m3jDvPVl/yndk0tphC3F69/zum0V5PJZKu
i9c8REP1uP3w/6B3s2xyI8LoZJWCAnd9EfgOEOwkziJUbxCdHdtgPhZj/BXtvRER
7eMbCbaQu4/Ub3VTAs4bZZJ2OUhRppN3oQtebwtIg1iuaDMl27uROC5ONb0vAgX0
hQ4Ye9IHuUeETowm9TyQZ4FNP46ud43WuZ/eg22PEicqnrJbPGT997L/LC81sreg
ENwbyEjggHZ32oGUKBfkjp8qikj7XGRRNMt1BZ7C22nh338FFWJxJBo0lVrm57Qv
QeI4K8T4Jq7LIfASOt6Q7RYTU/KtPWxIm3np+pHEVDU2FU4nSV36PgqhZF+efJ+T
8bwtpgNer0eAXNACPJxIqOPNl0Z9gE5lya3KUF46Q09JMbi5/2yimHET0VDR+oFT
MjtYgxrj6/4Pw84WIxVB
=JQe0
-----END PGP SIGNATURE-----

--Signature=_Wed__27_Mar_2013_08_35_35_+1100_oU+2PWIEExDLhd6Z--
