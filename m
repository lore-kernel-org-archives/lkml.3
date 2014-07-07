Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624AbaGGOwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 10:52:07 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49045 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523AbaGGOwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 10:52:02 -0400
Date: Mon, 7 Jul 2014 16:51:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Waiman.Long@hp.com, tglx@linutronix.de, mingo@kernel.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        paolo.bonzini@gmail.com, boris.ostrovsky@oracle.com,
        paulmck@linux.vnet.ibm.com, riel@redhat.com,
        torvalds@linux-foundation.org, raghavendra.kt@linux.vnet.ibm.com,
        david.vrabel@citrix.com, oleg@redhat.com, gleb@redhat.com,
        scott.norton@hp.com, chegu_vinod@hp.com
Subject: Re: [PATCH 07/11] qspinlock: Use a simple write to grab the lock, if
 applicable
Message-ID: <20140707145145.GT6758@twins.programming.kicks-ass.net>
References: <20140615124657.264658593@chello.nl>
 <20140615130153.786898559@chello.nl>
 <20140618163615.GA5331@laptop.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pU61X8j5lbVWa/m1"
Content-Disposition: inline
In-Reply-To: <20140618163615.GA5331@laptop.dumpdata.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pU61X8j5lbVWa/m1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 18, 2014 at 12:36:15PM -0400, Konrad Rzeszutek Wilk wrote:
> On Sun, Jun 15, 2014 at 02:47:04PM +0200, Peter Zijlstra wrote:
> > From: Waiman Long <Waiman.Long@hp.com>
> >=20
> > Currently, atomic_cmpxchg() is used to get the lock. However, this is
> > not really necessary if there is more than one task in the queue and
> > the queue head don't need to reset the queue code word. For that case,
>=20
> s/queue code word/tail {number,value}/ ?
>=20
>=20
> > a simple write to set the lock bit is enough as the queue head will
> > be the only one eligible to get the lock as long as it checks that
> > both the lock and pending bits are not set. The current pending bit
> > waiting code will ensure that the bit will not be set as soon as the
> > queue code word (tail) in the lock is set.
>=20
> Just use the same word as above.

I made that:

Currently, atomic_cmpxchg() is used to get the lock. However, this is
not really necessary if there is more than one task in the queue and
the queue head doesn't need to reset the queue tail.

For that case, a simple write to set the lock byte is enough as the
queue head will be the only one eligible to get the lock as long as it
checks that both the lock and pending bits are not set. The current
pending bit waiting code will ensure that the bit will not be set as
soon as the queue tail is set.

--pU61X8j5lbVWa/m1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTurQBAAoJEHZH4aRLwOS6WToP/0klEyJW66JPUpNtJF1tneQM
Oq1eDjkll1dWXWFFOveinihYFNAdsY+Fy6eLc2qlkKPRExlsLwoT5xab4KW9n/cb
Mx8tFFiWhsY20pwJh7Nw0q0xEWiHanEwdbAUESbVj1adxpzLpXq6hRscslJfO/Id
5n7zAv41QZAejY+wO/pau5j/CDTrIXKbGexKaC4X01OOlDEjHBP12R0uqL2gu2Vj
OfjmCLmFa/3kjhLuxFsQplRnQ5/j2WgKFqXmxcstT9i/bu3gCpRxSIuuYpjWSf+q
j4MNlm7wvWnXn3eEMtXjFQwyTJArJWBSED/kCqOluaumhAhn+2AMYLpZ9UUZO37t
xywiPnbfOB2I/HdsiJlbuueqJdrzYZRqssuPjJhmNyc7d8nkOMEL+JtPd8F5H9wi
qH6M3NUhTvH20aehcozqz0lS6LqT0hl6BlASgHxeEXNvS31c5UwVlinLPXfrTM1E
8PZ843CAyQ4i3laxNvxh4FclWFTDWP0vRkHHN6xF9UTmsHR/MrIVQ2TE5AkLsKWn
qXZp82wlREbwKCkmpENr0UwtPfD7ARhkUVbcPA4suFblo6iDbjgbcNOVKlxHXrTQ
cEYgmzh/ARl7kISFvsI28Yrq9AwRQvwlpV8qcBQxxVG2SDxkIRXkpcNfEcDzdJGo
u9rgaONm5H8a/5fSyxtl
=gXci
-----END PGP SIGNATURE-----

--pU61X8j5lbVWa/m1--
