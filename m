Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097AbaENMmB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 08:42:01 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:40161 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbaENMmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 08:42:00 -0400
Date: Wed, 14 May 2014 14:41:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 1/3] irq_work: Implement remote queueing
Message-ID: <20140514124150.GB11096@twins.programming.kicks-ass.net>
References: <1400019956-25511-1-git-send-email-fweisbec@gmail.com>
 <1400019956-25511-2-git-send-email-fweisbec@gmail.com>
 <20140514090629.GC30445@twins.programming.kicks-ass.net>
 <20140514113808.GA1278@localhost.localdomain>
 <20140514115406.GA11096@twins.programming.kicks-ass.net>
 <20140514121122.GC1278@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tez2gqrut5pn4jhH"
Content-Disposition: inline
In-Reply-To: <20140514121122.GC1278@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tez2gqrut5pn4jhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2014 at 02:11:25PM +0200, Frederic Weisbecker wrote:
> > I don't think it is, most apic calls do apic_wait_icr_idle() then the
> > apic op, if an NMI happens in between and writes to the APIC, the return
> > context will see a !idle icr and fail.
> >=20
> > This is why arch_irq_work_raise() again idles the icr after sending the
> > IPI.
> >=20
> > Also, I think, seeing what benh said earlier, its unsafe for other archs
> > too.
>=20
> Ah I don't know much these archs details, so I concede it.

Yeah, I didn't either, had to figure it out when someone asked WTH there
was an wait_icr_idle call in there.

> > Then do the remote irq_work_raised thing. But it really stinks you broke
> > this very nice and simple thing.
>=20
> I tried not to break boot with printk overhead. That said I've considered=
 having
> a very simple "tick work" that can rely on irq work when the tick is stop=
ped
> and use it for printk. That would restore the initial simplicity.

But but but.. did you even try without the lazy thing?

Don't fix what ain't broken, keep it simple, etc..

Anyway, if it turns out to really be needed, the split list doesn't
sound bad.

> > > Also note that nohz is the only user for now and irq_work_claim() thus
> > > prevents from double IPI. Of course if more users come up the issue a=
rise
> > > again.
> >=20
> > DANGER, half arsed engineering at work, seriously? Just write proper
> > code already.
> >=20
> > There's no fucking way the next user will check the implementation to
> > make sure its 'sane'.
>=20
> Are you competing with tglx on grumpiness? You guys are free to treat us
> like shit but don't be surprised if one day you'll be alone in kernel/*

There's really only so much nonsense one can take on any one day before
getting seriously grumpy.

And arguing that because there's only one user so we can skimp a core
function really tops the day.

So maybe I need a holiday, but shees.

--tez2gqrut5pn4jhH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTc2SOAAoJEHZH4aRLwOS6i5QP/Rukc4e4GB+wdmzbuB3lyN4U
5JP0xIVbZVfnOvyOBmFT4oYIYFMAgp+QrnqZwZEY9oNP7YOIfuhCrUMnat/ykRvc
lMdzumpdYEl7dUN5gWBXjlje6QkZuUPAD21ywoQnCeusPK6rI4+8YH0fDUrCfi8T
iQyh9nMYwZgpYSTkTC/wBMOReAKMO537+/Q0noLIsoqUWkZpt6Ymq88kDc0ktyQ/
MniizWAwdnyb0le1zhQ3X119fWori0oVbc6p2t/PDc4PL9BsIfBLVdHziZ3zNNRM
0n6ThgfOzWY2wTMe4Q8sju2JOPWnmsCLuXp5enPRRfyhVB2vjPfzGy7JHWA0CFwL
tUF/uPyF0penxsA+2ET/iVpQtMgwC8uGMSgzsW+VzBH6OBu4bBKuvlqBKr0/mSnt
R7vS6P0wNYYqoJYKI6zP3uwbZDc3jz68XgMZBLfkK78WC+a3yVXLZ4Qqd+6/aoyn
5Pbaw9tkrukDqIiMk+WZbziEzr2DSvo+0pFHRzoIAQNy6LX3PSbXfJ8mmkU+0zrb
eNPHS1AKZrH06qGDjyyzYw3zx0wijHYcTNKN6o3d7btLkjrHLRWmv34ObRZZHejr
qeQhRgT1okRV468Smou4Bsa/yyd95TyVlQkm5TrTgNDGp/0RYCML1Ajik0Jtmk0h
zs/W++gMRuYYwOcwo18y
=NlSN
-----END PGP SIGNATURE-----

--tez2gqrut5pn4jhH--
