Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbaGDHvm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 03:51:42 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:35178 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbaGDHvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 03:51:41 -0400
Date: Fri, 4 Jul 2014 09:51:22 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: Waiman Long <waiman.long@hp.com>, Davidlohr Bueso <davidlohr@hp.com>,
        torvalds@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        mingo@kernel.org, linux-kernel@vger.kernel.org, riel@redhat.com,
        akpm@linux-foundation.org, hpa@zytor.com, andi@firstfloor.org,
        James.Bottomley@hansenpartnership.com, rostedt@goodmis.org,
        tim.c.chen@linux.intel.com, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Subject: Re: [RFC] Cancellable MCS spinlock rework
Message-ID: <20140704075122.GY19379@twins.programming.kicks-ass.net>
References: <1404318070-2856-1-git-send-email-jason.low2@hp.com>
 <20140702162749.GP19379@twins.programming.kicks-ass.net>
 <1404320356.3170.12.camel@j-VirtualBox>
 <20140702172333.GQ19379@twins.programming.kicks-ass.net>
 <1404322203.3170.17.camel@j-VirtualBox>
 <20140703073107.GS19379@twins.programming.kicks-ass.net>
 <1404407389.2498.3.camel@buesod1.americas.hpqcorp.net>
 <1404412485.8764.33.camel@j-VirtualBox>
 <53B5BE99.1090008@hp.com>
 <1404436043.8764.95.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HACzHn9G0kmbdSJa"
Content-Disposition: inline
In-Reply-To: <1404436043.8764.95.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HACzHn9G0kmbdSJa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 03, 2014 at 06:07:23PM -0700, Jason Low wrote:
> On Thu, 2014-07-03 at 16:35 -0400, Waiman Long wrote:
>=20
> > I do see a point in reducing the size of the rwsem structure. However, =
I=20
> > don't quite understand the point of converting pointers in the=20
> > optimistic_spin_queue structure to atomic_t. The structure is cacheline=
=20
> > aligned and there is no saving in size. Converting them to atomic_t doe=
s=20
> > have a bit of additional overhead of converting the encoded cpu number=
=20
> > back to the actual pointer.
> >=20
> > So my suggestion is to just change what is stored in the mutex and rwse=
m=20
> > structure to atomic_t, but keep the pointers in the=20
> > optimistic_spin_queue structure.
>=20
> Peter, would you prefer going with the above?
>=20
> If we were to keep the pointers to the next and prev nodes in the struct
> optimistic_spin_queue instead of converting them to atomic_t to store
> their cpu #, we'd still need to keep track of the cpu #. In the unqueue
> phase of osq_lock, we might have to reload prev =3D node->prev which we
> then may cmpxchg() it with the lock tail.
>=20
> The method we can think of so far would be to add a regular int variable
> to optimistic_spin_queue and initialize it to the CPU #, during the time
> we also initialize node->locked and node->next at the beginning of
> osq_lock. The cost wouldn't be much of an issue since
> optimistic_spin_queue is cache aligned.

Let me try and have an actual look at the patch; I'm in the tail end of
a flu and my head isn't quite set for details, but I'll buckle up and go
look, gimme a few :-)

--HACzHn9G0kmbdSJa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTtlz6AAoJEHZH4aRLwOS6GMoQAI1Ns72tK+JsQLLRsugBsqbM
VLdbKe41ZhsTIr1uPYuJJ2B7HgTvhF4H9TTIi5m86BCH9kB45lgoA/tSC1v0btFr
RrheM3h1ESbGCMQZWVGibOtWJbRfHO9k3bCaWZigb7d6VRz1Mq5VJGWW8FlPmtdh
41VYu+Jnr0dxOxwY034Nh009HkPrLbh/K+9ssjCnucgQVhT0Sh2GOxDBa/+17iM0
DRMu/MVnlzd822FqLp0F2IvR7gV3w822fDdejgAH/s0CCqmyPg3FXtA3um+3LpCj
6Gab5nIAIVp+z+UM+Muc1ghy3tkScswn7wnGtA1AzkA+Y1DRz4bNoKEr3bGavMEi
g1hE0hCvG81/fc94bKmwrgEJrplM88f+oRdO21ZhV9ftYBTi4Wg7R6CnzP9iRfcJ
KLaEndxEutmypcqHmYrn4DAGBHhL5IqLAXWaBYBcwqQq07zy+hZJYq4AD4MO0EUG
55/X34ZfCALs1cKZ8oHKrzimyPnwmpBLSnZFF0nJARdPBlg18zB/zopKrVHznUlE
J0RXchgfrHlm5pxH16H3uRBkL1iy9Zkfswm1kRPkQkCuvABKBILMM6q309214nrl
N1vxqG5kElLJyxmubs0NXxMwSc5w6wEj/dSHkgu309wzlLHziUGZfiAoJ85rppCR
hcrJsmEkd+LtwB/bCOwH
=Fpab
-----END PGP SIGNATURE-----

--HACzHn9G0kmbdSJa--
