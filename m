Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbaIWGMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 02:12:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55165 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320AbaIWGL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 02:11:57 -0400
Date: Tue, 23 Sep 2014 16:11:44 +1000
From: NeilBrown <neilb@suse.de>
To: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernfs: use stack-buf for small writes.
Message-ID: <20140923161144.65b26224@notabene.brown>
In-Reply-To: <20140923055156.GC11740@mtj.dyndns.org>
References: <20140923140633.35efbe7a@notabene.brown>
	<20140923041817.GA11740@mtj.dyndns.org>
	<20140923144650.2aa71b39@notabene.brown>
	<20140923045549.GB11740@mtj.dyndns.org>
	<20140923154058.6a1c2449@notabene.brown>
	<20140923055156.GC11740@mtj.dyndns.org>
X-Mailer: Claws Mail 3.10.1-123-gae895c (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/AeoqlAK7JT9185.2GruDzWO"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/AeoqlAK7JT9185.2GruDzWO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 23 Sep 2014 01:51:56 -0400 Tejun Heo <tj@kernel.org> wrote:

> On Tue, Sep 23, 2014 at 03:40:58PM +1000, NeilBrown wrote:
> > > Oh, I meant the buffer seqfile read op writes to, so it depends on the
> > > fact that the allocation is only on the first read?  That seems
> > > extremely brittle to me, especially for an issue which tends to be
> > > difficult to reproduce.
> >=20
> > It is easy for user-space to ensure they read once before any critical =
time..
>=20
> Sure, but it's a hard and subtle dependency on an extremely obscure
> implementation detail.
>=20
> > > I'd much rather keep things direct and make it explicitly allocate r/w
> > > buffer(s) on open and disallow seq_file operations on such files.
> >=20
> > As far as I can tell, seq_read is used on all sysfs files that are
> > readable except for 'binary' files.  Are you suggesting all files that =
might
> > need to be accessed without a kmalloc have to be binary files?
>=20
> kernfs ->direct_read() callback doesn't go through seq_file.  sysfs
> can be extended to support that for regular files, I guess.  Or just
> make those special files binary?
>=20
> > Having to identify those files which are important in advance seems the=
 more
> > "brittle" approach to me.  I would much rather it "just worked"
>=20
> I disagree.  The files which shouldn't involve memory allocations must
> be identified no matter what.  They're *very* special.  And the rules
> that userland has to follow seem completely broken to me.  "Small"
> writes are okay, whatever that means, and "small" reads are okay too
> as long as it isn't the first read.  Ooh, BTW, if the second read ends
> up expanding the initial buffer, it isn't okay - the initial boundary
> is PAGE_SIZE and the buffer is expanded twice on each overflow.  How
> are these rules okay?  This is borderline crazy.  In addition, the
> read path involves a lot more code this way.  It ends up locking down
> buffer policies of the whole seqfile implementation.
>=20
> > Would you prefer a new per-attribute flag which directed sysfs to
> > pre-allocate a full page, or a 'max_size' attribute which caused a buff=
er of
> > that size to be allocated on open?
> > The same size would be used to pre-allocate the seqfile buf (like
> > single_open_size does) if reads were supported.
>=20
> Yes but I really think we should avoid seqfile dependency.

I'll see what I can do.

You didn't say if you preferred a flag or a 'max_size'.

Thanks,
NeilBrown

--Sig_/AeoqlAK7JT9185.2GruDzWO
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVCEPIDnsnt1WYoG5AQL+IRAAleiIUYaixBDvoGmGTQhATATHtNpg5Lpo
YjfjnKpQbNKjKRIMpfHr25jlrF2HjOB5YSl8cK4GEjTUnicSBzYHNcgXvY5iCyXB
1oh8WgIgg7y1gUcvUCWvor4gsi4mb28yE9gv3SAVE0frHfGkc7ml02q1KAOYaxEt
JZFsPrbCjqfYshAay/4OyhzsFh9WlVGl+Hk67FUZvmiXrn4W6cIf2Wk+GmuqUyBe
FkBpKUewYNWEYAqQp//J1icVhti0zdlab7qRBrRtmfVl80uTZKPldgIOpS989cyx
sylWhc7QBIxoN6+Azb+rMINcK5t5ah0YzcGO4Kfg6yxnvLRbV9iywm2sGBACdIu1
C8T1kQnxHhIs1Bk8FNXcAXada9UQ4t0fipJnlK8TesLCTewYi1uggit32jS/D+i1
2LX13vQjGrw879eOmw3EyGTKVKsxvqQ3nT/NPRpUq9Qb0nbO+E90kUVceFVGXW5V
Rd/XFvCkzJ06RD12HeE272tvZPWpB+fHYqc63Axn++Pga41KtHA9NlwUCqzm5JNG
CT+v+HuIaaDbEy/l4YyUZN47nYrg/SA2NjtLvByvLCE5dWwljEurDnVf+8tDbNpg
nehefnnuvzTRo9ZlROeAsLrWUBSD07FVuuITMUny7FyIgEkMAAWdr2xBM9mU2dCC
Pebm/+WD55w=
=GlR5
-----END PGP SIGNATURE-----

--Sig_/AeoqlAK7JT9185.2GruDzWO--
