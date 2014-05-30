Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137AbaE3G3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 02:29:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:51075 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbaE3G3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 02:29:46 -0400
Date: Fri, 30 May 2014 08:29:37 +0200
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
Subject: Re: [PATCH v2 10/11] sched: move cfs task on a CPU with higher
 capacity
Message-ID: <20140530062937.GA11096@twins.programming.kicks-ass.net>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-11-git-send-email-vincent.guittot@linaro.org>
 <20140529095024.GF11074@laptop.programming.kicks-ass.net>
 <CAKfTPtCHhxyugMOCeS0hZoEXWhgRec4uOBexZ2aB2A+Eycgi8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yEBrs0e8Ns0RDnuy"
Content-Disposition: inline
In-Reply-To: <CAKfTPtCHhxyugMOCeS0hZoEXWhgRec4uOBexZ2aB2A+Eycgi8w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yEBrs0e8Ns0RDnuy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 29, 2014 at 09:37:39PM +0200, Vincent Guittot wrote:
> On 29 May 2014 11:50, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Fri, May 23, 2014 at 05:53:04PM +0200, Vincent Guittot wrote:
> >> If the CPU is used for handling lot of IRQs, trig a load balance to ch=
eck if
> >> it's worth moving its tasks on another CPU that has more capacity
> >>
> >> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> >> ---
> >>  kernel/sched/fair.c | 13 +++++++++++++
> >>  1 file changed, 13 insertions(+)
> >>
> >> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> >> index e8a30f9..2501e49 100644
> >> --- a/kernel/sched/fair.c
> >> +++ b/kernel/sched/fair.c
> >> @@ -5948,6 +5948,13 @@ static bool update_sd_pick_busiest(struct lb_en=
v *env,
> >>       if (sgs->sum_nr_running > sgs->group_capacity)
> >>               return true;
> >>
> >> +     /*
> >> +      * The group capacity is reduced probably because of activity fr=
om other
> >> +      * sched class or interrupts which use part of the available cap=
acity
> >> +      */
> >> +     if ((sg->sgp->power_orig * 100) > (sgs->group_power * env->sd->i=
mbalance_pct))
> >> +             return true;
> >> +
> >>       if (sgs->group_imb)
> >>               return true;
> >>
> >
> > But we should already do this because the load numbers are scaled with
> > the power/capacity figures. If one CPU gets significant less time to run
> > fair tasks, its effective load would spike and it'd get to be selected
> > here anyway.
> >
> > Or am I missing something?
>=20
> The CPU could have been picked when the capacity becomes null (which
> occurred when the cpu_power goes below half the default
> SCHED_POWER_SCALE). And even after that, there were some conditions in
> find_busiest_group that was bypassing this busiest group

Could you detail those conditions? FWIW those make excellent Changelog
material.

--yEBrs0e8Ns0RDnuy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTiCVLAAoJEHZH4aRLwOS6uwoQAKX+7iWcKfs6o1uSMZreb9Lw
Op4ASKq6WzM1BqitfGdWYkzTCfxCr+07HCM8VoxuCafxqL8fS7ndY4QblaFpE5Yo
ylk8YyDNNfvE/o+LwRbANEhGGA6SdvU72LQK6fPKAMSyHj+iorE9P7nmH02TQlWF
Butz0XWVM4b/2nX+LvP8fngz8nTDVpH13mcU9/C5nUTmjtZbfYjGiDYFugC9zLiB
1bhzJWsyLdqzV8w497O/IDGu2t60g06YlWRGuoxAv3VGs0dDY76esmmvsVqZmbcm
P+PP8WqNtbH4JK00qzgZdmV6I7esDUUjZ0p4q3RU/1Y/stO00mM1HpEfRASc0hIe
kFLGN0kyKaDc+pv5K8FGEPc6hTnSU++JtzERKrlJFpV5ajh3O12KGMD4Qduzzgie
dNLfxkIIDlY1CMPqECDOSElKhSiDY6wqi84oZBv9jvt5ypuTVeNHlXI071UbdIAi
b2RJ+qepkkz4dIKEASHx5Dq19xfQpccG1SI4ymZALg66GFUaJ1ydVTw8Z5c+GLPi
+P0EswDgmKTHPVN9qETS87tPYMenE17SVyDi1XRyP3+AX34Ia/tlmbfqJbv8b7yu
tFGE2ynoHUXirpYe4YaXBtn02KW9fjz+AMe7S/Xwo/aWJVOMc1OjTABaspm/AyxG
kD7q8zrpEB4SiPEg9ta8
=UZsL
-----END PGP SIGNATURE-----

--yEBrs0e8Ns0RDnuy--
