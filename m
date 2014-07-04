Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbaGDHtf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 03:49:35 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34749 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbaGDHte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 03:49:34 -0400
Date: Fri, 4 Jul 2014 09:49:01 +0200
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
Message-ID: <20140704074901.GX19379@twins.programming.kicks-ass.net>
References: <1404318070-2856-1-git-send-email-jason.low2@hp.com>
 <20140702162749.GP19379@twins.programming.kicks-ass.net>
 <1404320356.3170.12.camel@j-VirtualBox>
 <20140702172333.GQ19379@twins.programming.kicks-ass.net>
 <1404322203.3170.17.camel@j-VirtualBox>
 <20140703073107.GS19379@twins.programming.kicks-ass.net>
 <1404407389.2498.3.camel@buesod1.americas.hpqcorp.net>
 <1404412485.8764.33.camel@j-VirtualBox>
 <53B5BE99.1090008@hp.com>
 <1404420708.8764.54.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XDqeUMnLaDfDQgU1"
Content-Disposition: inline
In-Reply-To: <1404420708.8764.54.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XDqeUMnLaDfDQgU1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 03, 2014 at 01:51:48PM -0700, Jason Low wrote:
> On Thu, 2014-07-03 at 16:35 -0400, Waiman Long wrote:
> > On 07/03/2014 02:34 PM, Jason Low wrote:
> > > On Thu, 2014-07-03 at 10:09 -0700, Davidlohr Bueso wrote:
> > >> On Thu, 2014-07-03 at 09:31 +0200, Peter Zijlstra wrote:
> > >>> On Wed, Jul 02, 2014 at 10:30:03AM -0700, Jason Low wrote:
> > >>>> Would potentially reducing the size of the rw semaphore structure =
by 32
> > >>>> bits (for all architectures using optimistic spinning) be a nice
> > >>>> benefit?
> > >>> Possibly, although I had a look at the mutex structure and we didn't
> > >>> have a hole to place it in, unlike what you found with the rwsem.
> > >> Yeah, and currently struct rw_semaphore is the largest lock we have =
in
> > >> the kernel. Shaving off space is definitely welcome.
> > > Right, especially if it could help things like xfs inode.
> > >
> >=20
> > I do see a point in reducing the size of the rwsem structure. However, =
I=20
> > don't quite understand the point of converting pointers in the=20
> > optimistic_spin_queue structure to atomic_t.
>=20
> Converting the pointers in the optimistic_spin_queue to atomic_t would
> mean we're fully operating on atomic operations instead of using the
> potentially racy cmpxchg + ACCESS_ONCE stores on the pointers.
>=20
> If we're in the process of using the CPU numbers in atomic_t, I thought
> we might as well fix that as well since it has actually been shown to
> result in lockups on some architectures. We can then avoid needing to
> implement the tricky architecture workarounds for optimistic spinning.
> Wouldn't that be a "nice-have"?

Nah, I think those archs are fundamentally broken at the moment, we
should not make code harder to read and or more complex just for them.

--XDqeUMnLaDfDQgU1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTtlxoAAoJEHZH4aRLwOS6etAQAKraA4392rhcSJIfFj6p8KUh
ZpUIH0F0yu/zhw9ShUWRR3fEGItu80yv0FKKtkOcBfreyZde6sjqh/rottvnonzx
GnOWqS5SOcmINSVEWO87obHzmTQMncOdwZM5s5Yf5ttrl5zJRW+F47dma7znaAY9
ixu06Qx/QXMQHTHBllle6pXZc+X0pY0QLz0RXLrY4Yu0FDDgYW+sV1VhzIf1m4p6
6MB94yC/4DJ6vszh/bd9T4NHidYQuatuJgaBnuHMT5zIswx0ll1dsNc8lDPWaIKv
FyqaB1MwZqTURGP40HE6+AJCQMmWbQp14wOKUxUXkc5f3RDPNMdRMBtIr9S1I7PJ
HCnsFTE/E3GIkxRJZukpNgVhEC4GSksLoc76QbtPVzT0HNIcXIDmotR32Tu0yOnu
GVA1TmvUzbFgixceoQ4c6DhqPTcjOQl77cMBic/9NHxPmNFnZvlGMgK4ELJ8di68
sr1cAwdxduXLkzokfFs7t00rWgFv3jY2nDQGm4W2yrKevwRvWZQPrj8pNQuRTzHv
gvscN9By+TdOGJwfA+2H3GkDbbiuxC1Odn83t9ntFbUBDkY9OOY6TkL7wA+oz0Qa
2C0kalKQbr3A8Ux6AWBc9+he55ZixD4vtqWPL4uooXs16B1inc/BJpooHAcneDdJ
lmS7F+QU1VaAxbDxoNCr
=blHz
-----END PGP SIGNATURE-----

--XDqeUMnLaDfDQgU1--
