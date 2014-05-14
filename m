Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbaENJWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 05:22:39 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54638 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbaENJWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 05:22:34 -0400
Date: Wed, 14 May 2014 11:22:03 +0200
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
Message-ID: <20140514092203.GE30445@twins.programming.kicks-ass.net>
References: <20140512190438.314125476@linutronix.de>
 <20140513035404.GA68181@dvhart-mac01.local>
 <537313FD.4000306@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5kA4nwuSW3j1l9NB"
Content-Disposition: inline
In-Reply-To: <537313FD.4000306@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5kA4nwuSW3j1l9NB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2014 at 02:58:05AM -0400, Carlos O'Donell wrote:
> >>    The handling of -EDEADLOCK is even more impressive. Instead of
> >>    propagating it to the caller something in the guts of glibc calls p=
ause().
> >>
> >>      futex(0x601300, FUTEX_LOCK_PI_PRIVATE, 1) =3D -1 EDEADLK (Resourc=
e deadlock avoided)
> >>      pause(
> >>
> >=20
> > Gotta love comments like these though - such trust!:
> >=20
> > 	/* The mutex is locked.  The kernel will now take care of
> >            everything. */
> >=20
> > IIRC, glibc takes the approach that if this operation fails, there is n=
o way for
> > it to recovery "properly", and so it chooses to:
> >=20
> > 	/* Delay the thread indefinitely. */
> >=20
> > I believe the thinking goes that if we get to here, then the lock is in=
 an
> > inconsistent state (between kernel and userspace). I don't have an answ=
er for
> > why pausing forever would be preferable to returning an error however...
>=20
> What error would we return?

EDEADLK is a valid user return for pthread_mutex_lock() as per:

  http://pubs.opengroup.org/onlinepubs/009695399/functions/pthread_mutex_lo=
ck.html

> This particular case is a serious error for which we have no good error c=
ode
> to return to userspace. It's an implementation defect, a bug, we should p=
robably
> assert instead of pausing.

No, its perfectly fine to have a lock sequence abort with -EDEADLK.
Userspace should release its locks and re-attempt.

You can implement usable locking schemes using this error, like
wound/wait locking.

> We can't cancel the stuck thread because pthread_mutex_lock is not a canc=
ellation
> point.
>=20
> In practice the rest of the application can make forward progress with a =
single
> thread stuck. You can attach the debugger and inspect state, so it's usef=
ul
> from that perspective.

That's just totally braindead. Return EDEADLK to userspace already, let
the user deal with it.

--5kA4nwuSW3j1l9NB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTczW7AAoJEHZH4aRLwOS6pzgQAI70iMvU3yk2Ahd8PtVURdYQ
rtN6s5zkoFEQRnZalazorjeBZQECaq/Np8T1sQ90hD4P2BxPyCsrAcDo7rE1jpzW
OlURmylN2FKu3wEK3Bzz6GR+LARECprvVOGGHn0sQRKHdPLVmVLxq1hKMggEyuck
nU5Ut78ZD+fboKRhUei/c+S2Q6VYqbaRbbv5gb4YCgvM1aTr4BVSFLAyCu1D10m1
Inn9N2N43wq9319znjHfw1QM4cG6IzUx4433mzCt+Jz0l+93f+ZO2Cgd+XBbY7SX
AmJp766xQtY4xgATRFDM/kht8wQIZGUGrIVHEKijSrCAVr2XUHv3/Q9+5EOJ3hB8
3nniZXRRnI7cMYXvapChCXWNKYlMbWsCH7+yyndGH8J+2NBQloCCZom0GkyEtO8m
Wu0+gQm2gGT7lDV91m56eiD4MWfInJdaxKV7AQv6CDweqrfuWuGGQgLAHS0nO4ZS
5L9dcPQlonhHFaoYriFFnKnMbCZjAAD/uzfd9lEwMfbk53x92NqNtaennH+W7olT
Qmq3l3K2aquikWedz1+GKpa5r0vH+bfydT+dZf+V8k8ve/kVB4RFdFBBQb8jQnEN
ZJ8g8hgqXZa7NUVvS0ukPAEQlFdgRqOcABGhzEKzvPanpygLy+PpYN742AtGcM6O
7isnRbgUD/mHFtjcV8y8
=1Dmi
-----END PGP SIGNATURE-----

--5kA4nwuSW3j1l9NB--
