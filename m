Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbaFJMUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 08:20:13 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:45417 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbaFJMUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 08:20:11 -0400
Date: Tue, 10 Jun 2014 14:19:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Henrik Austad <henrik@austad.us>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>
Subject: Re: [RFC PATCH 02/16] sched: Introduce CONFIG_SCHED_ENERGY
Message-ID: <20140610121959.GF6758@twins.programming.kicks-ass.net>
References: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
 <1400869003-27769-3-git-send-email-morten.rasmussen@arm.com>
 <20140608060316.GA18179@austad.us>
 <20140609102027.GA29593@e103034-lin>
 <20140610093943.GA6758@twins.programming.kicks-ass.net>
 <20140610100641.GB1581@e103034-lin>
 <20140610102353.GC6758@twins.programming.kicks-ass.net>
 <20140610111732.GA30139@austad.us>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kb0TSCuX821Ar6UT"
Content-Disposition: inline
In-Reply-To: <20140610111732.GA30139@austad.us>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kb0TSCuX821Ar6UT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 10, 2014 at 01:17:32PM +0200, Henrik Austad wrote:
> On Tue, Jun 10, 2014 at 12:23:53PM +0200, Peter Zijlstra wrote:
> > On Tue, Jun 10, 2014 at 11:06:41AM +0100, Morten Rasmussen wrote:
> > > How would you like to disable the energy stuff for users for whom
> > > latency is everything?
> > >=20
> > > I mean, we are adding some extra load/utilization tracking. While I
> > > think we should do everything possible to minimize the overhead, I th=
ink
> > > it is unrealistic to assume that it will be zero. Is a some extra 'if
> > > (energy_enabled)' acceptable?
> > >=20
> > > I'm open for other suggestions.
> >=20
> > We have the jump-label stuff to do self modifying code ;-) The only
> > thing we need to be careful with is data-layout.
>=20
> Isn't this asking for trouble?
>=20
> I do get the point of not introducing more make-ifdeffery, but I'm not
> so sure the alternative is much better. Do we really want to spend time
> tracing down bugs introduced via a self-modifying process in something
> as central as the scheduler?

Its already chock full of that stuff ;-)

> > So I'm _hoping_ we can do all this without more CONFIG knobs, because
> > {PREEMPT*SMP*CGROUP^3*NUMA^2} is already entirely annoying to
> > build and run test, not to mention that distro builds will have no other
> > option than to enable everything anyhow.
>=20
> True, but if that is the argument, how is adding this as a dynamic thing
> any better, you still end up with a test-matrix of the same size?

Test-matrix yes, sadly so and there's nothing we can really do about
that, so that sucks.

But it does reduce the coverage of the tests; everything that is not
uber critical fast path we can do unconditionally. So all the
sched_domain wankery gets tested on every boot / hotplug event, which is
tons better than only when that particular option is build in.

So while the total test matrix does suck rocks, the actual code that
needs testing per option can be siginficantly reduced.

> Building a kernel isn't _that_ much work and it would make the
> test-scripts all the much simpler to maintain if we don't have to rely
> on some dynamic tweaking of the core.

its exponential, given that I now already have to build
PREEMPT*SMP*CGROUP^3*NUMA^2 =3D 2^7 =3D 128 kernels to cover all options,
adding one more option means I'll have to build another 128 kernels.
Building 128 kernels does take a lot of time, no matter how far you
strip that .config and no matter I can build a kernel in <50 seconds.

--kb0TSCuX821Ar6UT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTlvfvAAoJEHZH4aRLwOS6Vn0P/0OKzCGGF57UGdU1BU9BeA1p
HM44ZnzVPhC13s3gdTviqL5MWiKyITbmxuYouP+12Hn7Ez8ifjRMZf/l2dwAN44y
3fyC/y4yXKohauKq0cTvWiy1MK4HTAa8MmIuv2jhWDO3dApeeSYoV0yC1kusplEA
1O7HMHtMBb2sO6wIQbpBGs0sAsheKNX0kxczoC8hNf0M5RgaL7UvpC7U4quWhc+J
oAyV2DGrZdH1AEksInDkKMd/q4PjYPj+PevxmcBcDg2EWArzYYdLuLVsZJETsuCq
KpCF5gfVlcxIJ7H6LfWG9iKOi5nKFQbXcaRxBPpGctv2rr/jTqpgu5JmFnVIosvk
ryGYvONnzazl9L6X/rBtCL+YzOSHqTDMpvCoARktCsnyQhgpxZKdR0Of96ZpTTSe
RQc0JTuhgU7HJeuOcMjxkvUCgPD8DmyJ9TWc8VyEaRNwDq0kVsELFd9hOPr7DV9K
JRK3tobiBJUfcKFsRqZYdTBiC1I30YhilGak9E5HiyYNkJ3cJGzyZ/eXdjgexVnR
DzcdopJ5QqCyK/58hjIue4ONmQYEAnVQahWSGHrOMnShl0wQ4cCj19gWKIP/AbkN
1eEfs6VIQRSZbW7XoDXbDeDsGsk9JmbyCXdAybquN6Yx9GsofGRf6o2K5/YW1bR7
PTUYteuUIKMP24KaIahj
=i5l4
-----END PGP SIGNATURE-----

--kb0TSCuX821Ar6UT--
