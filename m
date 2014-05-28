Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157AbaE1HZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 03:25:26 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:32825 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932142AbaE1HZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 03:25:24 -0400
Date: Wed, 28 May 2014 09:24:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Minyard <cminyard@mvista.com>,
        Stanislav Meduna <stano@meduna.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        john.stultz@linaro.org
Subject: Re: [PATCH v2] tracing: Don't account for cpu idle time with irqsoff
 tracers
Message-ID: <20140528072457.GM11096@twins.programming.kicks-ass.net>
References: <1401221284-13678-1-git-send-email-sboyd@codeaurora.org>
 <17051981.niWmA6MIgX@wuerfel>
 <20140527174847.7b405b5c@gandalf.local.home>
 <53850FF3.8050107@codeaurora.org>
 <20140527193050.4606a014@gandalf.local.home>
 <53852999.7060907@codeaurora.org>
 <1401237734.23277.1.camel@pippen.local.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lpBPog2+b3WGyJY6"
Content-Disposition: inline
In-Reply-To: <1401237734.23277.1.camel@pippen.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lpBPog2+b3WGyJY6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 27, 2014 at 08:42:14PM -0400, Steven Rostedt wrote:
> On Tue, 2014-05-27 at 17:11 -0700, Stephen Boyd wrote:
>=20
> > cpuidle_enter_state() calls ktime_get() which on lockdep enabled builds
> > calls seqcount_lockdep_reader_access() which calls local_irq_save() that
>=20
> seqcount_lockdep_reader_access()?? Ug, I wonder if that should call
> raw_local_irq_save/restore() as it's a lockdep helper to begin with. If
> it's wrong then it's the lockdep infrastructure that broke, not the core
> kernel.
>=20
> Peter?

Hurm,.. don't know actually.. so from a lockdep pov it doesn't need to
do that and we can simply remove the local_irq_{save,restore}() from
that function.

It could be John did it to avoid some IRQ recursion warning, but if so,
he failed to mention it.

John, remember why you typed those characters?

--lpBPog2+b3WGyJY6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJThY9JAAoJEHZH4aRLwOS6jnkQAJN2RVJ7XkqZ1DZMKQm0Fakw
e7D9qHugNdJRUVepdMRPYMUDyOXi36ByilmGyq56NlQekyCISqMdcALy/xQGDSMJ
tIhlvnSukAkClP7TDj6f6NYw85dIznKq016ZD7ceugw2yuTamCuBxodCTDhNnb1b
+pjKuYVXOz5yJKo1JhpUCIoJOP8mP/pj4w0wbeUhiXC2MwmvQhT6MQulGrQFq/aQ
7Gf5Zpagak6Q+37RAt0y8cFxm0GbC/5HIHkGcAjM0VuUhEtAW2Sm0AEobPbI8oPj
yn7Mmv+z3RaccPd+tRGh4MxvobdgR8PhzQStdHmb9CHjS8kyYRuLilAimSfaNNVZ
+aNSM2roXpcNApb7TiQnBgB9pWWjk4UpDi9Is8g3LTmxG7Rd7bNUQxvmEiFx8wyC
c2czpnu08X11FkLdqIwU94y+kQ3oZc7b6FGL3Bq/+aDITY9eLw/Jychc5+zX8y1f
L5ip3JJOK1ULOm95C5jLsCbKfjyghEcicXXbsFdmMIe7ab7VgjUjMrLp1Ly+sQDm
C8JsFRQdfFBkHx+iEL8eJPjbRIav9EkCZCLREzmcNtsA8dD5IEaghwVlranOIUOm
IjtmZ6I8Nqr2rVrTWUmZLPpRecgX5AqBxOsuiexa+NUWYeyXXiEmVBuIRqqykjvU
G9dh64Y4uJMkaXdYr12o
=6+3L
-----END PGP SIGNATURE-----

--lpBPog2+b3WGyJY6--
