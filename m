Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbaGNQXM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:23:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:53031 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690AbaGNQXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:23:00 -0400
Date: Mon, 14 Jul 2014 18:22:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>
Subject: Re: [PATCH v3 09/12] Revert "sched: Put rq's sched_avg under
 CONFIG_FAIR_GROUP_SCHED"
Message-ID: <20140714162249.GE9918@twins.programming.kicks-ass.net>
References: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org>
 <1404144343-18720-10-git-send-email-vincent.guittot@linaro.org>
 <20140710131646.GB3935@laptop>
 <CAKfTPtDzxyrzVmX016VB8j_y19wcCBVB1Rj46FYngMA+Ajft6g@mail.gmail.com>
 <20140711151304.GD3935@laptop>
 <CAKfTPtCL6mta75k9eoK724wCm7S3w7E+psa1XDrxhN1YVDONPw@mail.gmail.com>
 <20140711201238.GY20603@laptop.programming.kicks-ass.net>
 <20140714125529.GN26542@e103034-lin>
 <20140714132052.GY9918@twins.programming.kicks-ass.net>
 <20140714140435.GO26542@e103034-lin>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BVXm2WAry1WzRMtx"
Content-Disposition: inline
In-Reply-To: <20140714140435.GO26542@e103034-lin>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BVXm2WAry1WzRMtx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2014 at 03:04:35PM +0100, Morten Rasmussen wrote:
> > I'm struggling to fully grasp your intent. We need DVFS like accounting
> > for sure, and that means a current freq hook, but I'm not entirely sure
> > how that relates to capacity.
>=20
> We can abstract all the factors that affect current compute capacity
> (frequency, P-states, big.LITTLE,...) in the scheduler by having
> something like capacity_{cur,avail} to tell us how much capacity does a
> particular cpu have in its current state. Assuming that implement scale
> invariance for entity load tracking (we are working on that), we can
> directly compare task utilization with compute capacity for balancing
> decisions. For example, we can figure out how much spare capacity a cpu
> has in its current state by simply:
>=20
> spare_capacity(cpu) =3D capacity_avail(cpu) - \sum_{tasks(cpu)}^{t} util(=
t)
>=20
> If you put more than spare_capacity(cpu) worth of task utilization on
> the cpu, you will cause the cpu (and any affected cpus) to change
> P-state and potentially be less energy-efficient.
>=20
> Does that make any sense?
>=20
> Instead of dealing with frequencies directly in the scheduler code, we
> can abstract it by just having scalable compute capacity.

Ah, ok. Same thing then.

> > But yes, for application the tipping point is u =3D=3D 1, up until that
> > point pure utilization makes sense, after that our runnable_avg makes
> > more sense.
>=20
> Agreed.
>=20
> If you really care about latency/performance you might be interested in
> comparing running_avg and runnable_avg even for u < 1. If the
> running_avg/runnable_avg ratio is significantly less than one, tasks are
> waiting on the rq to be scheduled.

Indeed, that gives a measure of queueing.

--BVXm2WAry1WzRMtx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTxAPZAAoJEHZH4aRLwOS6PQ0QAJT9jlhUeqG6w6PeiT+pgkVP
NqsczYDvIdiRIjZgFAdIwq1Xpf+Q7EIxZ42ydo0j8vYiKVjIFBMtaAyMxDoeqe85
yPvLVCQl2x35G7SWYBczILX7Qw1uuJOeCgtp/jvHhe9RuxZOozDdSDfjlPLavj+I
ZLXVwEYEAsayMLZhb5ezlHOr1ewt9JhgtxSBd03hkM2KKQFb1Ipzn+QLycGWJTcs
/Tw2V+W1BPKwNRSBC1sAS++Fq6FAQT63qgySuhj3xQ6fnKDtWcTBZQ7HAz75BuDf
WbUhbTHV1WTJxJBy/woeCUzi4Qd4g+NgrsfXhhclZ+uARpjhnNsiFWPBeKw4r8VV
L5Cua1qRp1YqRRAf9bGEdWRniNX+WDsMGOGJL1WW1YO2NYqLxYQaluL1bZ+6YCGY
zs1wr7zCXA8UVs8BzNoP4lySKgRglfhgojQ496DUItF4/HwTdMkW21tU/g6AgPoZ
TtLUdmphjhRWDDAV82Tsm1qPLFW/LvRmalD+XvFYQv+nGKtuY2j0XyPlDa3GmR9u
ZeQYZhl4jTHkzMe42sOvovVw2rjrZQWmX1ZZjWLX6Zd2AvlcFPDEfR3OMY9MKn5A
DeYECsCehXx6msvJyV15jyG/6uw6Y1UGROHeYexyp2zaiH/IVzpZyaoeVd7Duk8U
eVJ2bxuXJtuR/B9tsfFH
=OTva
-----END PGP SIGNATURE-----

--BVXm2WAry1WzRMtx--
