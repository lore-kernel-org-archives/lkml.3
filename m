Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbaHMNkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 09:40:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:44571 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168AbaHMNkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 09:40:39 -0400
Date: Wed, 13 Aug 2014 15:40:25 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v5 tip/core/rcu 15/16] rcu: Make RCU-tasks wait for idle
 tasks
Message-ID: <20140813134025.GN9918@twins.programming.kicks-ass.net>
References: <20140811224840.GA25594@linux.vnet.ibm.com>
 <1407797345-28227-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1407797345-28227-15-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140813081215.GB9918@twins.programming.kicks-ass.net>
 <20140813124818.GQ4752@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="t9kF86vOGmrWaBDV"
Content-Disposition: inline
In-Reply-To: <20140813124818.GQ4752@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--t9kF86vOGmrWaBDV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 13, 2014 at 05:48:18AM -0700, Paul E. McKenney wrote:
> On Wed, Aug 13, 2014 at 10:12:15AM +0200, Peter Zijlstra wrote:
> > On Mon, Aug 11, 2014 at 03:49:04PM -0700, Paul E. McKenney wrote:
> > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > >=20
> > > Because idle-task code may need to be patched, RCU-tasks need to wait
> > > for idle tasks to schedule.  This commit therefore detects this case
> > > via context switch.  Block CPU hotplug during this time to avoid send=
ing
> > > IPIs to offline CPUs.
> > >=20
> > > Note that checking for changes in the dyntick-idle counters is tempti=
ng,
> > > but wrong.  The reason that it is wrong is that a interrupt or NMI can
> > > increment these counters without necessarily allowing the idle tasks =
to
> > > make any forward progress.
> >=20
> > I'm going to NAK this.. with that rcu_idle patch I send there's
> > typically only a single idle function thats out of bounds and if its
> > more it can be made that with a bit of tlc to the cpuidle driver in
> > question.
> >=20
> > This needs _FAR_ more justification than a maybe and a want.
>=20
> Peter, your patch might be a good start, but I didn't see any reaction
> from Steven or Masami and it did only x86.

That's not an excuse for doing horrible things. And inventing new infra
that needs to wake all CPUs is horrible.

--t9kF86vOGmrWaBDV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT62rJAAoJEHZH4aRLwOS6R/gQAJWfG+j8jN5xgk8NPk7hdrZ/
jIvVzsxTX+GL2yYUza5rKRHl2AynPvgH92Au07ninkcHzSHFptHL7MxfKfqdztYW
rcQnHXw0DRigY+LB86TkgEs7paLIt/Qjp6OtEjwyVqyVElCzgLhWx0aFGASR5usV
DVv0ASYrRg9gaPzCSLsUilgyB9JeQEi/571YkDJRpkpedn3IXToWgz50AyQ5/eKJ
jgKQ2t5dQzzFt3B/JQHP+je+4qJJ0uZdNKSf6ddHSvLc2nM3FzDs1yGgn28H6nSZ
qLeekfKlmVj/gIGJLTe5GLCk/731FK43aQGYB+RXw+AmEy++jKP5PwShmCgTVEVo
HDvMm90GsbuSBw6zTbbiuN8lyFllV5jjsokksa62fbo977p3+LeiB8i7eYkGMT8f
hBEbNBGdZwkybW8MX/ZZtyZAzCQMHqMnnbO7+BesccTpD+vEnLwxc1PtvQTqheXs
M7lDDNdwJkOKGxRTRyvBIJyeMaHnRXESRpsPgyGfoBgLG7uU6TwB6gDBj28+ttgt
FD3N9OmxnUk410nCvHT83msda+P51lzdMQU8BwJGf9GjVWJju8iiTcPYQMl1TW/W
guZ7wybD7o4ceIwJ32ZzBCiYIWJq+SdVzcAVQpntihTk/XytqpwQroLiHReg8SzW
ADdrgu88eRpqdE2v1Czg
=Ljva
-----END PGP SIGNATURE-----

--t9kF86vOGmrWaBDV--
