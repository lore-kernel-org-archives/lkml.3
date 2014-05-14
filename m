Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbaENJKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 05:10:24 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43477 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723AbaENJKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 05:10:21 -0400
Date: Wed, 14 May 2014 11:10:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 1/3] irq_work: Implement remote queueing
Message-ID: <20140514091011.GI13658@twins.programming.kicks-ass.net>
References: <1400019956-25511-1-git-send-email-fweisbec@gmail.com>
 <1400019956-25511-2-git-send-email-fweisbec@gmail.com>
 <20140514090629.GC30445@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eDB11BtaWSyaBkpc"
Content-Disposition: inline
In-Reply-To: <20140514090629.GC30445@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eDB11BtaWSyaBkpc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2014 at 11:06:29AM +0200, Peter Zijlstra wrote:
> > +	llist_add(&work->llnode, &per_cpu(irq_work_list, cpu));
> > +	native_send_call_func_single_ipi(cpu);
>=20
> At the very leastestest make that:
>=20
> 	if (llist_add(&work->llnode, &per_cpu(irq_work_list, cpu)))
> 		native_send_call_func_single_ipi(cpu);
>=20
> But ideally, also test the IRQ_WORK_LAZY support, its weird to have that
> only be supported for the other queue.
>=20
> Hmm, why do we need that LAZY crap, that completely wrecks a perfectly
> simple thing.
>=20
> The changelog (bc6679aef673f), not the printk() usage make much sense,

s/not/nor/

> printk() can't cause an IPI storm... printk() isn't fast enough to storm
> anything.

Except, as we all know, slow serial lines.

--eDB11BtaWSyaBkpc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTczLzAAoJEHZH4aRLwOS6lA0P/jpJjve+DXH8tRDnnaq6T+l4
uGVl1CAOkYPzksWhO1rTWrANxgUlIy227hQAiBIM7DesqJOJM7FhmtATEpPaJvni
vp8ehJ8MHd8ocH7qn4xLNmehbFxjjaeG3qkXrZXy2nwXfFRUvU++qCtyTlrMjUUf
AXVPW/keLE8YiSFc7NmlJLjLPHzvEUg7N7uxkZVzaqg9g9NUq3ihh1VZTJ0fazEF
LnopPur96Cnw8cf4r1P6SmUWhAEgw7/lZnmLVX9zb1/w03SkN1NEDETfJNjeiDLG
D6QEMzCsF9TcWWJjWxqxvuu5PVJ816Pr868GMNMnplXFWV6HzePkwrYX2AyKNXqh
7+8efYjKFfuNknfmKzppc6fy/RxboRQzACnuu4FxRoJn4UGDLHPEd0gGK/gSnb8Y
/05+UDs1ianH3xVrUNfux6d88N+t+sPyVQKOvgiA72kEaUk/Sg+w93fLZ23CTz5X
fWXgUGirU0TnKGwbd4FNHPToKTkFbUuvcl+wu5VmnKc2DDcVGQGoIaxiSjMSuNCv
cqaBcPwbQrR6MDWalyrxeTNFAYWWzVMgm8wNloR5OWwtNgsz3WWc1x8iUhA4TZCV
UCl1r7Skz02be1VM8BYdUKGTy7XbzdCCtRjZJoUEvWTveRiHUx/fVMQbwRBfWsjq
o3LIQhF+zs5AsHcMyvIR
=fsWM
-----END PGP SIGNATURE-----

--eDB11BtaWSyaBkpc--
