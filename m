Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbaE1GOx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 02:14:53 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58004 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaE1GOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 02:14:51 -0400
Date: Wed, 28 May 2014 08:14:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Mike Marciniszyn <infinipath@intel.com>
Subject: Re: [RFC][PATCH 0/5] VM_PINNED
Message-ID: <20140528061439.GI11096@twins.programming.kicks-ass.net>
References: <20140527102909.GO30445@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405270929550.13999@gentwo.org>
 <20140527144655.GC19143@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405271011100.14466@gentwo.org>
 <20140527153143.GD19143@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405271128530.14883@gentwo.org>
 <20140527164341.GD11074@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405271152400.14883@gentwo.org>
 <20140527172930.GE11074@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405271454370.15990@gentwo.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rwwPlZPbpBX9O0Yk"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405271454370.15990@gentwo.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rwwPlZPbpBX9O0Yk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 27, 2014 at 03:00:15PM -0500, Christoph Lameter wrote:
> On Tue, 27 May 2014, Peter Zijlstra wrote:
>=20
> > > What do you mean by shared pages that are not shmem pages? AnonPages =
that
> > > are referenced from multiple processes?
> >
> > Regular files.. they get allocated through __page_cache_alloc(). AFAIK
> > there is nothing stopping people from pinning file pages for RDMA or
> > other purposes. Unusual maybe, but certainly not impossible, and
> > therefore we must be able to handle it.
>=20
> Typically structures for RDMA are allocated on the heap.

Sure, typically. But that's not enough.

> The main use case is pinnning the executable pages in the page cache?

No.. although that's one of the things the -rt people are interested in.

> > > Migration is expensive and the memory registration overhead already
> > > causes lots of complaints.
> >
> > Sure, but first to the simple thing, then if its a problem do something
> > else.
>=20
> I thought the main issue here were the pinning of IB/RDMA buffers.

It is,.. but you have to deal with the generic case before you go off
doing specific things.

You're approaching the problem from the wrong way; first make it such
that everything works, only then, optimize some specific case, if and
when it becomes important.

Don't start by only looking at the one specific case you're interested
in and forget about everything else.



--rwwPlZPbpBX9O0Yk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJThX7JAAoJEHZH4aRLwOS6tRkQAINtgJGCOtIztBNH+RRHXwCG
UZg0rfSYPK5QMpzJ31+Yemlgr1B2+VIu8tHNb5uM0u0qTinNuOdIYqygSoc7WbRl
7F3adXn96uWg75gsE7iZqMbXnKpiQdnFDnY5laPOpwsgyKLyhJqrDR3zDhnPLQYm
gmSrLI1c+RK+2EvQDd0q5Zo8LsyJASIHwQD1zwtcZq3slcVVPw/ACHdik+6xf9b1
X6DRCIPO5HZALRQrkz0b1I1MBlxVR0uW7YC30UkEHuNecQNcRAhXDN3Q9b75cU87
zBKEx+et/EhKatiAOQ933qkfsXniYCErParBieUraRJ6+vAQ/oBbjXopkRWUW6ll
gwLKTba4N+xIpb/y1zys09d2skNOoQIcZ5PIndRrm3m0qW4kPKuc32Lzkck5I44+
Lz9jCqQlPaFqAaL6+1+NxxYI+ENiE3QjjdUh4bkGpUzMaLjZUdOlc8DnYppz3FOW
Aw6S5PUuYVPYrII0jKDT/q2h/N+vlkQOAYSdaScy1at4kUpMEQyyDlgrvmdN4X1s
UsuFwrAVaToP1PqsQ6zE2RgDyFC4lqwwJagRoMzlCEhc0x/ZitfY5xbT9zjTKUW9
LPp4bGSoADpPp+kaohtgyQ/sJ+HDuWLMzBGKJX4UPMPfMECiFa7r8iTbWpA6FGuz
Y2iEJ6RABKEh8fkjD3Xm
=n8kK
-----END PGP SIGNATURE-----

--rwwPlZPbpBX9O0Yk--
