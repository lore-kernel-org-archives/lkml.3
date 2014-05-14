Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685AbaENMzZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 08:55:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:49330 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893AbaENMzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 08:55:24 -0400
Date: Wed, 14 May 2014 14:55:15 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "xiaofeng.yan" <xiaofeng.yan@huawei.com>
Cc: Ingo Molnar <mingo@redhat.com>, duzhiping.du@huawei.com,
        xiaofeng.yan2012@gmail.com, juri.lelli@gmail.com, luca.abeni@unitn.it,
        raistlin@linux.it, henrik@austad.us, tkhai@yandex.ru,
        harald.gustafsson@ericsson.com, linux-kernel@vger.kernel.org
Subject: Re: [RFD] sched/deadline: EDF dynamic quota design
Message-ID: <20140514125515.GK13658@twins.programming.kicks-ass.net>
References: <537348DA.7080001@huawei.com>
 <20140514113245.GZ11096@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKijDXBCEH69PxaN"
Content-Disposition: inline
In-Reply-To: <20140514113245.GZ11096@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gKijDXBCEH69PxaN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2014 at 01:32:45PM +0200, Peter Zijlstra wrote:
> On Wed, May 14, 2014 at 06:43:38PM +0800, xiaofeng.yan wrote:
> > Hi all,
> >=20
> > We design dynamic quota function based on current EDF schedule .
> > Wehave realized this dynamic quota design and get good performance in t=
he actual scene.
> > The impalement for this function is very strong connected with producti=
on line requirement.
> > In some implementations, the current design in product could be be acce=
pted by community,
> > such as beyond the total bandwidth limitations.
> > So we design some parts again.
> > If you want to review our current implements in product, I will send ou=
r patches and test result.
> > We hope to push it to the main line. Could you give me suggestion wheth=
er it can be accepted or not?
> > We will be very grateful for your suggestion.
>=20
> At the very least you could've Cc'ed the people who actually wrote the
> EDF stuff :-/

Also, Cc lkml, left the rest of the msg intact as clearly people haven't
had a copy yet.

> > The design principle is as follows:
> >=20
> >=20
> > ------------------EDF Dynamic Quota Design------------------
> >=20
> > * Current EDF defect
> >   EDF tasks' bandwidth is fixed currently. they could not adjust
> >   their quota whenever they are busy or idle.
> >=20
> > * The scene for dynamic quota
> >   Currently, we have the scenarios which need to adjust tasks'
> >   quota dynamically. Such as, the network's workload fluctuates when
> >   forwarding the packets, which results in imbalance. Busy task should
> >   increase quota, and idle task should reduce quota.
> >   It is beneficial to increase the processing ability of the business.
> >=20
> > * Dynamic quota idea
> >   We add the dynamic quota function based on current EDF schedule.
> >   The principle is as follows:
> >   The total bandwidth of EDF tasks is fixed during running.
> >   Idle tasks release left bandwidth to the global bandwidth pool, and
> >   busy tasks get some quota from the global pool.
> >=20
> > * Example.
> >   Three tasks: T1,T2,T3. Their initial status is as follows,
> >   T1(200us,500us,500us)
> >   T2(200us,500us,500us)
> >   T3(200us,500us,500us)
> >=20
> >   At time t1, the tasks' running status is as follows,
> >   T1(200us,500us,500us)
> >   T2(100us,500us,500us)
> >   T3(200us,500us,500us)
> >   Busy tasks: T1,T3
> >   Idle task:  T2
> >   Bandwidth pool: 20%
> >=20
> >   Now, there are 20% quota in the bandwidth pool, T1 or T3 get 5% quota
> >   (adjustable) from the bandwidth pool when they enter run-queue.
> >   Then, the status is as follows:
> >   T1(225us,500us,500us)
> >   T2(100us,500us,500us)
> >   T3(225us,500us,500us)
> >   Bandwidth pool: 10%
> >=20
> >   Busy tasks could get the quota when the bandwidth pool is not empty.
> >=20
> > -----------------------------------------------------------------------=
-----------------
>=20
> Yeah, not sure that's sound. But I'll leave that to others.
>=20
> So there have been papers on how if you transform the runtime into an
> avg the tardiness also turns into an avg and remains bounded.
>=20
> Now, you still have to guarantee your individual tasks respect the avg,
> otherwise the tardiness guarantees are out the window along with it.
>=20
> I've not thought through your proposal to see if it maintains this
> guarantee -- but seeing how you don't talk about guarantees at all I
> fear the worst.
>=20
> Another point is that 'avg' or 'dynamic' tasks should co-exist with the
> normal fixed runtime tasks (ideally) without affecting the performance
> of the normal tasks (too much).
>=20
> Your proposal also doesn't cover this.
>=20
> There have also been proposals to turn the CBS into a 'soft' CBS and
> instead of hard throttling allow the task to continue executing at a
> lower class (throttle in effect turns into a switch to SCHED_NORMAL, and
> unthrottle restores it to SCHED_DEADLINE).
>=20
>=20



--gKijDXBCEH69PxaN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTc2ezAAoJEHZH4aRLwOS6l/UQAJtgFaFJmMv/QTAap/MX9/Ps
GQowdX99qmsybagfHuNO9f+qbaat+SeHkAS1kJCHNkwFgKdTqmb4GRf87ns65INB
x/47LTxMsaZJfp6Cwpua5alGTUWwzPsyFNxcRGX5leowX8wH//rbjOm4IyY1+xYJ
Wli24/NkojSmtj+Sv4g70KNfkehKlpexED4E51el1BBfWtPScQiGP11GZLiJ6rts
4QcKduCYlSQCZUIGnyE7MCPaVL2A30Uc/y3lRoMFun+T/D8Lz8dS5GWqauOYePSG
v2Aci/MXOsXoE11IB8K6Z5HFcN5S+pGTiUNHmB6dRlJ351d3gVgnYefA4f0TpcQF
B6faVDbDvQANTNHqWgsjmzxa4yFxAnlZypLK3mVqWVrfEkkZd/Wl9WWNQ4UHScU6
yc3eGVyzg5qEwFt3poQ30ojbdrRUzTn1r8j1av9EVMX37zJXJfjRRvgPKs17xpXo
Xdbl8VjqWJmVXct4/1TzUTs0GDrXLSFT7gxWzmyeKjV/IR1u0e2kXMHISzDOB1Ym
kTE8onxl8+Ym7PFDvi6btd4JG1q5mOakrjEsdm6CjpDttReOZp6Y7iiPRilCXaa7
yjf/vDSnhwujQwEdxAbpTSeKfO74SRiKwiBO40COoBBQta/VRl++zWeMeHnT2nEk
pwjBBFTwrR+jlb4VgsBF
=oRG4
-----END PGP SIGNATURE-----

--gKijDXBCEH69PxaN--
