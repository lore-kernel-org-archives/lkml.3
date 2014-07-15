Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758988AbaGONYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 09:24:18 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56271 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758718AbaGONYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 09:24:14 -0400
Date: Tue, 15 Jul 2014 15:23:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: Re: finish_task_switch && prev_state (Was: sched, timers: use after
 free in __lock_task_sighand when exiting a process)
Message-ID: <20140715132353.GF9918@twins.programming.kicks-ass.net>
References: <53C2FF4D.3020606@oracle.com>
 <53C31A34.8030500@oracle.com>
 <20140714090449.GL9918@twins.programming.kicks-ass.net>
 <20140714144953.GA8173@redhat.com>
 <20140714160147.GA11986@redhat.com>
 <20140715131240.GA23014@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HIPflPGvV5kKjZ73"
Content-Disposition: inline
In-Reply-To: <20140715131240.GA23014@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HIPflPGvV5kKjZ73
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 15, 2014 at 03:12:40PM +0200, Oleg Nesterov wrote:
> Ah, I am stupid, please ignore.
>=20
> Of course a TASK_DEAD task can not schedule, but we can race with RUNNING=
 ->
> DEAD transition. So we should only do put_task_struct() if "prev" was alr=
eady
> TASK_DEAD before we drop the rq locks.

Not so stupid; that is, when I read your question yesterday I didn't
have a ready answer and queued the email to look at later.

This does mean the comment isn't clear enough at the very least.

Does this make it better?

---
 kernel/sched/core.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7bc599dc4aa4..aa67f1cfa58e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2211,13 +2211,15 @@ static void finish_task_switch(struct rq *rq, struc=
t task_struct *prev)
=20
 	/*
 	 * A task struct has one reference for the use as "current".
+	 *
 	 * If a task dies, then it sets TASK_DEAD in tsk->state and calls
-	 * schedule one last time. The schedule call will never return, and
-	 * the scheduled task must drop that reference.
-	 * The test for TASK_DEAD must occur while the runqueue locks are
-	 * still held, otherwise prev could be scheduled on another cpu, die
-	 * there before we look at prev->state, and then the reference would
-	 * be dropped twice.
+	 * schedule one last time. The schedule call will never return, and the
+	 * scheduled task must drop that reference.
+	 *
+	 * The test for TASK_DEAD must occur while the runqueue locks are still
+	 * held, otherwise we can race with RUNNING -> DEAD transitions, and
+	 * then the reference would be dropped twice.
+	 *
 	 *		Manfred Spraul <manfred@colorfullife.com>
 	 */
 	prev_state =3D prev->state;

--HIPflPGvV5kKjZ73
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTxStpAAoJEHZH4aRLwOS6CGoP/ibltbZG6BUvw0kWRu++beZ1
4h570fqmP6lDT3J5sLldSAiu+e8qjDEjX0mZWmRtkzrNWclZySkuQ/A+DHJEKK9n
wbO0nPvkSeHU6WgXWx2vysmpHqkcHOy7hfV+nc2nNMlMX5Jd1IqupXn7pw2sXG1F
xNrJl84SW4+Y8CGz8OY4SiN/t6b9g+G/DUAcydYVThXJQCDcetywNObcj32Ywu19
MhE8VnsaWi6pSW8CQMZsoOzupkK+BUb5V+NPx+qbENHr9ig9rEI+PTmY45k5SwNp
15agpnfqmOrUQIbc0UpEnVVrPPue6QmLzhGroBLvelZJOVLemDP7e1D0WJ2Lwg4H
8/gd6uFuA7qrAojIRz81uDbCaOlPWabvUpNWKbwAJfa0Rvi03LxfMLVVBJJQK2IU
BPaGJFCaymtLHlaQxZzzLbSBUViK9bub4Hmtc/dnRT6H79WU/8Ge/y+jlkelriRr
EZo41+D3qyknDJ9YsF22pomNhGIjzY+4QWMQDr28uJViqahJQA5j3LItECBQ+81+
M3ARjXJrdEybSq/fl3f6Lwr7p2kGBqkfsv+qLWOqT5hH4/Ki3JIoYM4j++KlQyy4
9oCK2VmVJcZOrbo9N/KyLi/fpvB8V7XAjM+BCQIhTDzRZO/cb13uCSphM0Ijt0DM
A/RJLBwjJnOKIeFFyDPT
=0Yp0
-----END PGP SIGNATURE-----

--HIPflPGvV5kKjZ73--
