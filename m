Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbaGaQ5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 12:57:43 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:40442 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbaGaQ5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 12:57:32 -0400
Date: Thu, 31 Jul 2014 18:57:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v2 tip/core/rcu 01/10] rcu: Add call_rcu_tasks()
Message-ID: <20140731165711.GB19379@twins.programming.kicks-ass.net>
References: <20140731003914.GA3872@linux.vnet.ibm.com>
 <1406767182-4356-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <53D9F084.7000706@cn.fujitsu.com>
 <20140731160924.GR11241@linux.vnet.ibm.com>
 <20140731162030.GY19379@twins.programming.kicks-ass.net>
 <20140731164739.GT11241@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GaZmH9UKdt3tlzB4"
Content-Disposition: inline
In-Reply-To: <20140731164739.GT11241@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GaZmH9UKdt3tlzB4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 31, 2014 at 09:47:39AM -0700, Paul E. McKenney wrote:

> The idea here is to avoid having the kthread and to avoid providing
> callbacks, but to instead do the work currently done by the kthread
> in a synchronous function called by the updater?

yep.

> My concern with this approach is that I bet that Steven will want
> to have multiple concurrent calls to remove trampolines, and if I
> need to support that efficiently, I end up with more-painful counter
> tricks instead of the current callbacks.
>=20
> Or am I confused about what you are suggesting?

Nope dont thing you are.

Typically things like ftrace are global and so we don't end up
with concurrency like that, but who knows, we'll have to wait for steve
to get back.

> > Now, if only task_work would work for kernel threads, then we could do
> > something far nicer...
>=20
> OK, I'll bite...  What is task_work?  I am guessing that you are not
> talking about struct ql4_task_data in drivers/scsi/qla4xxx/ql4_def.h.  ;-)

kernel/task_work.c include/linux/task_work.h

its a worklet ran on return to userspace or exit -- ie. safe points for
our tasks.

problem of course is that kernel threads never do the userspace part and
typically do not do the exit thing either.

But the idea was, do the task scan, add a task_work to each that need
attention, have the work call complete and then wait for the completion.
Avoids the polling entirely.

If only kernel threads..

--GaZmH9UKdt3tlzB4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT2nVnAAoJEHZH4aRLwOS6XtgP/RIJmjP9w2rgAW1PQ0l+lHY7
/fwOKVTE7IymrK42MeujRfiySYKfoBJG7sCg4vSbIfpquZgSNi/+krZt43gnvdb3
BeSuU4BLb5HhOBuHwEC8ARY346kG7qkpWK1WfjMCyaC54O93amxNRz9ENcmAKRa4
moJu+K5wusD29KbWI5tHYgYwqYib1kR7bZYfyFlKc3XXcPTEsSw5fCPNgjW9yv8B
jfgKtc0B6Hn9ICwV8htlzCwmR0ceLME5XksfOrWhZmIC77l3nV+nGpWpkIwL2043
b9UtvdSJYKwHMIMgjHtlke+agog3BazktTSM75xvBSccFm2K2xfJbLnoONBhhtY7
WPVHetADUPLekJ+RJJWB4qtob5MOmJ7IMOuPYyvDXRQIvbFuYYyiRDu0q/pBoBwO
/q5QtSIOdLZtPexR5RDTMkxlmXfaEM/Qe9MEZv3oePn46BVRrRgLK5aX/duVwC3E
QV3Iv7CajcH+axXmD//mlK5HSrN/o6QrzlE/xGIaOTROV3m2wKVOVRAt09eoa+kH
HV7PcYi23bIVQbGrcR19vIelutJeNxrfBYtkA2kBMW/0UJl9FQq36BpJnPNv9Q4E
Wk9IhATRSWglT1SlHhkfShF6hubJN0SW4vOTYv7k4vyflVZy+ZtEJ878Gu/hZbUT
+12r3A5WGvUIrZJ4QABT
=QNap
-----END PGP SIGNATURE-----

--GaZmH9UKdt3tlzB4--
