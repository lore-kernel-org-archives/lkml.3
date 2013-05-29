Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967209Ab3E2XXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 19:23:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48257 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932812Ab3E2XW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 19:22:56 -0400
Date: Thu, 30 May 2013 09:22:43 +1000
From: NeilBrown <neilb@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Richard W.M. Jones" <rjones@redhat.com>,
        Kent Overstreet <koverstreet@google.com>,
        Calvin Owens <jcalvinowens@gmail.com>, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, majianpeng@gmail.com
Subject: Re: [PATCH] md: Partially revert 2f6db2a7, which broke raid5
Message-ID: <20130530092243.52fa17c3@notabene.brown>
In-Reply-To: <20130529130340.GC22724@kernel.dk>
References: <20130517213223.GA2530@gmail.com>
	<20130518070515.GL19781@kernel.dk>
	<20130519175145.GC19194@moria.home.lan>
	<20130529124357.GA15210@redhat.com>
	<20130529130340.GC22724@kernel.dk>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.14; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/JSh987KBdG8xnDCBEYdZV15"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/JSh987KBdG8xnDCBEYdZV15
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 29 May 2013 15:03:40 +0200 Jens Axboe <axboe@kernel.dk> wrote:

> On Wed, May 29 2013, Richard W.M. Jones wrote:
> >=20
> > On Sun, May 19, 2013 at 10:51:45AM -0700, Kent Overstreet wrote:
> > > Sorry for the delay - been vacationing. Reproduced the original bug,
> > > here's a patch that fixes it:
> > >=20
> > >=20
> > > commit 402f5db3708b2062795a384a3d8397cf702e27bc
> > > Author: Kent Overstreet <koverstreet@google.com>
> > > Date:   Sun May 19 10:27:07 2013 -0700
> > >=20
> > >     raid5: Initialize bi_vcnt
> > >    =20
> > >     The patch that converted raid5 to use bio_reset() forgot to initi=
alize
> > >     bi_vcnt.
> > >    =20
> > >     Signed-off-by: Kent Overstreet <koverstreet@google.com>
> > >     Cc: NeilBrown <neilb@suse.de>
> > >     Cc: Jens Axboe <axboe@kernel.dk>
> > >     Cc: linux-raid@vger.kernel.org
> > >=20
> > > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > > index 9359828..753f318 100644
> > > --- a/drivers/md/raid5.c
> > > +++ b/drivers/md/raid5.c
> > > @@ -664,6 +664,7 @@ static void ops_run_io(struct stripe_head *sh, st=
ruct stripe_head_state *s)
> > >  			if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags))
> > >  				bi->bi_rw |=3D REQ_FLUSH;
> > > =20
> > > +			bi->bi_vcnt =3D 1;
> > >  			bi->bi_io_vec[0].bv_len =3D STRIPE_SIZE;
> > >  			bi->bi_io_vec[0].bv_offset =3D 0;
> > >  			bi->bi_size =3D STRIPE_SIZE;
> > > @@ -701,6 +702,7 @@ static void ops_run_io(struct stripe_head *sh, st=
ruct stripe_head_state *s)
> > >  			else
> > >  				rbi->bi_sector =3D (sh->sector
> > >  						  + rrdev->data_offset);
> > > +			rbi->bi_vcnt =3D 1;
> > >  			rbi->bi_io_vec[0].bv_len =3D STRIPE_SIZE;
> > >  			rbi->bi_io_vec[0].bv_offset =3D 0;
> > >  			rbi->bi_size =3D STRIPE_SIZE;
> >=20
> > Ditto to the previous follow up.  We've been tracking this
> > bug for nearly a month:
> >=20
> > https://bugzilla.redhat.com/show_bug.cgi?id=3D962079
> >=20
> > Please include this (or the other) patch to fix it.
>=20
> I'm assuming both Kent and I are waiting for Neil to pick it up. Neil, I
> can include this in my next round going upstream, just let me know. It
> should have been sent upstream a while back, sorry guys.
>=20

Seems you were waiting for me, and I was waiting for you :-)

Yes: please include it with your next round.  Thanks!

NeilBrown

--Sig_/JSh987KBdG8xnDCBEYdZV15
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUaaNwznsnt1WYoG5AQKRjg//ZFht3HE9hiPBaWm37ng7/tGZZa5zedYf
NnMuqB12jjE+gNBJfnbgGOBIACb3k0sMyNPM7jXeievPEruOVqQMuyAmqtjV1Iw7
tDxvAlGE7TpexCdKbhgQjTbJT7Y78QdxxTxk4v4TbBKzREZDsUgAYbgLS+TRJeRe
G/dKKbzREzWtngT1MJVRsqz8KK/aLaVx7g29g1TzPpwKOLI8Bi3XYhXrNAt2Y0mH
owgPnqwGVC4mXEgOuH3Pu4O7fVvShoB+XzWzJh8jLi/gC5EUlqGCV4FYCScAKtrM
/nMEnFh3yIs9HmPg4Et3elNuW12ZDRzmuKOJ5ajzfpx0HIxWBdzBNWL3lJTOm+Nc
NJDeP87r0UHGi8i8+94ee1UR/uj9mjrFF+vb59BepuhQlNChazkHkbWfxawThdgo
EgHRFKAV+fm/2HO05NFAHPlYwvcluOrSwnkPPAdVodn5VTpKG8gkwhDu5bAWdF1N
wh+mZZo24JicM9a6El0US5QSkD4V8MsSJH0lamu8BtcZvUnnkGD67j+ADRyI6gSa
HbWtVWgsBq+ts33qi5lniT7ZNNjHlC9gud+omvoSWS5IrG/MVLrRwUQEmM/fqcDY
Vlf2NoKyIaq9Q5R1jGsGxadfCIMPWzR/slN4NaufZAHQVN+hyUJmo5oPoW8IASb6
vvw1XvBQCpI=
=PCn6
-----END PGP SIGNATURE-----

--Sig_/JSh987KBdG8xnDCBEYdZV15--
