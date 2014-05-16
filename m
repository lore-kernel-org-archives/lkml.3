Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992AbaEPKjY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 06:39:24 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34646 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755741AbaEPKjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 06:39:23 -0400
Date: Fri, 16 May 2014 12:39:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: jjherne@linux.vnet.ibm.com, Sasha Levin <sasha.levin@oracle.com>,
        Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: workqueue: WARN at at kernel/workqueue.c:2176
Message-ID: <20140516103907.GQ13658@twins.programming.kicks-ass.net>
References: <537119EF.2060102@oracle.com>
 <20140512200135.GL1421@htj.dyndns.org>
 <53718119.1090000@cn.fujitsu.com>
 <537180B9.6080407@oracle.com>
 <53739F3B.4060608@linux.vnet.ibm.com>
 <53758B12.8060609@cn.fujitsu.com>
 <20140516093530.GN11096@twins.programming.kicks-ass.net>
 <20140516101505.GO13658@twins.programming.kicks-ass.net>
 <20140516101643.GP13658@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ie5iOtK4e9kgqh2F"
Content-Disposition: inline
In-Reply-To: <20140516101643.GP13658@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ie5iOtK4e9kgqh2F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 16, 2014 at 12:16:43PM +0200, Peter Zijlstra wrote:
> On Fri, May 16, 2014 at 12:15:05PM +0200, Peter Zijlstra wrote:
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -5126,7 +5126,6 @@ static int sched_cpu_active(struct notif
> >  				      unsigned long action, void *hcpu)
> >  {
> >  	switch (action & ~CPU_TASKS_FROZEN) {
> > -	case CPU_STARTING:
> >  	case CPU_DOWN_FAILED:
> >  		set_cpu_active((long)hcpu, true);
> >  		return NOTIFY_OK;
>=20
> In fact, I dropped this part as it conflicts with another patch I have,
> and setting it again isn't a big problem.

Gurgl, I'm an idiot, this doesn't re-set it, it sets it earlier. Let me
go fix the conflict properly then..

--Ie5iOtK4e9kgqh2F
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTderLAAoJEHZH4aRLwOS6kGIP+QF2c343mFdElB4RNGD0udN/
qZ8jZQ0Uvn1eaxQ5+SC25h5O6fx82iKRakrTrBPeuTq3ImCshKzBHR2tEszu/wkW
BYbN5liWRV5CKQuwQSVGGJpfZEuSTCfIMl6Gt5C5/doXW4aFu8GrDjyRRvm8+gxT
iGQakDGgt04c9YySLw6Ph3rYFSOFFQjq6azjm63b+gcbzki4HR9VmC0KyBZ2LXKT
RSNIYQnzWT5ih0MOmdAas3wWtUAzqpng2t2CnNIO3m37uDdQA8wXPQZYbdqt3dKI
7OBLLkLjG/NWw5+wgKZGvyG9usG/nCXCRJf3gMYcXxCytLTIUGrZIGMAjWrxMBUq
te9tGGnv2Cdfb90vVWcQZP8eAw1gGoZIMdXAiaz4HD6nerC7Qzn62yGkjhxPLpc7
WgYeKWqImMqQn9IiY/n5K1sdufWB1j7ArdFI76K1nA3LfmmxsnEogciQF/OyDQy3
JlaJlJ/TkwyDyIlPZ17NJ25Kxq1Uutppw0zHyW06PW1X6nEJVQsTexT0hUw4JQDS
wF3FKz6ZGsSGBNjTRTHZUz4tha/CNBHlBhArLwwjoUGsCtI7grZYxxjCo9ymO4Zg
9xs9DfmKMWuhmWcu6Z1r7nZhAvf4UFiHdrTWJBE0mD1YuXPZS85INf0ORRuac1I+
eioputeLzYq9N9Y/Puj6
=nvmm
-----END PGP SIGNATURE-----

--Ie5iOtK4e9kgqh2F--
