Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbaHMQfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 12:35:46 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34696 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbaHMQfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 12:35:45 -0400
Date: Wed, 13 Aug 2014 18:35:22 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v5 tip/core/rcu 15/16] rcu: Make RCU-tasks wait for idle
 tasks
Message-ID: <20140813163522.GU9918@twins.programming.kicks-ass.net>
References: <20140811224840.GA25594@linux.vnet.ibm.com>
 <1407797345-28227-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1407797345-28227-15-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140813081215.GB9918@twins.programming.kicks-ass.net>
 <20140813124818.GQ4752@linux.vnet.ibm.com>
 <20140813134025.GN9918@twins.programming.kicks-ass.net>
 <20140813095132.56d288f2@gandalf.local.home>
 <20140813140705.GO9918@twins.programming.kicks-ass.net>
 <20140813101301.08019895@gandalf.local.home>
 <20140813144332.GW4752@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6rtPZF7Topj4j03h"
Content-Disposition: inline
In-Reply-To: <20140813144332.GW4752@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6rtPZF7Topj4j03h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 13, 2014 at 07:43:32AM -0700, Paul E. McKenney wrote:
> So the first three look OK to hook rcu_idle_enter() and rcu_idle_exit()
> into, but the last two don't look so good.
>=20
> That said, if you are OK not tracing the stuff under stop_critical_timing=
s(),
> then I can use the RCU dyntick-idle state and not wake anything up.

Either way, Steve could easily whip up a debug thing that could validate
that. Simply WARN whenever an __mcount happens when under rcu_idle.

And if we make these idle functions small enough that should not be a
problem at all.

--6rtPZF7Topj4j03h
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT65PKAAoJEHZH4aRLwOS6vY8P/R2G0Ic4OParCepaBB7WUVX6
LyM04bSFt233WYmch+WzOosTAM7lWKKGx4mmy+YYY0tj4ITTTyculu73+oys+sa/
y8SWYa7A5UdwBZ0JX3DEZFiGmfdMlvweGKI2dXmq4QP+6RRz+ln75pW0XsWBMO6y
ic6ju7tINNObN1sXpoMlNcNj5NRZfNqlas0eAOFT+k7GoixtZU+r+xrxuozQM/GY
e9lGHvP9+Rj3IMolotBf4bVramZ8WaXJ0jr2OBae7gHQj+pG6RTND6z7xNpp34e8
Xr9Z+Ga+ge2KXGKHaJPf8/Y2SwkOt0hp2lHtpVIoHa/rVMIqsYnAsMxewbvEDoIO
7myODkJq/WR0BlB+XPZen5oSXHmO4N70a28K0zHNpkZ8ZOZfP+QXTQnSgbB9afZa
HFGHjqEzR1Pc40st862Qz7RPNR5gV1ZH5NmQ6uM1MgsbPzYEWJ6QxogFcxMgwAC/
AiWDak2glMMpazm7akIeaDf8roZpvlEZqDVJRzmOQaeGYg5fXHrgo8fZfWYttuMw
a+aJLAIiiblZx0/MoULSWYmZmE7CHNgbxR4gAWR6qsv/ZWX/UsagWB49vNkQGNR/
mmLb0QXTjaS8ZUfp2T7huR8rTTjz8pO8JggOvtAyZyZJMhNeMLqrynWYe9AMlhxT
jvFl9hP19Mz2L+QQEhLh
=6hHh
-----END PGP SIGNATURE-----

--6rtPZF7Topj4j03h--
