Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab3KEDdD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 22:33:03 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:54328 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab3KEDdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 22:33:00 -0500
Date: Tue, 5 Nov 2013 14:32:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kent Overstreet <kmo@daterainc.com>,
        Jens Axboe <axboe@kernel.dk>, Joe Thornber <ejt@redhat.com>
Subject: Re: linux-next: build failure after merge of the device-mapper tree
Message-Id: <20131105143248.551f68c3cd9fe1902860c1ff@canb.auug.org.au>
In-Reply-To: <20131105032054.GA19421@redhat.com>
References: <20131105135128.496b8b2f599d11f2d30ad70c@canb.auug.org.au>
	<20131105032054.GA19421@redhat.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__5_Nov_2013_14_32_48_+1100_hL/mePQhPZ8dZ1RJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__5_Nov_2013_14_32_48_+1100_hL/mePQhPZ8dZ1RJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mike,

On Mon, 4 Nov 2013 22:20:54 -0500 Mike Snitzer <snitzer@redhat.com> wrote:
>
> On Mon, Nov 04 2013 at  9:51pm -0500,
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>=20
> > After merging the device-mapper tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> >=20
> > drivers/md/dm-cache-target.c: In function 'bio_writes_complete_block':
> > drivers/md/dm-cache-target.c:1020:7: error: 'struct bio' has no member =
named 'bi_size'
> >    (bio->bi_size =3D=3D (cache->sectors_per_block << SECTOR_SHIFT));
> >        ^
> >=20
> > Caused by commit 1bd270d800ec ("dm cache: promotion optimisation for
> > writes") interacting with commit ed2d2f9a8265 ("block: Abstract out bvec
> > iterator") from the block tree.
> >=20
> > I applied this fix up patch and can carry it as necessary:
>=20
> Yes that is needed, as is this (which begs the question: how should I be

I will add that tomorrow.

> handling the fact that post-merge changes are needed?  Especially since
> Linus will need the changes too):

Who ever gets their tree in last has to tell Linus about these extra
merge fix ups as part of their pull request.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__5_Nov_2013_14_32_48_+1100_hL/mePQhPZ8dZ1RJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSeGbmAAoJEMDTa8Ir7ZwVDBYP/R1nvGsP+jOQYgm4Yz2RgnZV
DEYbaRtn+FsM4eboqAIJaAgg3OtyUlMh/bif6WtEghjGW2HEvjqzVraBEmxPqukb
f00oBsoWoBffqERVKL51ZQVf8pRltQUGY99lD5sEfve5f2tcTxqZSXA/VFBE0Kye
GhRQYmjKIVvD/rvvSqojhWqhOD39BVDEQ47Vpc/7XwwK6gvUT4bHOf3CAgx/dM9Z
O19rqHPyLYpZrJuFVUA8TeKtlpjy/YgyKKmdL3wONu5SvjvdNj9phOYyCQDUXIJz
ZG/JE+TWnBwG7PLIJU6TqYlmsP999MlvG1xB10FaTLxPf5JJbRrMQJGdTxZ+RH1A
aufiOGo3H51pJghI4+81Pwtlx+7c5SeouzJxOQIb7nJdlIXi5umqi3D+Lkh+3pwF
iD/kmUrJ40ljfzKk8/hbjZJzF1VBo8F7LcM/f6+cRTtvRRWKDEmzFflN3k/lQRf5
jF5CwQzl7/eRZpkAxovzhI+Eu8CmPydKnkZd673Xm5nWQf4xex1gZr1v76gBIBow
1Fs5P0WiO77hanscBVNWrqjaNHcaowCjXXys2HaykZ3G8qsNZslnUML+/pPdPRG2
yYiQieAeGFYDXuBR3XLdOuYBe5WCbG8GrHSWLw0GSBRDNpX1l46jVt7/h7huIY2h
1qGjxgHl3cGNr0yTynGt
=QDFG
-----END PGP SIGNATURE-----

--Signature=_Tue__5_Nov_2013_14_32_48_+1100_hL/mePQhPZ8dZ1RJ--
