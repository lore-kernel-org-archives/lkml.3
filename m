Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933823AbaFCRA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 13:00:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:42546 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933133AbaFCRAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 13:00:25 -0400
Date: Tue, 3 Jun 2014 19:00:18 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        nicolas.pitre@linaro.org, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 0/8] sched,idle: need resched polling rework
Message-ID: <20140603170018.GD30445@twins.programming.kicks-ass.net>
References: <20140522125818.GV30445@twins.programming.kicks-ass.net>
 <20140522130931.GV13658@twins.programming.kicks-ass.net>
 <CALCETrVBVOjs0EVqEz3qKtSHQg1agJzAyG4Ohqueky-zPF7uKA@mail.gmail.com>
 <20140529064827.GI19143@laptop.programming.kicks-ass.net>
 <CALCETrWnG7fSuinDv+GAHsnTLJ-6xn+_1LB2XdLGVXcC=TQURA@mail.gmail.com>
 <20140603104347.GT11096@twins.programming.kicks-ass.net>
 <20140603140223.GA13658@twins.programming.kicks-ass.net>
 <CALCETrW3cr_RLnMeMtutM5H+3cJSerUxXuEmiT9miDOEmkpANw@mail.gmail.com>
 <20140603161950.GB30445@twins.programming.kicks-ass.net>
 <CALCETrWOrYTK01ev34mP+5iyeBWw14u+3n4fg0+O5Zp9oPQ+3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mmNGG5QdSOy2YTWF"
Content-Disposition: inline
In-Reply-To: <CALCETrWOrYTK01ev34mP+5iyeBWw14u+3n4fg0+O5Zp9oPQ+3g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mmNGG5QdSOy2YTWF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 03, 2014 at 09:52:22AM -0700, Andy Lutomirski wrote:
> > So you could cheat and set it in pick_next_task_idle() and clear in
> > put_prev_task_idle(), that way the entire idle loop, when running has it
> > set.
> >
>=20
> Isn't that a little late for sched_ttwu_pending?  I guess it could be
> okay, but I'm hesitant to muck around with the scheduler innards that
> much.  I don't see anything that'll break, though.

Yeah, only later did I see you clear much earlier, which makes sense.

> I'm seriously confused by the polling situation, though.
> TIF_NRFLAG_POLLING is defined for a whole bunch of architectures, but
> I can't find any actual polling idle code outside cpuidle and x86.

I think there's some in ppc somewhere, they poll a bit before doing the
idle hypercall.

> For example, arm defines TIF_POLLING_NRFLAG, but I can't find anything
> that clears the polling bit in the arm code.  Am I missing something
> obvious here?=20

It wasn't at all clear to a bunch of arch people wtf that flag was for
and so its got copy/pasted around.

When I recently broke the build with that fetch_or() thing some arch
folks piped up and we ended up removing the flag for arm64 and metag.

Which reminds me, I should probably write a comment somewhere explaining
this stuff.

> Is the whole point of this so that a wakeup that
> happens right after the idle task is scheduled but before it goes idle
> cancels idle and avoids an IPI?  This seems like a lot of complexity
> to avoid IPIs in a hopefully extremely narrow window.
>=20
> This is totally backwards for x86, but it seems to do the right thing
> for other architectures.  I'm not convinced it does any good, though.

Its all a bit confused.. back when tglx merged the idle loops we also
flipped the default state around, which didn't improve things.

In any case, I'm only aware of x86 mwait and the ppc amortize poll loop
and the generic poll loop.

That of course doesn't mean there isn't something hidden somewhere in
the 2x archs, but...

--mmNGG5QdSOy2YTWF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjf8iAAoJEHZH4aRLwOS6a/sP/3DHVz4bGrgkwHgGAMAsGVou
gv0DY1DqcHAJhsmSfen7gT29bwwfxwZkMcAdmg1km8g+TFwAExWwrR8F/7qVH2Po
2ikD6PrZ/mDbajgysETyjkatt0aOinbNCBJ4Jr26QfQWvy6Sjdm+uyFuQ5HNnnoa
uMsnZti+klwSVjQTnNAyXEGDJJeysr5qgowUtKbf+SKYvmmLmJBwQTqN+4HkirU1
AuqBVUTamDEvMr76JfuspZ/zF65rje1Uz8TYFeiAODKyTT3tn4auJIu0uqyeWAIA
dYVcG369AjF4nF3alS+MkFfjN6l0bmAnQpmIipaMdKo9CzaG440gVH0qk2p/T5Yb
/hAwJ9/dZQKoIYd7mFZQZlmIHvt4q/BxNaagpPXhl4eE2kNpxXIc3CiwbMkRin6H
v6gAqL0rGTN8MQxr0SGQPG9PtDfCgMlSczK78xnsHfoLac3IlT6odBIvOdhvqVEW
D9JLdlXmtqOO4KY5ALGhGeBQTJpq+4VmWx/qosOJqjj05h6wkFmdzZJP4M6VO/jm
D8KLh5+I+EPyPgYuNiXLcn1iYvTeki4iemdIkNGXeKjgm6Zuyk+plvLqBPyU1UlP
HSXIx0yLvfiL0crKcInbvWJoYB7WdGdbwzyluneYDXWk25pttSQeis+bhFO98S8k
BV0Ixd5dDjREyyvUTGTx
=n7NW
-----END PGP SIGNATURE-----

--mmNGG5QdSOy2YTWF--
