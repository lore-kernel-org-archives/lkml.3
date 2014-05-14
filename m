Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbaENKH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 06:07:29 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36108 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbaENKH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 06:07:26 -0400
Date: Wed, 14 May 2014 12:07:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Carlos O'Donell" <carlos@redhat.com>,
        Darren Hart <dvhart@linux.intel.com>,
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
Message-ID: <20140514100705.GH30445@twins.programming.kicks-ass.net>
References: <20140512190438.314125476@linutronix.de>
 <20140513035404.GA68181@dvhart-mac01.local>
 <537313FD.4000306@redhat.com>
 <alpine.DEB.2.02.1405141034320.6261@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0i4az6ru2FyWQ2bd"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1405141034320.6261@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0i4az6ru2FyWQ2bd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2014 at 11:53:44AM +0200, Thomas Gleixner wrote:
> > What error would we return?
> >
> > This particular case is a serious error for which we have no good error=
 code
> > to return to userspace. It's an implementation defect, a bug, we should=
 probably
> > assert instead of pausing.
>=20
> Errm.
>=20
> http://pubs.opengroup.org/onlinepubs/7908799/xsh/pthread_mutex_lock.html
>=20
>  The pthread_mutex_lock() function may fail if:
>=20
>   [EDEADLK]
>     The current thread already owns the mutex.=20
>=20
> That's a exactly the error code, which the kernel returns when it
> detects a deadlock.=20
>=20
> And glibc returns EDEADLK at a lot of places already. So in that case
> it's not a serious error? Because it's detected by glibc. You can't be
> serious about that.
>=20
> So why is a kernel detected deadlock different? Because it detects not
> only AA, it detects ABBA and more. But it's still a dead lock. And
> while posix spec only talks about AA, it's the very same issue.
>=20
> So why not propagate this to the caller so he gets an alert right away
> instead of letting him attach a debugger, and scratch his head and
> lookup glibc source to find out why the hell glibc called pause.

  http://pubs.opengroup.org/onlinepubs/009695399/functions/pthread_mutex_lo=
ck.html

  The pthread_mutex_lock() function may fail if:

  [EDEADLK]
      A deadlock condition was detected or the current thread already owns =
the mutex.

Which is explicitly wider than the AA recursion and fully supports the
full lock graph traversal we do.

--0i4az6ru2FyWQ2bd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTc0BJAAoJEHZH4aRLwOS65g8P/26RZ2SCXiNB0ltNJsvM1SES
JR8cPrLh7ulD9C97aOfJFn6mDVgPkn4tUQm2V+0Mpr4wni4dtq8hJaPrp3txpiGT
yh2ujBqgV1CDWdIajnk3ZzARecSDFpARQA8oc2jAfAJV0YpcYEa62HUmBYlwnDnt
1hBrhUWtSVL7NIbXFrzszDa45rAmmIUVJGqlXQEDjNaRNonPkeMbNle3vPu28Q77
NSooTft2TQ7wwR/XOdk4P7TRgZgqi2quJqWPqFaOeHPxsKWBDRgCkMPeZkoFRYbK
3dUcBtR0skPQhOwss/vRpPPzJfM45Np1D6Eq6GDRUApW1HRkidHK12RNOKuWOZi6
6o4T9iG5PC5SGLoHukkXOohDtCZRVQPQ+8y9aR/jVFoBIPS7vMkc9s6xoG6TZmz3
PejKFc7tWHqHl8C9aJMbDtOiPIg1esj9p6mol70F7ESi0UkqORS+L8s1pGZAq1/8
hafUXhHBBbxh4OZmmXS0/VH/9CCtlMcnup0z1erQ6cWs7dlZzBlJQue43lovEX4c
sO6Isk1ow4pW/DwfScHp5ytbYYiEwLYTYlbQdSCWFnJhxt7xlbW9Tdu1LGqOtgqv
e431j1u5HFwxOsiBCTvK603X9QU0uND1Trbxx6qkpWYMGC+ZL30cwHWHGmpJbpyL
EIAS/zs+JMenT0GJMYQI
=k5fr
-----END PGP SIGNATURE-----

--0i4az6ru2FyWQ2bd--
