Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbaE1H3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 03:29:12 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34824 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853AbaE1H3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 03:29:10 -0400
Date: Wed, 28 May 2014 09:28:52 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Minyard <cminyard@mvista.com>,
        Stanislav Meduna <stano@meduna.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, rjw@rjwysocki.net
Subject: Re: [PATCH v2] tracing: Don't account for cpu idle time with irqsoff
 tracers
Message-ID: <20140528072852.GN11096@twins.programming.kicks-ass.net>
References: <1401221284-13678-1-git-send-email-sboyd@codeaurora.org>
 <17051981.niWmA6MIgX@wuerfel>
 <20140527174847.7b405b5c@gandalf.local.home>
 <53850FF3.8050107@codeaurora.org>
 <20140527193050.4606a014@gandalf.local.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CwrkNGGfsJuCXYE3"
Content-Disposition: inline
In-Reply-To: <20140527193050.4606a014@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CwrkNGGfsJuCXYE3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 27, 2014 at 07:30:50PM -0400, Steven Rostedt wrote:
> Paul, Peter, see anything wrong with this?

You mean, aside from that it won't actually apply due to that code
having been massively overhauled?

I suppose the same thing Arnd mentioned, the cpuidle_enter() thing can
be huge, but is we're going to have to push this down into all cpuidle
drivers we're not going to be happy.

So I think we're going to have to draw a line and impose restrictions on
what cpuidle_enter() implementations can and can not do.

> diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
> index 8f4390a..f5e6a64 100644
> --- a/kernel/sched/idle.c
> +++ b/kernel/sched/idle.c
> @@ -88,12 +88,6 @@ static int cpuidle_idle_call(void)
>  	}
> =20
>  	/*
> -	 * During the idle period, stop measuring the disabled irqs
> -	 * critical sections latencies
> -	 */
> -	stop_critical_timings();
> -
> -	/*
>  	 * Tell the RCU framework we are entering an idle section,
>  	 * so no more rcu read side critical sections and one more
>  	 * step to the grace period
> @@ -144,6 +138,12 @@ static int cpuidle_idle_call(void)
>  				trace_cpu_idle_rcuidle(next_state, dev->cpu);
> =20
>  				/*
> +				 * During the idle period, stop measuring the
> +				 * disabled irqs critical sections latencies
> +				 */
> +				stop_critical_timings();
> +
> +				/*
>  				 * Enter the idle state previously
>  				 * returned by the governor
>  				 * decision. This function will block
> @@ -154,6 +154,8 @@ static int cpuidle_idle_call(void)
>  				entered_state =3D cpuidle_enter(drv, dev,
>  							      next_state);
> =20
> +				start_critical_timings();
> +
>  				trace_cpu_idle_rcuidle(PWR_EVENT_EXIT,
>  						       dev->cpu);
> =20



--CwrkNGGfsJuCXYE3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJThZA0AAoJEHZH4aRLwOS60KYQAJ1h+oJiCALVDJT53m8QfDvt
yFjI2cGoNXLM775cXxTn7ZOf6dGyi30JvA8xniWIXVKZlpKD/DQIcHdTJjirjgOu
NJwIkXWKzyE1EqInDQnLsmszjiRym6xK270gy4QDwRTzXyQwhmXCEbfcWQK/CxHb
NchRsH9q3TxpgHZWpq359VdDDjLSyG/gbfgZr0wnHDYfAl0+gqjHbAQeEiaxpVvY
TmaXf0gxcjNJkyodC8EQ5Nyb5W3SGDM88QJNrAnqiLRG2+MzNUzVEsUVO2u2yTX1
0v5upvhf7BkLGcsfhjd2+2bnuvS0m6VFqO+fOhZOPamzfzXrTkzNy2pWA0DUruWY
ZTH0baJ4OpyL1EYfoU3iXB/XEyjwpujhv+tkyMIdruOyzc6QVLJe7+fEyvBlpQqp
Z5HqxAqbjTd/hAmbFe2pAz+f+EqLUmmfTIf+hlM2ygRxy/QxUfXlDPZX9LzXUUEM
36M8j9CMsU+Rn31a0oq8n2yD0uC6spAktgaqdH2y3+DOoefTWteSIspLLSvLbVUY
nN1zLCOi91A14sYxoG/ZfxmDIq9vqXYLhUxo65aeiiVRVhe1bWMVMPiJlfvjIHgM
zjzSruKPB/bOuZpr+x0BGKb9GrCb4NcfOBEjIWhsa0G5CFolpIdzEOWa4/FF+uRo
t37BXY9ICMOS7Iv5nViQ
=D4u0
-----END PGP SIGNATURE-----

--CwrkNGGfsJuCXYE3--
