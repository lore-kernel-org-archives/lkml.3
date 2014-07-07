Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325AbaGGIad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 04:30:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:48601 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbaGGIa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 04:30:26 -0400
Date: Mon, 7 Jul 2014 10:30:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: sched: spinlock recursion in sched_rr_get_interval
Message-ID: <20140707083016.GA19379@twins.programming.kicks-ass.net>
References: <53B98709.3090603@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NXxBKFTfdeXlAk+N"
Content-Disposition: inline
In-Reply-To: <53B98709.3090603@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NXxBKFTfdeXlAk+N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 06, 2014 at 01:27:37PM -0400, Sasha Levin wrote:
> Hi all,
>=20
> While fuzzing with trinity inside a KVM tools guest running the latest -n=
ext
> kernel I've stumbled on the following spew:
>=20
> [10062.200152] BUG: spinlock recursion on CPU#11, trinity-c194/2414
> [10062.201897]  lock: 0xffff88010cfd7740, .magic: dead4ead, .owner: trini=
ty-c194/2414, .owner_cpu: -1
> [10062.204432] CPU: 11 PID: 2414 Comm: trinity-c194 Not tainted 3.16.0-rc=
3-next-20140703-sasha-00024-g2ad7668-dirty #763
> [10062.207517]  ffff88010cfd7740 ffff8803a429fe48 ffffffffaa4897e4 000000=
0000000000
> [10062.209810]  ffff8803c35f0000 ffff8803a429fe68 ffffffffaa47df58 ffff88=
010cfd7740
> [10062.210024]  ffffffffab845c77 ffff8803a429fe88 ffffffffaa47df83 ffff88=
010cfd7740
> [10062.210024] Call Trace:
> [10062.210024] dump_stack (lib/dump_stack.c:52)
> [10062.210024] spin_dump (kernel/locking/spinlock_debug.c:68 (discriminat=
or 6))
> [10062.210024] spin_bug (kernel/locking/spinlock_debug.c:76)
> [10062.210024] do_raw_spin_lock (kernel/locking/spinlock_debug.c:84 kerne=
l/locking/spinlock_debug.c:135)
> [10062.210024] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kerne=
l/locking/spinlock.c:151)
> [10062.210024] ? task_rq_lock (include/linux/sched.h:2885 kernel/sched/co=
re.c:348)
> [10062.210024] task_rq_lock (include/linux/sched.h:2885 kernel/sched/core=
=2Ec:348)
> [10062.210024] SyS_sched_rr_get_interval (kernel/sched/core.c:4429 kernel=
/sched/core.c:4407)
> [10062.210024] ? tracesys (arch/x86/kernel/entry_64.S:531)
> [10062.210024] tracesys (arch/x86/kernel/entry_64.S:542)

Cute, but I'm utterly failing to see how that happened :/

All we should be holding there is the rcu_read_lock(), task_rq_lock()
there will take ->pi_lock and then rq->lock.

Maybe after more tea, when the brain wakes up more or so.. weird.

--NXxBKFTfdeXlAk+N
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTulqUAAoJEHZH4aRLwOS6DkoP/0BfQvIT6YmojSHC8k6Qmo3K
6jEEQmR/dYG9xoZjJ+Ouf8oB2t/RWHG3pCzd/B2hcrcQ8Zwzvube7z9l6iNNPhZq
//g9PyPReyKGEoA32Ut8xaCH2fSnb8sF/uupqE1N9sMnlBfAQfMAnwK271KCFqDo
zEZRIFQpOSeChF9lNBO194ZbYO8+8m2dV0pq4X6i+DWO53vKOQHV7lbtUtue2VeF
BwcNrsoQZHvQxatUSXEEIjAFdLqzsCVrdP+Gw1EIxQC/S2+hmFlj1993q0N78PJi
AI4k9f2enK5kMOE46cGJgT0MgigPA+fVccYC5hT0Du822Jbf+qc9+bDxb5a+q9Uz
TQNUjqOPSTqPZ4N0MwGHYxRSmOD4AsJgY090+IpAk4+LuK5+FFSuCzonJ/eXi6Kd
sVCFJK1IZ6FEmKV4KDRorHJoRuWg1TbT8uecERL6GlrL9FphT2pKHLDk8sEcL+hz
v8glLG00GVbJyizkzDfOyQdQ7Tzr050kwigpqVCQX1z8vw+TgEPKYLE/aOufXibP
p8gWqEsXzF4CiOOjelxzINSNgZ4Ka55Rwplwpdfn4S+FiCD6LjC/PXLjsNXSMSVL
9oHhYuMFMKVZVHGKpuWavW5VvHdmEsePtaBQ2OvyhAQAKnN7yAdY4/L/yDrxJkUd
mV4duzdxpPuSIRK4Isnj
=qBXQ
-----END PGP SIGNATURE-----

--NXxBKFTfdeXlAk+N--
