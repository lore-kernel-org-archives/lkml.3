Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263AbaGNQOy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:14:54 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52889 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593AbaGNQOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:14:46 -0400
Date: Mon, 14 Jul 2014 18:14:32 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "H. Peter Anvin" <hpa@zytor.com>,
        "David S.Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Chandramouli Narayanan <mouli@linux.intel.com>,
        Vinodh Gopal <vinodh.gopal@intel.com>,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 6/7] sched: add function nr_running_cpu to expose
 number of tasks running on cpu
Message-ID: <20140714161432.GC9918@twins.programming.kicks-ass.net>
References: <cover.1405074379.git.tim.c.chen@linux.intel.com>
 <1405110784.2970.655.camel@schen9-DESK>
 <20140714101611.GS9918@twins.programming.kicks-ass.net>
 <1405354214.2970.663.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x68wm+TSW4ddya8z"
Content-Disposition: inline
In-Reply-To: <1405354214.2970.663.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x68wm+TSW4ddya8z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2014 at 09:10:14AM -0700, Tim Chen wrote:
> On Mon, 2014-07-14 at 12:16 +0200, Peter Zijlstra wrote:
> > On Fri, Jul 11, 2014 at 01:33:04PM -0700, Tim Chen wrote:
> > > This function will help a thread decide if it wants to to do work
> > > that can be delayed, to accumulate more tasks for more efficient
> > > batch processing later.
> > >=20
> > > However, if no other tasks are running on the cpu, it can take
> > > advantgae of the available cpu cycles to complete the tasks
> > > for immediate processing to minimize delay, otherwise it will yield.
> >=20
> > Ugh.. and ignore topology and everything else.
> >=20
> > Yet another scheduler on top of the scheduler.
> >=20
> > We have the padata muck, also only ever used by crypto.
> > We have the workqueue nonsense, used all over the place
> > And we have btrfs doing their own padata like muck.
> > And I'm sure there's at least one more out there, just because.
> >=20
> > Why do we want yet another thing?
> >=20
> > I'm inclined to go NAK and get people to reduce the amount of async
> > queueing and processing crap.
>=20
> The mult-buffer class of crypto algorithms is by nature
> asynchronous.  The algorithm gathers several crypto jobs, and
> put the buffer from each job in a data lane of the SIMD register.
> This allows for parallel processing and increases throughput.
> The gathering of the crypto jobs is an async process and
> queuing is necessary for this class of algorithm.

How is that related to me saying we've got too much of this crap
already?

--x68wm+TSW4ddya8z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTxAHoAAoJEHZH4aRLwOS6EXgP/i+QWEn6kbUfplinLxpOjKFD
iw19gBD0G4tV64PYFzB20CxQXLCgOYfyBv7nqH04mPz6MRK2jr41OP27J2CZZJp/
XzBvCdSPxK/d3FnVTNl5TsWRT791RgMN0XT1CGubN89WEF4cp1IpBfluQyo5LHxL
3Js8q0aJb//+THqMYv2GPdkknMM3jQ9Pg2NnvlyG95SHCm7AqlGuKK6o6s6Kr2af
1EdVBEgoW0XwjD6fGlzugjyH4ubC7Sz/QAgzzOZ3lwoZPlUgkkppaPQm57joSFhk
dVICGvEwnYsbxVWbTtYKoe5rFsrYHMw1GNY3o2iNUZWee5HRGsfxP4igJFIjGiFM
NIacxFpygG7hPiQGj1UkfZZKA6tlssMwTI5sfguOnC2uTKmcXtuOBjwKORes9r0P
YCFKN6P94rPmh/wyFcJRet6OWV3O46X7WcTWsM2MgKpF6Oj7ESS2CJm05KPPoUN7
++v+mcO6Ow91vI8UGy7nHiiGdn/tnHd0FwrPVxm0ea93VEXqKMFHkhJwmCnZX26Q
4xPzSY0T9OJR/f4nijQaa09e+LNyNxN3EP56Vs3Ow/8mQjyGzTZ6ItiaDm4ZtwDW
YYsHg39qHI7VHi3ywQ8/sCQ7qn64iRcSPZfLgE+xy35oi0dz/yLGoOKSPGhegwYp
G4V9MPcXzcl4/y5oDdWj
=qyPQ
-----END PGP SIGNATURE-----

--x68wm+TSW4ddya8z--
