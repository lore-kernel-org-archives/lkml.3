Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040AbaFDQEB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 12:04:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:47472 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbaFDQD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 12:03:59 -0400
Date: Wed, 4 Jun 2014 18:03:51 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, nicolas.pitre@linaro.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] sched,idle: Clear polling before descheduling the
 idle thread
Message-ID: <20140604160351.GP30445@twins.programming.kicks-ass.net>
References: <cover.1401841482.git.luto@amacapital.net>
 <ad9dcf321a5b74e72a1b63a0d59c8ddc68509c0f.1401841482.git.luto@amacapital.net>
 <20140604074416.GH30445@twins.programming.kicks-ass.net>
 <CALCETrV3EQg0t_nvBZcsPKXiT2mrkDd_8AbVkJ=vADSToc6bKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rEeQd2vQToB/m911"
Content-Disposition: inline
In-Reply-To: <CALCETrV3EQg0t_nvBZcsPKXiT2mrkDd_8AbVkJ=vADSToc6bKg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rEeQd2vQToB/m911
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 04, 2014 at 07:57:07AM -0700, Andy Lutomirski wrote:
> On Wed, Jun 4, 2014 at 12:44 AM, Peter Zijlstra <peterz@infradead.org> wr=
ote:
> > On Tue, Jun 03, 2014 at 05:29:50PM -0700, Andy Lutomirski wrote:
> >> Currently, the only real guarantee provided by the polling bit is
> >> that, if you hold rq->lock and the polling bit is set, then you can
> >> set need_resched to force a reschedule.
> >>
> >> The only reason the lock is needed is that the idle thread might not
> >> be running at all when setting its need_resched bit, and rq->lock
> >> keeps it pinned.
> >>
> >> This is easy to fix: just clear the polling bit before scheduling.
> >> Now the polling bit is only ever set when rq->curr =3D=3D rq->idle.
> >
> > Yah, except of course:
> >
> >   lkml.kernel.org/r/20131120162736.508462614@infradead.org
>=20
> Wow, that code was ugly.
>=20
> Can you be persuaded to hold off on that patch until after this series
> is done?  I think the cpu_startup_entry change will just muddy the
> waters for now.

Sure, no problem with that.

> > which I really need to rebase and post again :/
> >
> > In any case, this is useful even with that, although then we really must
> > do something like:
> >
> >   rcu_read_lock();
> >   if (!set_nr_if_polling(rq->curr))
> >         smp_send_reschedule(rq->cpu);
> >   rcu_read_unlock();
> >
> > Because there's other tasks than rq->idle which might be 'idle', joy!
>=20
> Is this really a problem?
>=20
> It's certainly the case that a non-idle (in the sense of !=3D rq->idle)
> task can have the polling bit set, but so what?  I'm perfectly happy
> to wake these ersatz idle things via IPI instead of via
> TIF_NEED_RESCHED.  I think that all of the code that plays with the
> polling bit after all these patches are applied either holds rq->lock
> (which prevents the task from going away) or acts directly on
> rq->idle, which really has no business being deallocated.
>=20
> I think that the RCU solution is actually racy, too.  Consider:

Indeed, ok so since I really hate the idle injection crap anyhow, I
don't particularly care if we send them extra IPIs if that means we get
extra pain for the sane case.

So I'll drop that part of the rebased patch and we'll focus on rq->idle.



--rEeQd2vQToB/m911
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTj0NiAAoJEHZH4aRLwOS6KWEP+QFv09ul+fvnwhg68gmRHo/v
sSibDiSF6prKuQbN0+i/AwoO4oVAYa0xZqP+3ae+euvd5hqkayy273o89H0H9kq9
s0WZOVMHTM+M6o8o3uvR0Z8y1GOnZ/JaSNOnTAhRch5CEN+S42sl+HaLKWMUTduK
waSW1EcN9LwSFVhHFM7BDJa2TBMfU4oL26Tj85v3EfwbsCMvzV9wGc4iC1IQE4y1
GOQQxDJeiZGzvTPjmuQb+1/LcgyLiST89Ha6EOOu1+ViwcHB0+okKlju+8bDJFSF
lZmRmxJ08+1y7Gsft0yED2rfxQiOFJfauOycoldgK4Qw33J55iYEbS/qLOKO1Dy9
hO067k9BXQ40oHI4OeVvfCjelr+0lozsd4XsgdabmxISJLG3CsAaorxynCwCil+b
TcGLMVPLXDBc5+GExm2Y8RwzT3CuhCOoOhu3+KeTcxb5i8vCrt7L5r3dYiDWoCyD
3OdrkoSZ2xU1wxtEuB/WZUAWqDAhEQAGsdvLrnxeLvZ+eaPXqNihkfndbeqgeT/n
wEhjN0X3aaOgxpz5hqMruKyhgsHxTNZ2bh0nFIUFqU2mPZN6w5/M0pjgAxXpaH1c
YXRRHBOMzp4373B48hzfMrXe5KoBEblgwMld8sdpB9mdBQhnyeLw9LojhMofkJHM
sdt/tpVimdX/UQnn9owd
=7Ptd
-----END PGP SIGNATURE-----

--rEeQd2vQToB/m911--
