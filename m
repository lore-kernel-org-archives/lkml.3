Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071AbaGNL6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 07:58:21 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41963 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821AbaGNL6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 07:58:03 -0400
Date: Mon, 14 Jul 2014 13:57:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 3/4] documentation: Add acquire/release
 barriers to pairing rules
Message-ID: <20140714115738.GW19379@twins.programming.kicks-ass.net>
References: <20140707222345.GA6320@linux.vnet.ibm.com>
 <1404771862-6904-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1404771862-6904-3-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140708075902.GM19379@twins.programming.kicks-ass.net>
 <20140708153117.GJ4603@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E0QWZJXrJvPb9tCa"
Content-Disposition: inline
In-Reply-To: <20140708153117.GJ4603@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--E0QWZJXrJvPb9tCa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 08, 2014 at 08:31:17AM -0700, Paul E. McKenney wrote:

> Good point, how about the following?
>=20
> 	General barriers pair with each other, though they also pair
> 	with most other types of barriers, albeit without transitivity.

> 	An acquire barrier pairs with a release barrier, but both may also
> 	pair with other barriers, including of course general barriers.

> 	A write barrier pairs with a data dependency barrier, an acquire
> 	barrier, a release barrier, a read barrier, or a general barrier.

> 	Similarly a read barrier or a data dependency barrier pairs
> 	with a write barrier, an acquire barrier, a release barrier,
> 	or a general barrier:

It might be clearer with the added whitespace, or as an explicit list  I
suppose, but yes.

> > Also, it might be good to have a section on the ramifications of pairing
> > acquire/release with other than themselves, I have the feeling there's
> > subtle things there.
>=20
> It can get quite subtle.  For the time being, I am dodging this subtlety
> by saying that only general barriers provide transitivity (see the
> "TRANSITIVITY" section).

Ah, I was more thinking of the fact that ACQUIRE/RELEASE are
semi-permeable while READ/WRITE are memop dependent.

So any combination will be a semi-permeable memop dependent thing,
which is the most narrow barrier possible.

So if we thing of ACQUIRE/RELEASE as being 'half' a full barrier,
separated in direction, and READ/WRITE as being 'half' a full barrier
separated on type, then the combination is a 'quarter' barrier.

Not arguing they're not useful, just saying we need to be extra careful.

> Maybe some day we should capture this subtlety in memory-barriers.txt,
> but we will first need a new generation of small children who are not
> scared by the current document.  ;-)

Lolz :-)

--E0QWZJXrJvPb9tCa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTw8WyAAoJEHZH4aRLwOS6AIkQAIIQiMP+6S1f0uU0wMnVWrVa
D9txvJPYftQ7pOr1+b28M8EySv/YXFrNyzToMUVjufHSaZYemSRQaqYgojmN2e4l
CQtG7bS0H3Dg5meAwcFkLBywkMchJkdMLcjH+2hhijVFoM0PYTL4C88cuFUdXT9t
7PswSGQDOCVHbmkouopf+A3l/FHExU5IVvgZiA3qkZvzn50qtqcnBTqwz+c/ebOn
4u1613bdg2q4cxFy0V73pKiWid6xCN5OiQasAma4vmQiDXlPIj8J0s8Fu/sQAWts
Ykd/BZpF26Y/kp4Qa5eP6yfwy31oZEFNHa+gd5xx40sRMU3bDowcXlg9BsUBesbN
CQkVdR6IBoDGvEQAhEtDGFrurBd9lgGHyQS120pY0aPJVN4tjgKrVRPi2vImyWet
ZrhWgMQNlwivaCtqIq0h375Ukx902yJLaHJY4skd+vm0tHyUmBRunRoUeyPOwxG6
DrI/TcmPjxm/T7YE8YmfF5uT0nmQtvUEl47GC3PUqFzdrLeWdraIF230Id/W2r7m
3nEFxqr1kdqeoKcgy5Dj/m8Ca8i4Q1XxGdp+CRyrBTe6i8PnSRQ5Wce7fFnJVj4i
8Djlp6gW4BHEBDatK5DITKAs+1QUperotUI7UmYPvjYoI0y0det+UZLcBch52qGe
Sxht2hsJC24bNCMFgwHL
=cAyv
-----END PGP SIGNATURE-----

--E0QWZJXrJvPb9tCa--
