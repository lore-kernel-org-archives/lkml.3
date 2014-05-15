Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbaEOIIF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 04:08:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:56489 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158AbaEOIIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 04:08:01 -0400
Date: Thu, 15 May 2014 10:07:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Carlos O'Donell" <carlos@redhat.com>
Cc: Darren Hart <dvhart@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Darren Hart <darren@dvhart.com>, Davidlohr Bueso <davidlohr@hp.com>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Clark Williams <williams@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Roland McGrath <roland@hack.frob.com>,
        Jakub Jelinek <jakub@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [patch 0/3] futex/rtmutex: Fix issues exposed by trinity
Message-ID: <20140515080753.GB30445@twins.programming.kicks-ass.net>
References: <20140512190438.314125476@linutronix.de>
 <20140513035404.GA68181@dvhart-mac01.local>
 <537313FD.4000306@redhat.com>
 <20140514092203.GE30445@twins.programming.kicks-ass.net>
 <5373DD6F.40506@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="j5904Piqecmxrsp+"
Content-Disposition: inline
In-Reply-To: <5373DD6F.40506@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--j5904Piqecmxrsp+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2014 at 05:17:35PM -0400, Carlos O'Donell wrote:
> > No, its perfectly fine to have a lock sequence abort with -EDEADLK.
> > Userspace should release its locks and re-attempt.
>=20
> I agree. If I can prove that it's actually a deadlock, and
> that unlock/relock will work to fix it, then we can arrange for glibc
> to return EDEADLK.

The only reason the kernel would return EDEADLK is because its walked
the lock graph and determined its well, a deadlock.

--j5904Piqecmxrsp+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdHXZAAoJEHZH4aRLwOS6tP0P/1Z2C3yyXPzdKxOUgpCq6iuS
N8j55e1YCH/44aYAfEJ9OZ6sOPIxkK+8UR5PONTn0/LrTeZzKLx2nBjzk1krrTwT
CH3DOWi57GKqDcb/m6WAps5cpb7GwwUJe6/OoDMiR6tH/9407l3IM2sZyMMJOMG4
Hjf1Uho9+y54MIK6nodViLSWG8QWv1fyONKwIAZps/7f4NiAY+WbfBigGwiwya70
H6zz6dF8M6SJzHxKGO9ABCFzOnFPhC4+xMKq8islTkxerKooVaVzjse8pGxCiIb8
2LbOhA/53AtHe6Fbo5xZAdgs6+O8wTYxQwSz61WCzHlrGKjyWlG8YmLYWeMfFGhq
7Hzv+kCYBBoC4bBFGaDyxmR+cvdcl3dPEs5nuMcW90O0qiTV6SGGV3sB+n1tzue6
eYLGMmGBmSMXKATLfX3ho0YXddITWWByWOnwgoUOkRwdkTSVMTQoGustAMsgeSms
zd9TkUhNFmCQOFzpaY6+t4z53E9/hvu/LR9BJl378kCDunRgJXRqfw+S+aL1fyG4
Ex73ZBd3tmYU0loy19vX6yLj8HBo2g1XTU0LGgJ9e+XNjE8AI7O8Xu7BDlCGicLs
Cj0pE4ZsQy2Jg9rdU88KnPbxZpQmV1S1Ot+prf+OaXmwewA6hhzm1ZzaLR8F2rqn
V9dL4TPfmGkY0E3CA9pI
=u01b
-----END PGP SIGNATURE-----

--j5904Piqecmxrsp+--
