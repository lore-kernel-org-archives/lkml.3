Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaFFKus (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 06:50:48 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54443 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbaFFKuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 06:50:46 -0400
Date: Fri, 6 Jun 2014 12:50:36 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Yuyang Du <yuyang.du@intel.com>
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>, len.brown@intel.com,
        jacob.jun.pan@linux.intel.com
Subject: Re: [RFC PATCH 06/16] arm: topology: Define TC2 sched energy and
 provide it to scheduler
Message-ID: <20140606105036.GQ3213@twins.programming.kicks-ass.net>
References: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
 <20140604160230.GS29593@e103034-lin>
 <20140604172712.GJ13930@laptop.programming.kicks-ass.net>
 <2484761.vkWavnsDx3@vostro.rjw.lan>
 <20140605065205.GA3213@twins.programming.kicks-ass.net>
 <539086B3.2010804@gmail.com>
 <20140605202930.GA15484@intel.com>
 <20140606080543.GR6758@twins.programming.kicks-ass.net>
 <20140606003520.GB22261@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SlnaBQtdWG0gYnqZ"
Content-Disposition: inline
In-Reply-To: <20140606003520.GB22261@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SlnaBQtdWG0gYnqZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 06, 2014 at 08:35:21AM +0800, Yuyang Du wrote:

> > > Actually, silicon supports indepdent non-Turbo pstate, but just not e=
nabled.
> >=20
> > Then it doesn't exist, so no point in mentioning it.
> >=20
>=20
> Well, things actually get more complicated. Not-enabled is for Core. For =
Atom
> Baytrail, each core indeed can operate on difference frequency. I am not =
sure for
> Xeon, :)

Yes, I understand Atom is an entirely different thing.

> > So frequency isn't _that_ interesting, voltage is. And while
> > predictability it might be their assumption, is it actually true? I
> > mean, there's really nothing else except to assume that, if its not you
> > can't do anything at all, so you _have_ to assume this.
> >=20
> > But again, is the assumption true? Or just happy thoughts in an attempt
> > to do something.
>=20
> Voltage is combined with frequency, roughly, voltage is proportional
> to freuquecy, so roughly, power is proportionaly to voltage^3. You

P ~ V^2, last time I checked.

> can't say which is more important, or there is no reason to raise
> voltage without raising frequency.

Well, some chips have far fewer voltage steps than freq steps; or,
differently put, they have multiple freq steps for a single voltage
level.

And since the power (Watts) is proportional to Voltage squared, its the
biggest term.

If you have a distinct voltage level for each freq, it all doesn't
matter.

> If only one word to say: true of false, it is true. Because given any
> fixed workload, I can't see why performance would be worse if
> frequency is higher.

Well, our work here is to redefine performance as performance/watt. So
running at higher frequency (and thus likely higher voltage) is a
definite performance decrease in that sense.

> The reality as opposed to the assumption is in two-fold:
> 1) if workload is CPU bound, performance scales with frequency absolutely=
=2E if workload is
>    memory bound, it does not scale. But from kernel, we don't know whethe=
r it is CPU bound
>    or not (or it is hard to know). uArch statistics can model that.

Well, we could know for a number of archs, its just that these
statistics are expensive to track.

Also, lowering P-state is 'fine', as long as you can 'guarantee' you
don't loose IPC performance, since running at lower voltage for the same
IPC is actually better IPC/watt than estimated.

But what was said earlier is that P-state is a lower limit, not a higher
limit. In that case the core can run at higher voltage and the estimate
is just plain wrong.

> But still, the assumption is a must or no guilty, because we adjust
> frequency continuously, for example, if the workload is fixed, and if
> the performance does not scale with freq we stop increasing frequency.
> So a good frequency governor or driver should and can continuously
> pursue "good" frequency with the changing workload. Therefore, in the
> long term, we will be better off.

Sure, but realize that we must fully understand this governor and
integrate it in the scheduler if we're to attain the goal of IPC/watt
optimized scheduling behaviour.

So you (or rather Intel in general) will have to be very explicit on how
their stuff works and can no longer hide in some driver and do magic.
The same is true for all other vendors for that matter.

If you (vendors, not Yuyang in specific) do not want to play (and be
explicit and expose how your hardware functions) then you simply will
not get power efficient scheduling full stop.

There's no rocks to hide under, no magic veils to hide behind. You tell
_in_public_ or you get nothing.

--SlnaBQtdWG0gYnqZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTkZz8AAoJEHZH4aRLwOS6M/oQAK/ibsZQqle+YENY5GgUVeS6
WalaRkNzQL7YiiS7xfl93pLjOxEacJY5J4n5PC4bUSx6Aj3UvYEYTRzr8FHoLthj
vdHMtjDjSfYKaKgTsUS84rBCI5wmI0Jx6ZSOAG2EPqS9BeO4+PMiTYRA2S1Z8hr5
aEr/FcvJ69adWwK9/hNErZ1Sos9kcMYdfJV89ZWUmwyhkDCuyDcfVlXJuXIMlYty
gE+H1MD8z5FBTdfgPGftnrqKkuDPtXwBMd7wsAYuAd+c4Ajqgh+BfncP6jV1tyX5
6paR6xCnr6gV6QuwGFQFfviknrfWlWMCKINBweqlXta9OLpxcX9/kdGwZPTpo6fg
mPggHas+GU1wdcYtPyN4TPHO++O+MwmR3+bmqVuw0ZJD+Wcx9xNPSB05VN+60tHp
F/2pqwWFjA6pfqSObXSFxdv/Wvk/cdgqHBPSpXABPBKl/Aj5nZeUer8BUZipmt+j
vkMVqysA2zlpsMXZPdTwtx1zagsBw8kGuDsRL19yTpjPeQOzBwg4UNkXwvh+hqZn
ba8s5/NapZAGYynTANwypr4EhBFOBS3cR5LZCVyMqGEIz8/oDv00kIoh5Gy8P4b2
frNd5gFU+sctIjredOhyZD4CWRJRS4f1Nw1SI3CFBBElYNr2+oV+QfYmKFzOE04u
1zw1oKbN3lotC6OTHKSY
=bxOL
-----END PGP SIGNATURE-----

--SlnaBQtdWG0gYnqZ--
