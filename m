Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370AbaEPORx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 10:17:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:39740 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496AbaEPORw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 10:17:52 -0400
Date: Fri, 16 May 2014 16:17:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Preeti Murthy <preeti.lkml@gmail.com>
Cc: Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [PATCH] sched: fix exec_start/task_hot on migrated tasks
Message-ID: <20140516141745.GU11096@twins.programming.kicks-ass.net>
References: <20140515225920.7179.13924.stgit@sword-of-the-dawn.mtv.corp.google.com>
 <20140516080424.GM11096@twins.programming.kicks-ass.net>
 <CAM4v1pPNfpB+DumFHhi2UZS97zgfBFHEwQYsmQ5E1c2gZFbBww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+hZM3YBJafcqGfHn"
Content-Disposition: inline
In-Reply-To: <CAM4v1pPNfpB+DumFHhi2UZS97zgfBFHEwQYsmQ5E1c2gZFbBww@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+hZM3YBJafcqGfHn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 16, 2014 at 07:27:32PM +0530, Preeti Murthy wrote:
> > 0 isn't strictly the right thing to do here, since the clock can wrap,
> > but being wrong every ~585 years isn't too big an issue for this.
>=20
> I don't understand this. Will setting it to 0 not indicate beginning
> of ticking?=20

In modular spaces there is no beginnings nor endings.

> So when you find out for how long the task has run, the
> difference would be larger than what would have been had you
> let exec_start be at its previous value of the old cpu's clock_task right?

Nope, see the modular space thing, once every ~585 years we'll wrap the
clock and 0 is within range of recently ran.

> Will not setting exec_start to the clock_task of the destination rq
> during migration be better? This would be the closest we could
> come to estimating the amount of time the task has run on this new
> cpu while deciding task_hot or not no?

Setting it to the exact clock_task of the destination rq would make it
hot on that rq, even though it hasn't yet ran there, so you'd have to do
something like: rq_clock_task(dst_rq) - sysctl_sched_migration_cost.

But seeing as how that is far more work, and all this is heuristics
anyhow and an extra fail term of 1/585 years is far below the current
fail rate, all is well.

--+hZM3YBJafcqGfHn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdh4JAAoJEHZH4aRLwOS6pyAP/2iDPu+NObd526OEgpiQPy8x
iMa1W2UJ1fX175Xa8yrRwTJLTbjRkBqPb3xxY45LxqESUyBpiM9VgRz1K2Ep6ooS
qeC7Mj9XOP1IZK92sxJC3EefWY808bWmsxt/Jd659+ZG0NlvFGhqzqZIQ1gHOIEZ
M34Uc1jewa1HxfxMziv+2xweWqfY9NJunFHnHO8shY0AxLAHoIQahk22KATwdyt4
qvuYekdGZ8uZJb924Sdfw9ePlB+vJ5triVpeVQGMSg/waPf/7fx9aBINWxeAQ0V4
Vii0zKI3aPL6lK+2EoSxUeT4dDDUdsONV9zw2O5ZG9edV62iKh60/LpafdJCKZWf
SIp767jufe4H+deNc6a9H8tkRJIpviE0N7D28pMHqsp9mVhrdQ1+ucOqM9+HuGEp
wyrEAqhQSO0ORTbK1hKcbTNc+wsqDCn5oB2hogz5bEoQKMSsWhdRBSbLR/P4BcMN
oiWQB1foaWF9Q2X5cAa32pjaQuyMSpjSPdA4p2oNAdYTTKzkv1K7EK3MhRpC/qXP
TKy+t82cLCc64hviVzo3IontZNnKSZCgTMRL9qFjY1ZdPnC9qDO7byM4mxlAqNJ2
FCQVRDgjyyp7WCJYncJsubQfmbwUXZtOPgBy1ykhmaC45p7KceC7T5ABNjp/pM/z
K0hdL0RTg2Z5mOTdYahJ
=YSH2
-----END PGP SIGNATURE-----

--+hZM3YBJafcqGfHn--
