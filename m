Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200AbaE0KoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 06:44:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:37037 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbaE0Kn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 06:43:58 -0400
Date: Tue, 27 May 2014 12:43:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Libo Chen <libo.chen@huawei.com>, tglx@linutronix.de, mingo@elte.hu,
        LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, Li Zefan <lizefan@huawei.com>
Subject: Re: balance storm
Message-ID: <20140527104349.GP30445@twins.programming.kicks-ass.net>
References: <5382AF2E.1040407@huawei.com>
 <1401090987.5339.79.camel@marge.simpson.net>
 <53832A36.5020205@huawei.com>
 <20140527094802.GN30445@twins.programming.kicks-ass.net>
 <1401185133.5134.119.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SSjmg4Ji8GIkLRVR"
Content-Disposition: inline
In-Reply-To: <1401185133.5134.119.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SSjmg4Ji8GIkLRVR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 27, 2014 at 12:05:33PM +0200, Mike Galbraith wrote:
> On Tue, 2014-05-27 at 11:48 +0200, Peter Zijlstra wrote:
>=20
> > So I suppose this is due to the select_idle_sibling() nonsense again,
> > where we assumes L3 is a fair compromise between cheap enough and
> > effective enough.
>=20
> Nodz.
>=20
> > Of course, Intel keeps growing the cpu count covered by L3 to ridiculous
> > sizes, 8 cores isn't nowhere near their top silly, which shifts the
> > balance, and there's always going to be pathological cases (like the
> > proposed workload) where its just always going to suck eggs.
>=20
> Test is as pathological as it gets.  15 core + SMT wouldn't be pretty.

So one thing we could maybe do is measure the cost of
select_idle_sibling(), just like we do for idle_balance() and compare
this against the tasks avg runtime.

We can go all crazy and do reduced searches; like test every n-th cpu in
the mask, or make it statistical and do a full search ever n wakeups.

Not sure what's a good approach. But L3 spanning more and more CPUs is
not something that's going to get cured anytime soon I'm afraid.

Not to mention bloody SMT which makes the whole mess worse.

--SSjmg4Ji8GIkLRVR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJThGxlAAoJEHZH4aRLwOS6CFsQAKa3JJxKVo1b7lV2ADqeC6SW
Kpl11cN47ZYPnb6R0y7e08gvscxzR4CJwonRj+5Ex3OHXIezpD60+dTr/XZy65kR
LZv/7zQar04Ck9/qSHpeU+f9ysichjvmLF0xMv6xJ1eHEY5xoxYucrCzC6DW5Ifb
Ly/RTdwpLghb/GPjix+1Sdix+Yiceld3nCymhEYeOyz2cLJJIJ3hGRPHvjda007S
DtQ9eC/934Z1by9fxMHgfhEkuAhABSuEsqIlSHRu5+vzzKXeVsYfYQhlRDcxUXVB
gIen5qMvEMeJpHtOQ0PATuVZwD75S2b79kZSwAWPFYba80oFfOu4bDf7jL7cZ9Ra
i6Kb8a8zgDHg7rIHo8/n8F0DdXmqQbl7H3B1zMMz2vUZ5+RxBePp72DRE8mlSEY+
SbGS5DiatKddMv1Iy4qhzYpulfPFQfLRoQ2PobQ12zszPuwnDMKAfAzUTvTEQoKN
SC88zs7LW3i3o0Tmum0dtmDO6JdHQc6vR/V0Cy1CBhGhqsQpFNtTnoOBeuMJEL3d
FxNvEUuSpwBEzfTR3kR+DCx6B663GfEKmDV1VZ9N3BGUFGl+Rlle5ftyvHSX3iIE
vq5hOgcNHP4Rxsreb+OQuypvYfCF0C+Nsde8CUW+V9HbaIx6m4C2EKOH87CsTYvc
FjIFhQAdCJNRsMeitnRD
=1tL1
-----END PGP SIGNATURE-----

--SSjmg4Ji8GIkLRVR--
