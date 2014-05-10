Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbaEJONJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 10:13:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:53141 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbaEJONG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 10:13:06 -0400
Date: Sat, 10 May 2014 16:13:00 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>
Subject: Re: [PATCH v10 09/19] qspinlock: Prepare for unfair lock support
Message-ID: <20140510141300.GE30445@twins.programming.kicks-ass.net>
References: <1399474907-22206-1-git-send-email-Waiman.Long@hp.com>
 <1399474907-22206-10-git-send-email-Waiman.Long@hp.com>
 <20140508190649.GR2844@laptop.programming.kicks-ass.net>
 <536D7EA4.4060301@hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gb4bweTRjl1pQhan"
Content-Disposition: inline
In-Reply-To: <536D7EA4.4060301@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gb4bweTRjl1pQhan
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 09, 2014 at 09:19:32PM -0400, Waiman Long wrote:
> On 05/08/2014 03:06 PM, Peter Zijlstra wrote:
> >On Wed, May 07, 2014 at 11:01:37AM -0400, Waiman Long wrote:
> >>If unfair lock is supported, the lock acquisition loop at the end of
> >>the queue_spin_lock_slowpath() function may need to detect the fact
> >>the lock can be stolen. Code are added for the stolen lock detection.
> >>
> >>A new qhead macro is also defined as a shorthand for mcs.locked.
> >NAK, unfair should be a pure test-and-set lock.
>=20
> I have performance data showing that a simple test-and-set lock does not
> scale well. That is the primary reason of ditching the test-and-set lock =
and
> use a more complicated scheme which scales better.

Nobody should give a fuck about scalability in this case anyway.

Also, as I explained/asked earlier:

  lkml.kernel.org/r/20140314083001.GN27965@twins.programming.kicks-ass.net

Lock holder preemption is _way_ worse with any kind of queueing. You've
not explained how the simple 3 cpu example in that email gets better
performance than a test-and-set lock.

> Also, it will be hard to
> make the unfair test-and-set lock code to coexist nicely with PV spinlock
> code.

That's just complete crap as the test-and-set lock is like 3 lines of
code.

--gb4bweTRjl1pQhan
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTbjPsAAoJEHZH4aRLwOS6DHoQAI8k9IXmkcWjHX8w+HY70xEC
5r+6ofM4q2UqO92eoq7fCDKxRIHw8N0IL1HwmXL80IayZgm5l9KEm6b8eMzRAGUo
dhKqnAU1Fx2T0Qq+AES5PBHscwz7cbWA6wkxzkW4BqHuzI0oa6KpVo1sXsFdurpp
zgbGY+CwfvCHc9EYiG5zrxGyqerICuSoh+JnLx/upwsI7qwtepNzH0BmJuY30kr6
HZQ5tH4gFC6IT9Lb7zRCi8PYU+KWfQxEFB5gKwKpqr+Tl+QrZQf/hNyuA8tbGrZo
4JdguKqshFxqCpQ5KER+Is6vgryVxGzxWfBWskICYsORxX59RGHzWfUN56a+tgNG
lHa+mQDn9OT1jcLxZvadBecMGhEP+yIrXN90/laPSXS5UZlla7WWLcDR+qi65EWY
dJuaCsmvRqD5qqnUfa9ScWlQO9pC1jZ/QJKPPwS/dh7MpiHkWkmbY7+quBq64xof
Kjy6qxGkm+4FpgoUlOw4cvLnmgbsWc8Z8sHPI/E0og/47ZGzpg0Uprbo/GZ2tSLQ
eJni0kbQnulnlSoCQLvdhGWLhV5ZxGSBs3nlqKzqBDI8r2/p4Bd7D7eRd3jwTVWu
l57WRcuAPduyBK/2LWY6epnQW3IiC+ShpcX2qBeCWFeoZyZAGMP43aZFcuD3aDXR
TcUPJ51KjXE+eyEQpsNp
=fEVE
-----END PGP SIGNATURE-----

--gb4bweTRjl1pQhan--
