Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175AbaHHQvf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 12:51:35 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52984 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755745AbaHHQve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 12:51:34 -0400
Date: Fri, 8 Aug 2014 18:51:12 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, bobby.prani@gmail.com,
        masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH v3 tip/core/rcu 3/9] rcu: Add synchronous grace-period
 waiting for RCU-tasks
Message-ID: <20140808165112.GI9918@twins.programming.kicks-ass.net>
References: <20140807154907.6f59cf6e@gandalf.local.home>
 <20140807155326.18481e66@gandalf.local.home>
 <20140807200813.GB3935@laptop>
 <20140807171823.1a481290@gandalf.local.home>
 <20140808064020.GZ9918@twins.programming.kicks-ass.net>
 <20140808101221.21056900@gandalf.local.home>
 <20140808143413.GB9918@twins.programming.kicks-ass.net>
 <20140808105858.171da847@gandalf.local.home>
 <20140808162714.GG9918@twins.programming.kicks-ass.net>
 <20140808163905.GA5821@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wICP0NOJ5+05hdQ6"
Content-Disposition: inline
In-Reply-To: <20140808163905.GA5821@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wICP0NOJ5+05hdQ6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 08, 2014 at 09:39:05AM -0700, Paul E. McKenney wrote:
> On Fri, Aug 08, 2014 at 06:27:14PM +0200, Peter Zijlstra wrote:
> > On Fri, Aug 08, 2014 at 10:58:58AM -0400, Steven Rostedt wrote:
> >=20
> > > > > No, they are also used by optimized kprobes. This is why optimized
> > > > > kprobes depend on !CONFIG_PREEMPT. [ added Masami to the discussi=
on ].
> > > >=20
> > > > How do those work? Is that one where the INT3 relocates the instruc=
tion
> > > > stream into an alternative 'text' and that JMPs back into the origi=
nal
> > > > stream at the end?
> > >=20
> > > No, it's where we replace the 'int3' with a jump to a trampoline that
> > > simulates an INT3. Speeds things up quite a bit.
> >=20
> > OK, so the trivial 'fix' for that is to patch the probe site like:
> >=20
> > 	preempt_disable();		INC	GS:%__preempt_count
> > 	call trampoline;		CALL	0xDEADBEEF
> > 	preempt_enable();		DEC	GS:%__preempt_count
> > 					JNZ	1f
> > 					CALL	___preempt_schedule
> > 				1f:
> >=20
> > At which point the preempt_disable/enable() are the read side primitives
> > and call_rcu_sched/synchronize_sched are sufficient to release it.
>=20
> Unless this is done in idle, at which point RCU-sched is studiously
> ignoring any preempt_disable() sections.

Well, given that kprobes is already using it, it 'must' be good ;-) I
suspect much of the idle loop is marked with __kprobe or so, or nobody
has been brave enough to try.

--wICP0NOJ5+05hdQ6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT5P//AAoJEHZH4aRLwOS6Ft4P/REiwN1xEINoCrQaoBKrlVwb
bFIgq7fpVovi77DQVTfiIWVuciitOn4fzzo1ZLIleMAVRDhMFyFf3DL3fn9wVVdJ
fsMlCeErWvLzf2yQYpzTnmP70zChzJKTfhcscK+Eao6SwioHndmWyPxNDzlTapnZ
smeDc+mSScx7QXA6QI3iaSvRwGpmsCTZuosbkghkyGC7uE1GAw/C9yFmkEzRyMMI
hU6dO8aiSNpsLBhWfSk6zd6TEJzHRUyKXE2YKwBUwHY0widwvJI6tkzJlWECH4zg
m9YPM3jIwofphNf/VrjrcbsLpaH33wsekNAsYI8Vz7OevGs3thResuwG6KgMcVR+
R9MaR1OLdVAvjTZmZbYzBAAMIxVIA5Dmt6rr2ZU0Ys+Ziz3MNduat0QYS7X7W4OV
syhMUT1TRqqJrAX0N7g99BRoriA2ZrDQu73XvuMsRE7PrUO125Ja4IuImNOzgGkI
VHKEIHz7pbvNwJeblayAdVbdnap7tPmgJWjxQZZOd4lQDf2qWncYATK5aR+tHdVD
rWjFKjdLJxzI7Fq2J/kRcwdQlOo27SAuoImp87SpsPGlfpmiCxeu1iah6jw8TE7N
jdA9dFx1WB3ThLfAcDfnd4avLc7R2qWK9T+CHrUUdDLhV/NHNI78tFONV9ly+Fks
i3zhQ58aQg71XGrRrc6G
=gy9A
-----END PGP SIGNATURE-----

--wICP0NOJ5+05hdQ6--
