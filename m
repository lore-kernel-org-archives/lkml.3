Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300AbaE3GeR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 02:34:17 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43225 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbaE3GeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 02:34:15 -0400
Date: Fri, 30 May 2014 08:34:02 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v2 11/11] sched: replace capacity by activity
Message-ID: <20140530063402.GB11096@twins.programming.kicks-ass.net>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-12-git-send-email-vincent.guittot@linaro.org>
 <20140529140204.GH11074@laptop.programming.kicks-ass.net>
 <CAKfTPtACXf+c01O+dCU2ZTc-Mrs+nTKYsu0_aBt8awxSg5WD=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PPcTO7KkkZ/DEnPS"
Content-Disposition: inline
In-Reply-To: <CAKfTPtACXf+c01O+dCU2ZTc-Mrs+nTKYsu0_aBt8awxSg5WD=g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PPcTO7KkkZ/DEnPS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 29, 2014 at 09:56:24PM +0200, Vincent Guittot wrote:
> On 29 May 2014 16:02, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Fri, May 23, 2014 at 05:53:05PM +0200, Vincent Guittot wrote:
> >> @@ -6052,8 +6006,8 @@ static inline void update_sd_lb_stats(struct lb_=
env *env, struct sd_lb_stats *sd
> >>                * with a large weight task outweighs the tasks on the s=
ystem).
> >>                */
> >>               if (prefer_sibling && sds->local &&
> >> -                 sds->local_stat.group_has_capacity)
> >> -                     sgs->group_capacity =3D min(sgs->group_capacity,=
 1U);
> >> +                 sds->local_stat.group_capacity > 0)
> >> +                     sgs->group_capacity =3D min(sgs->group_capacity,=
 1L);
> >>
> >>               if (update_sd_pick_busiest(env, sds, sg, sgs)) {
> >>                       sds->busiest =3D sg;
> >> @@ -6228,7 +6182,7 @@ static inline void calculate_imbalance(struct lb=
_env *env, struct sd_lb_stats *s
> >>                * have to drop below capacity to reach cpu-load equilib=
rium.
> >>                */
> >>               load_above_capacity =3D
> >> -                     (busiest->sum_nr_running - busiest->group_capaci=
ty);
> >> +                     (busiest->sum_nr_running - busiest->group_weight=
);
> >>
> >>               load_above_capacity *=3D (SCHED_LOAD_SCALE * SCHED_POWER=
_SCALE);
> >>               load_above_capacity /=3D busiest->group_power;
> >
> > I think you just broke PREFER_SIBLING here..
>=20
> you mean by replacing the capacity which was reflecting the number of
> core for SMT by the group_weight ?

Right to in the first hunk we lower group_capacity to 1 when prefer_sibling,
then in the second hunk, you replace that group_capacity usage with
group_weight.

With the end result that prefer_sibling is now ineffective.

That said, I fudged the prefer_sibling usage into the capacity logic,
mostly because I could and it was already how the SMT stuff was working.
But there is no reason we should continue to intertwine these two
things.

So I think it would be good to have a patch that implements
prefer_sibling on nr_running separate from the existing capacity bits,
and then convert the remaining capacity bits to utilization (or activity
or whatever you did call it, see Morton's comments etc.).



--PPcTO7KkkZ/DEnPS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTiCZaAAoJEHZH4aRLwOS68ukP/RMuhl0AYELgaRJVg/ByQcZT
9NpmPwjagVpGtjykYl6fz83In2IpM2+2+nURydh4LqjgxxGhoOmTK/RqTpLyvsl6
vdut8LKHU7wOfZHPLQn2uip0evShSHXhxVDE7ZXxwhUxHGGOr6jfHNRcxtBkCP7r
U54ERxHlu43SW5sdyGayOOwyBxJacO3HEcIWqB/LtSfsvC49nn0IR4u3+EfwmbWN
j8+GqNE9EvE3+0/shRRnSDyWMOpNWVKOflpT9PNn7osngYJ0e2BeIGsHkOkwU96d
3ptShz57N+CF9HoGoLBM0Ks8IjZ5AhFyRqXgNopdzKRgin8UJOEGRwokm1V/WqNU
lyHqkIPScpXGmn8jwh1VcEEaQO0yjD6FVapD065Qb1jbgtp+XCo6RXBO6sf73io6
qsypZTA8IJW9W2FI7wMmR7aNGbtS9PHidpuZsR5IkjiDolJzlrBJMfVEp8MYWEVN
swMO3H3Nx5UyBrN8psB/Owsdc0V4TQjFxoCfFB2SWWMGXmZDf+rNuyFO/7adJKMr
JeEKsf2a+/T5ILsfim1yPDuPXOylLvt2ELr5GZzNSzd8vPdxEJNzYy/QFw0FX45f
LmhJT2Hfr/AsJ43ThqEmy+XHyN4/Ke+d+IHe4ZpHnK/iGOxvbrcZC8v1lG28xyRE
zlVejxzBSx9+SoJ9eNbf
=eYIM
-----END PGP SIGNATURE-----

--PPcTO7KkkZ/DEnPS--
