Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803AbaFCPAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 11:00:20 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54963 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932762AbaFCPAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 11:00:18 -0400
Date: Tue, 3 Jun 2014 17:00:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 3/5] irq_work: Implement remote queueing
Message-ID: <20140603150008.GT30445@twins.programming.kicks-ass.net>
References: <1401806420-31018-1-git-send-email-fweisbec@gmail.com>
 <1401806420-31018-4-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X0hJ4E3r/0nQXmJY"
Content-Disposition: inline
In-Reply-To: <1401806420-31018-4-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X0hJ4E3r/0nQXmJY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 03, 2014 at 04:40:18PM +0200, Frederic Weisbecker wrote:
> irq work currently only supports local callbacks. However its code
> is mostly ready to run remote callbacks and we have some potential user.
>=20
> The full nohz subsystem currently open codes its own remote irq work
> on top of the scheduler ipi when it wants a CPU to reevaluate its next
> tick. However this ad hoc solution bloats the scheduler IPI.
>=20
> Lets just extend the irq work subsystem to support remote queuing on top
> of the generic SMP IPI to handle this kind of user. This shouldn't add
> noticeable overhead.
>=20
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Kevin Hilman <khilman@linaro.org>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Acked-by: Peter Zijlstra <peterz@infradead.org>

> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  include/linux/irq_work.h |  2 ++
>  kernel/irq_work.c        | 22 +++++++++++++++++++++-
>  kernel/smp.c             |  4 ++++
>  3 files changed, 27 insertions(+), 1 deletion(-)

> @@ -198,6 +199,9 @@ void generic_smp_call_function_single_interrupt(void)
>  		csd->func(csd->info);
>  		csd_unlock(csd);
>  	}
> +
> +	/* Handle irq works queued remotely by irq_work_queue_on() */
> +	irq_work_run();
>  }

One could possibly extend that comment by stating that we explicitly run
the irq_work bits after the function bits, because the function bits are
typically synchronous and have people waiting on them, while not so for
the irq_works.


--X0hJ4E3r/0nQXmJY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjeL4AAoJEHZH4aRLwOS6DF0P/i2WrdV59D1b5uKMh/+U5mJt
C0xpOYVJ0k9wzIzcAKkojCWjQcxGOvD0uutL2MUrBL7Jw5XB9Xt02ADzF/NnSL8N
6+NxxHgfQQTaN2eVtsEC17gEcO7bZH7ecyBepGV1Rvoue9k4NDGVXAsPaGnxth0t
n3x2jZImhEXNmxqzR8d+ayNpTBR/or0T76i0g9BIg4/45RSu5v058uOF6L6UEraE
85ebPQM8sKBGnALSeZx/iSUjhPV/sIDUjuFN6tRxpb9otrwcduOPqPCf21PyPJK8
qnRudWDTnwmO9x2O2BAkjsFMNBmIPb06TeTOXGqUQ1VZnp7m6saHBGNCtbk502vz
EF8XkK+rKVPw23AJ3qzBKBVK8QGBs5losq87v0nhzc91KPIqam7lnmiGLUuRbHUG
dvyZWoZUb0z4/C1zsUbBrDSwu3Fo4HtEudPQfpz/ai0v/CW0Wczu5DlMqK3lZBjJ
mmd44fAfpjWtwk/2kdJDbijCoxpazWfRKriS4+MXtMLrODaeRanvzqr4l/fgcQGw
QRRrccEpRYDUyCzjlRC8sGhp1IvLHYbjQOFXr+43vupzcJebyuwgK3cPnulR1QIq
yx7M9gFNUugWDXyLtol7kvNxaAVjWXRpSaJlDs7f6V9yNn8kukt3q5oLMZBuEntI
q2R7eLGD3GloN1Xi1l8E
=zsWV
-----END PGP SIGNATURE-----

--X0hJ4E3r/0nQXmJY--
