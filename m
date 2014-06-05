Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565AbaFEOOd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:14:33 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58506 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaFEOOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:14:32 -0400
Date: Thu, 5 Jun 2014 16:14:25 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, ak@linux.intel.com, jolsa@redhat.com,
        zheng.z.yan@intel.com
Subject: Re: [PATCH 5/9] perf/x86: implement cross-HT corruption bug
 workaround
Message-ID: <20140605141425.GB3588@twins.programming.kicks-ass.net>
References: <1401917658-26065-1-git-send-email-eranian@google.com>
 <1401917658-26065-6-git-send-email-eranian@google.com>
 <20140605134841.GL3213@twins.programming.kicks-ass.net>
 <CAHzUATjSd0Cio25RvwNaph0vFZYQB-pKBt=xz7C=_MhZvpFXxQ@mail.gmail.com>
 <20140605141150.GL6758@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qcHopEYAB45HaUaB"
Content-Disposition: inline
In-Reply-To: <20140605141150.GL6758@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qcHopEYAB45HaUaB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 05, 2014 at 04:11:50PM +0200, Peter Zijlstra wrote:
> > > x86_schedule_event()
> > >   ->start_scheduling()
> > >     spin_lock()
> > >   ->get_event_constraints()
> > >     intel_get_excl_constraints()
> > >       kmalloc(.gfp=3DGFP_KERNEL)
> > >
> > > How can that ever work?
>=20
> > Are you saying it is illegal to call kmalloc() from
> > this context?
>=20
> Nobody will come and arrest you for it, so no. Broken though. GFP_KERNEL
> will attempt to sleep to wait for reclaim, and you're holding a
> spinlock.

Furthermore, even GFP_ATOMIC shouldn't be used because these are/should
be raw_spinlocks and the zone->lock is a regular spinlock.

So please look into the preallocation thing.

--qcHopEYAB45HaUaB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTkHtBAAoJEHZH4aRLwOS6CCwP+QGAWkMM6Op/eFlVFTUENEHi
zRr5GpcSgfiG12dKCv1k2CrzaQVN0SvQvrjJAh7SExOzyQDVz5NL9QZhbr1CGlT7
EOL3AZ6Sol3gfgj1cxZjFG/9WWzgQwsBV4XlGKqGawSeWjp/ZHUNaBuoNvtf6hi5
2Ro82+1V+Lc7CLew1RCvXxBZJZVnEr+O94xYkcBWgOXnsNpbbkFd63zUoVGsCqEY
5kdBWok9bKphePBa//B+ANTSdbZIHCfZOTZmHLsJr3eUJB+1Ugqzg5jtDJsmar0w
evIFtRWvx128C05xhG0+szpUBfXAfKgjoZEeb3bw3J6fcr81VjA1Mj4z0uay1VwA
eGeoXoufRJVfHnQniiO7ZIZYBYIjwiQUepJQucDZ665Uw1ab3rBFQueOjSwh+ba2
sZdH9ZfME39GHGjTxkJgtV7V98tLTWI5RBQArmmv132jO+WSGJ6elcVEyG30FnIF
Y5+FJAfoG2jN57sgvD9UYc+tAwamY81ajAWLHqCcIcn/Tf9aU88BCkdyqWibPMe2
4GswR81/uuPhGnNzfgtocIhBPjtWNtdZJHrrNjpzpxPEMDwWQ24qkCjriapaGqNO
T7hclw24++x2vcCYvZOZLUdfaYISkw9O5NcHzJ3RBgB0EjumCdDwC+IoRssMRr67
/qpxOE780C0Q2solJ4iQ
=bmMc
-----END PGP SIGNATURE-----

--qcHopEYAB45HaUaB--
