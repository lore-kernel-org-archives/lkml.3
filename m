Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbaG1Gyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 02:54:32 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56681 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbaG1Gy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 02:54:27 -0400
Date: Mon, 28 Jul 2014 08:54:13 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, acme@infradead.org, eranian@google.com
Subject: Re: [PATCH v3 6/9] perf, x86: handle multiple records in PEBS buffer
Message-ID: <20140728065413.GJ6758@twins.programming.kicks-ass.net>
References: <1406016602-31845-1-git-send-email-zheng.z.yan@intel.com>
 <1406016602-31845-7-git-send-email-zheng.z.yan@intel.com>
 <20140725081033.GV3935@laptop>
 <20140725150445.GG18735@two.firstfloor.org>
 <20140725155332.GC6758@twins.programming.kicks-ass.net>
 <20140725164041.GH18735@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IcedwjSBDYVmN9hM"
Content-Disposition: inline
In-Reply-To: <20140725164041.GH18735@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IcedwjSBDYVmN9hM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 25, 2014 at 06:40:41PM +0200, Andi Kleen wrote:
> > Suppose two pebs events, one has exclude_kernel set. It overflows,
> > before entering the kernel, the other event generates PEBS records from
> > inside the kernel with both events marked in the overflow field.
> >=20
> > And only once we leave the kernel can the exclude_kernel event tick
> > again and trigger the assist, finalyl clearing the bit.
> >=20
> > If you were to report the records to both events, one would get a lot of
> > kernel info he was not entitled to.
>=20
> Ok that case can be filtered in software. Shouldn't be too difficult.
> Perhaps just using ip
>=20
> 	if (event->attr.exclude_kernel && pebs->ip >=3D __PAGE_OFFSET)
> 	    skip;
> 	if (event->attr.exclude_user && pebs->ip < __PAGE_OFFSET)
> 	    skip;
>=20
> This would also help with the existing skid.
>=20
> Any other concerns?

Yeah, why fuck about and do ugly hacks when you can actually do it
right? That way you're sure you've not forgotten anything.

--IcedwjSBDYVmN9hM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT1fOVAAoJEHZH4aRLwOS6ueoP/2TLKjDKNzuP6nvyYTtk/1DQ
8kFAohClBYos6ckZd5GLGpfftmQjUTXynLVBbQN6yyzh5+5yhIMpKZErknLidHeN
E7PeKqXfOG0V+QBNuQuQvVjW766Z+FNqINiT/CURBO4Gr85ev7SNPH50V6uisNgT
jbmK3xEFhQ7Qk8XhlUIQxn95zir2lhRoQtYlqM1FGNG38RbP0/D5E1qKNZ8TIg9s
WDtZRKLQdrWAwQlKFoIWPSyTv7ArD9tQGrQk9wy23+/E4EK7RhdJ1Fu5TGybz5N9
lR4HASCioQVblR71ex0+grvLeILzJn9n1o9e+MLh2K8jYQhyCtZMEexxUgfFReTo
KQ7fc5NZfUIeRP5QSUkMUxh2JYYqD6Tx4LKwrcvYYaTU1qhh1ZXjkm6uN0AwXASs
TYEto+ezz1xFnJToUpZEPXIuy83Hgj6HgZrqLp/6jJhdkci58+nWyM9DUI3kxI3v
d9l0Edfz5T28xgEas1hbZ909dqlbiKCVbHL5eDv3izp2yNq/eSxYKrtmIt8NHDuP
0WEpqWfxGLfQJW6lRu+n1GzbIspseE/uTguLclefNX0JkyPL1Q8nDWxPkgxOODMB
Cke34oGiXsnUFmtqo+9oI5EBRFwZD8p8PIcXtld/F8A5mWwW/xRx8hKQtQWurbyq
A8GB27QbAD9S+qD9hf0X
=dC49
-----END PGP SIGNATURE-----

--IcedwjSBDYVmN9hM--
