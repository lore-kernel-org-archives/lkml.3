Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437AbaFDK4R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 06:56:17 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33479 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbaFDK4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 06:56:16 -0400
Date: Wed, 4 Jun 2014 12:55:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v2 08/11] sched: get CPU's activity statistic
Message-ID: <20140604105559.GM30445@twins.programming.kicks-ass.net>
References: <1400860385-14555-9-git-send-email-vincent.guittot@linaro.org>
 <20140528121001.GI19967@e103034-lin>
 <CAKfTPtDxeBfZK1AxCRqEG91pi--Ti1RYFoQPDhvMVnGTCspQ-g@mail.gmail.com>
 <20140528154703.GJ19967@e103034-lin>
 <20140603155007.GZ30445@twins.programming.kicks-ass.net>
 <CAKfTPtDUvH--WxFATTW6YRAvLuohzyNHDUq6DRdfxc7gRKCX6Q@mail.gmail.com>
 <20140604080809.GK30445@twins.programming.kicks-ass.net>
 <CAKfTPtBCG1Jq2b+fyoGuA=7yG_yUbsmaD+j-ZXXsPNGp5giKpg@mail.gmail.com>
 <20140604101724.GD11096@twins.programming.kicks-ass.net>
 <20140604103619.GL29593@e103034-lin>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+98kJABsJJfEIu48"
Content-Disposition: inline
In-Reply-To: <20140604103619.GL29593@e103034-lin>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+98kJABsJJfEIu48
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 04, 2014 at 11:36:19AM +0100, Morten Rasmussen wrote:
> On Wed, Jun 04, 2014 at 11:17:24AM +0100, Peter Zijlstra wrote:
> > Let me explain the 75%, take any one of the above scenarios. Lets call
> > the two tasks A and B, and let for a moment assume A always wins and
> > runs first, and then B.
> >=20
> > So A will be runnable for 25%, B otoh will be runnable the entire time A
> > is actually running plus its own running time, giving 50%. Together that
> > makes 75%.
> >=20
> > If you release the assumption that A runs first, but instead assume they
> > equally win the first execution, you get them averaging at 37.5% each,
> > which combined will still give 75%.
>=20
> But that is assuming that the first task gets to run to completion of it
> busy period. If it uses up its sched_slice and we switch to the other
> tasks, they both get to wait.
>=20
> For example, if the sched_slice is 5 ms and the busy period is 10 ms,
> the execution pattern would be: A, B, A, B, idle, ... In that case A is
> runnable for 15 ms and B is for 20 ms. Assuming that the overall period
> is 40 ms, the A runnable is 37.5% and B is 50%.

Indeed, with preemption added you can pull this out further. You can
then indeed get infinitesimally close to 100% with this.

--+98kJABsJJfEIu48
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjvs/AAoJEHZH4aRLwOS6B4sP/3bl+05y5p8t1P4nGnrS8dK3
6IQYM1Hy/p6UAjvjA21k5XHF9Ci+wq1C4BUWcB009jKoFiWwUwxUQLIgU+q3g80U
DeeLslYn0wGCBGYCq9LglLHhjQtvSKzSpk7LZACA6Oqyj3XDdraIkt3naxbkO5+q
O76EIflfrN0yW4k/Fi2vV0uEWlk5eIxAIY4H5XAQ76sXdeJclY1sBYettI/sGfqH
NFpOpt8cvde3+qtTpc1mQqqD230IFdF40k9M6e7t9BVEiqwbyFKaPwbVZ2ZQEMn+
yaboco/sAr73lj6pPuYKQi/F23rWf6z+bVy4qoiY4W5EMwJ33bRsZfFMwJ9aoHYT
PaKaJ5mdmxKzOVw0CDL2aOBflt1DZP2fgHiuZkMCBwOQwK6e3Cjx9uKDSsm1EJ+o
JJTKA+bbewi4dAmdjWKNscvZ86cV3Lwd+s6WdRn+PDHHrrEXZV26K7vI9WY4U53j
l8h5uSJpxlFPLZs2uJHou2dH4Oqq5RcNChJhDqgxd71esQOrb5hruQ1ZYKcE7mDy
grFaG//+ekK44IKmueWziIDZ46gE0VV1jNwN9Gm8w3PYtmfYtSY5SPAo6CNkRMLX
AUrVQ79sVU/U2QZ7tkcgB0mwtfgWCTvUa5iC6bmknXE+kcX2JBr4FurYsEgl6RDD
Ae02LSjdtdvbxi2ZfSTT
=tPgu
-----END PGP SIGNATURE-----

--+98kJABsJJfEIu48--
