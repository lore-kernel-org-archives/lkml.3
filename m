Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbaFJPst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 11:48:49 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53478 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbaFJPss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 11:48:48 -0400
Date: Tue, 10 Jun 2014 17:48:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 0/6] nohz: Move nohz kick out of scheduler IPI, v8
Message-ID: <20140610154839.GF3213@twins.programming.kicks-ass.net>
References: <1402413309-3415-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Mjcb6KWfk+dITC8b"
Content-Disposition: inline
In-Reply-To: <1402413309-3415-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Mjcb6KWfk+dITC8b
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 10, 2014 at 05:15:03PM +0200, Frederic Weisbecker wrote:
> So this set happens to have more changes than expected because I
> found out that the timer list full nohz kick also relies on the scheduler
> IPI. So I had to convert it as well, hence a few more change splitups.
>=20
> Changes:
>=20
> * Check also raised lists from irq_work_needs_cpu() (thanks Peterz)
>=20
> * Comment on SMP functions priority in
>   generic_smp_call_function_single_interrupt() because IPI callbacks there
>   are often synchronous as opposed to irq works. (thanks Peterz)
>=20
> * s/native_send_call_func_single_ipi/native_send_call_func_single_ipi
>   (thanks Eric Dumazet)
>=20
> * Only build irq_work_queue_on() on CONFIG_SMP, fixes some broken builds
>=20
> * Convert full nohz timer list kick
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> 	timers/nohz-irq-work-v6
>=20

I think you finally nailed it ;-)

Acked-by: Peter Zijlstra <peterz@infradead.org>

--Mjcb6KWfk+dITC8b
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTlyjXAAoJEHZH4aRLwOS6SpwP/12ncBudVYP32f06j89gO/Vx
uwbJVUhozC1609qeSjE0zme9pL2+FpRBvTyMnDn9pgsi92Hly/4NYPwve6oQUqA0
isxsSAyTU7Qjqm3x86Vg4b7FXwqXz35FfxmaBgYzJge/TwKIoZ39AinybE5aWOYt
sa6fSiWcHM5xehaL4ifpBstVM9PlLC8bZuh2HhEvZ3PLkPLW3Mt648w6BNgLRKjC
2q2sdU5RHCcrGThHAuFnHCPpeFUTmomqmbK3P3w+CVwsbSs/7GjU52ZIRqickGLh
nzXPxdI3On8OIhdKgU+R9zAOEwbRFSOpGGo7PzYhCDw4dCnia4splzaZdrRMt+ta
BdaolQaKfOSyq2rGMUfTf5z2qolgtVnFEE7MS/LRs1QrDAYpjCNx3AJWFAkKU67D
7NfbEs1YfBXZjur6zbimwai4HUhYfVgXYAv10EgZiqXPa9x3lm+gBoaKS7otOk0w
AHaiKkRYmIakarQ4KLa00NEvyISOn5TMzAjhy1nQBAn8D1r4DoDo5ZfArKTBZ0qb
o7CWJtWT2f6txzbJydD4qdRLzEvhEqgsdlOoG3ETZj3KH59YkDMsbUl+IvGK7uzg
Fa6zZwnwAvRAEmMB+MdMUvzWB6Wud4QMq4NiXrTam5yCg5nX6MZap6GrcQFvHONm
dwItzdlddAoT1QDkC6aF
=FKfl
-----END PGP SIGNATURE-----

--Mjcb6KWfk+dITC8b--
