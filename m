Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbaGGOfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 10:35:25 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59474 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525AbaGGOfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 10:35:23 -0400
Date: Mon, 7 Jul 2014 16:35:03 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Waiman.Long@hp.com, tglx@linutronix.de, mingo@kernel.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        paolo.bonzini@gmail.com, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, paulmck@linux.vnet.ibm.com,
        riel@redhat.com, torvalds@linux-foundation.org,
        raghavendra.kt@linux.vnet.ibm.com, david.vrabel@citrix.com,
        oleg@redhat.com, gleb@redhat.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Subject: Re: [PATCH 05/11] qspinlock: Optimize for smaller NR_CPUS
Message-ID: <20140707143503.GS6758@twins.programming.kicks-ass.net>
References: <20140615124657.264658593@chello.nl>
 <20140615130153.483502389@chello.nl>
 <53A17A88.7090705@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GWLvvOwKrQC9aCO6"
Content-Disposition: inline
In-Reply-To: <53A17A88.7090705@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GWLvvOwKrQC9aCO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 18, 2014 at 01:39:52PM +0200, Paolo Bonzini wrote:
> Il 15/06/2014 14:47, Peter Zijlstra ha scritto:
> >
> >-	for (;;) {
> >-		new =3D (val & ~_Q_PENDING_MASK) | _Q_LOCKED_VAL;
> >-
> >-		old =3D atomic_cmpxchg(&lock->val, val, new);
> >-		if (old =3D=3D val)
> >-			break;
> >-
> >-		val =3D old;
> >-	}
> >+	clear_pending_set_locked(lock, val);
> > 	return;
>=20
>=20
> Might as well add clear_pending_set_locked already in patch 3.

Patch 4, if anywhere.

--GWLvvOwKrQC9aCO6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTurAXAAoJEHZH4aRLwOS6tJMP/2/ejA34BXi0AUQBXy9sqoLV
4RvzSDvwtOwzPXS+41vrujUL9TcW0ehExmCWzDM7SRveQgpUL1UO4JezQTxI5bFd
H8W92MkEjieElMiywUCD74tAjyR5VRhISbFsKfyTI936xHxp+3EsML/uak1jEye+
Oq2qeDt5Z3s2UuGwAAEElaIJVjgpDqGoid98oWTAKn18P4Tf5aPXta2D75hPsaSE
teGnn18YtOZNsK3Poup+ILMcCzaxRz+ywXNgMSu+F37X3RRs1tU9v3yCvHMyXvW1
3VY7vLwwnuw0ZC8cyYqlPAx97Y/SO/Dufr1zRFxVXzj9onVQrB1JGqcX9w/S17+u
UpWCwGT59wCqzk6LlEXiKvMEsnHajpyO2pPHgc/QZWEY6B2zqUhq4KDEgSu7oGfa
Z9Mr6QUzhgb1ZZRnhzMjgX5ma/7TLkh5l3FykNpi/A3EY/u+Ix59Q79rU8eDza8Q
h4Hbn37SiWW+GZCCf8SruSuA5kA+tizzp+vlHY/mBOFdq1G+FN/AkcZuhgZnSxS+
4nM5+AjEihrDobaJ5qBU0TN3s9j22n0J7TCCQGKZ3fvZ00Op3VRl0IOiL7XSG463
XkvJULht9ksfz2C1+uoTs1KSaoZKu8G7VdMORXntN7Os4kA8+hznTQzK3rzv9GAZ
bEuwTxenzLrQ7GrSFUpP
=6YZk
-----END PGP SIGNATURE-----

--GWLvvOwKrQC9aCO6--
