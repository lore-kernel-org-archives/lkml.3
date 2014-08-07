Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414AbaHGIqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 04:46:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:46139 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757245AbaHGIqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 04:46:01 -0400
Date: Thu, 7 Aug 2014 10:45:44 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 3/9] rcu: Add synchronous grace-period
 waiting for RCU-tasks
Message-ID: <20140807084544.GJ19379@twins.programming.kicks-ass.net>
References: <20140801183251.GJ4784@linux.vnet.ibm.com>
 <20140801194417.GA27141@linux.vnet.ibm.com>
 <20140802144719.GA18018@redhat.com>
 <20140802225857.GC8101@linux.vnet.ibm.com>
 <20140805205711.7a52076c@gandalf.local.home>
 <20140806012139.GY8101@linux.vnet.ibm.com>
 <20140806084708.GR9918@twins.programming.kicks-ass.net>
 <20140806120958.GZ8101@linux.vnet.ibm.com>
 <20140806163035.GG19379@twins.programming.kicks-ass.net>
 <20140806224518.GA8101@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2SmfCasAd/ILeD9K"
Content-Disposition: inline
In-Reply-To: <20140806224518.GA8101@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2SmfCasAd/ILeD9K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 06, 2014 at 03:45:18PM -0700, Paul E. McKenney wrote:
> > > > But I still very much hate the polling stuff...
>=20
> The nice thing about the polling approach is minimal overhead in the
> common case where RCU-tasks is not in use.

No, quite the reverse, there is overhead when its not in use, as opposed
to no overhead at all.

I'm still not convinced we need this 'generic' rcu-task stuff and create
yet another kthread with polling semantics, we want to let the system
idle out when there's nothing to do, not keep waking it up.

So do we really need the call_rcu_task() thing and why isn't something
like synchronize_tasks() good enough?

So the thing is, the one proposed user is very rare (*) and for that
you're adding overhead outside of that user (a separate kthread) and
your adding overhead when its not used.

* I'm assuming that, since tracing is 'rare' and this is some tracing
thing.

--2SmfCasAd/ILeD9K
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT4zy4AAoJEHZH4aRLwOS6k4IQAJ9i9nrp7Yo+q4XGCMF8Sfd+
WtquuzEALKjjMctCRT7Pt8FtRBipaItuiwgq686fTGRalUVnCpRLuG/+c1cGSS6G
g6l9hE+kh/t3MAsU1UFL1FKrhH5rGmslw0IyGyXA7V8uqJhJBC07uFacaXLyI5vJ
1Y/IuVrj0r4nb2TdFaPmGm0OdyBg7kihPHp4FpEaS+keMbg0cmCbHjx5dfPl7jgc
eKhR5I9rNy3lYSdz4YWb0c6nA/WJmKUHIV+IgfXqXJHkcthSQA2ZgdLyu30qN8Nl
JiJO5fj08rZ0Qp7rk902t9axHolKIxR0QsvgJCVATv2LeeDvfzgPln9nYifd7mZY
7TPGmqMo6brft1FKkbu9sRpW14bRFqDBBfUonhaJRvTaLtUxhdc/6ovSxSLRjM1W
BC3gDlYE/jAwYUtEXLeJXFHObR20YIYr1Gn4Dn7QO+ywJdcVBmq56snov9y9/WJx
AhXAs/JkC4xihHOO06WQw6z06nlAHtn9NqkU6buN06mpES1+E2pnxkxdJwg/DJ1w
eLiKB2+e+PJ4hPwjhui/59uMLRI9ffYHbwo9tOFsn9iB5Vy+MWRuiSTE7kaCZ22p
J4De37X1vT5/0oFgcgEno7+zqxUNXZg2NMnQ2M0X1e1/tYDiSI5HQv0KM/1NbG/1
Hg+ZKpoQIWSz3htC/5rC
=MkQe
-----END PGP SIGNATURE-----

--2SmfCasAd/ILeD9K--
