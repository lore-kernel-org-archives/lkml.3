Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760588AbaGYOP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 10:15:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:47912 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760534AbaGYOP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:15:56 -0400
Date: Fri, 25 Jul 2014 16:15:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Michael Neuling <mikey@neuling.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Turner <pjt@google.com>, jhladky@redhat.com, ktkhai@parallels.com,
        tim.c.chen@linux.intel.com, Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [PATCH] sched: make update_sd_pick_busiest return true on a
 busier sd
Message-ID: <20140725141542.GO19379@twins.programming.kicks-ass.net>
References: <20140722144559.382c5243@annuminas.surriel.com>
 <CAKfTPtDdAzZcMA5bJvhyrdH9J1F69jMy5q3w5xc4t+PSKPQ0eA@mail.gmail.com>
 <53D26383.60707@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Z69j+eHnjCacKfbR"
Content-Disposition: inline
In-Reply-To: <53D26383.60707@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Z69j+eHnjCacKfbR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 25, 2014 at 10:02:43AM -0400, Rik van Riel wrote:
> On a related note, that part of the load balancing code probably
> needs to be rewritten to deal with unequal group_capacity_factors
> anyway.
>=20
> Say that one group has a group_capacity_factor twice that of
> another group.
>=20
> The group with the smaller group_capacity_factor is overloaded
> by a factor 1.3. The larger group is loaded by a factor 0.8.
> This means the larger group has a higher load than the first
> group, and the current code in update_sd_pick_busiest will
> not select the overloaded group as the busiest one, due to not
> scaling load with the capacity...
>=20
> static bool update_sd_pick_busiest(struct lb_env *env,
>                                    struct sd_lb_stats *sds,
>                                    struct sched_group *sg,
>                                    struct sg_lb_stats *sgs)
> {
>         if (sgs->avg_load <=3D sds->busiest_stat.avg_load)
>                 return false;
>=20
> I believe we may need to factor the group_capacity_factor
> into this calculation, in order to properly identify which
> group is busiest.

(sorry, going through this backwards, I'll get to the actual patch in a
bit)

Note how update_sg_lb_stats() where we compute sgs->avg_load we do
divide by sgs->group_capacity.

(also, curse this renaming of stuff)

The group_capacity_factor is something ugly and Vincent was going to
poke at that.

--Z69j+eHnjCacKfbR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT0maOAAoJEHZH4aRLwOS6XwQP/3rVAkBxOgGMdiYXGSesolh5
d2abrarq2vc6mqN82CqTRMri4+x5shCHUH4Ns+ojpTACcY1inzWl/4UMKOkkJogL
P0l0+Zh//z9/6zMDE5Y9kmYtFEGqXPuGkO1QjsZmx9nZazVfsTYLGIwBn+LThA3h
bOkqOTMmMPcw7YUAUbYkEdY8vdJ6+7nvhyEvKi+3+DbJdYdwH4jmNmYMP4W7npPD
DMuAkL+V0h0HHsoTHecJM9g8Pt0RycYAcB3dAiSAse6mc1biyt254YR1fBTun2sm
oe7hyMFXug73SQMRYaY7zC4uIT+X/efagE0RQWfsk2F7MbA3S4kWHJPElYfX+u1f
Z6AgweQwRw4RQv7rcHVWrYRr/xfag0OIxLjeQfeE5ciV2hVWWJyKJH05e99a6ePx
V8J/RKX4ZOrEVCWyrhPcPUX9hW7cJg1Yl5QLbvbXVzygKGHXsq0ApiVV5IGDAVDk
3RorPiOtOitmT0gfwFZAmwr4XA+FM7r0FUd3pbXnDYA3Z2wrwC9rx1amr1Wqz/b9
Fd+x/PkDvGAl+CG4kyJN/1oQj+60oOFcU9p1UmmHqclhtDcg/X29QmBWR1QNw6bS
Hd1RY06fOF5e+l0h4/kfc+Q2JF6BLeTejxfSQKC6foN/JEkjlsSg99b5AijaVqSg
BB0KpH0cy99sW1qZJdtl
=ed+X
-----END PGP SIGNATURE-----

--Z69j+eHnjCacKfbR--
