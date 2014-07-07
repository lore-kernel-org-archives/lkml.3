Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbaGGPgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:36:16 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59010 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaGGPgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:36:14 -0400
Date: Mon, 7 Jul 2014 17:35:52 +0200
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
Message-ID: <20140707153552.GE19379@twins.programming.kicks-ass.net>
References: <20140615124657.264658593@chello.nl>
 <20140615130153.483502389@chello.nl>
 <53A17A88.7090705@redhat.com>
 <20140707143503.GS6758@twins.programming.kicks-ass.net>
 <53BAB7E1.4010506@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FWV58dOTQOM6W93I"
Content-Disposition: inline
In-Reply-To: <53BAB7E1.4010506@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FWV58dOTQOM6W93I
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 07, 2014 at 05:08:17PM +0200, Paolo Bonzini wrote:
> Il 07/07/2014 16:35, Peter Zijlstra ha scritto:
> >On Wed, Jun 18, 2014 at 01:39:52PM +0200, Paolo Bonzini wrote:
> >>Il 15/06/2014 14:47, Peter Zijlstra ha scritto:
> >>>
> >>>-	for (;;) {
> >>>-		new =3D (val & ~_Q_PENDING_MASK) | _Q_LOCKED_VAL;
> >>>-
> >>>-		old =3D atomic_cmpxchg(&lock->val, val, new);
> >>>-		if (old =3D=3D val)
> >>>-			break;
> >>>-
> >>>-		val =3D old;
> >>>-	}
> >>>+	clear_pending_set_locked(lock, val);
> >>>	return;
> >>
> >>
> >>Might as well add clear_pending_set_locked already in patch 3.
> >
> >Patch 4, if anywhere.
> >
>=20
> This code is added in patch 3:
>=20
> +	/*
> +	 * take ownership and clear the pending bit.
> +	 *
> +	 * *,1,0 -> *,0,1
> +	 */
> +	for (;;) {
> +		new =3D (val & ~_Q_PENDING_MASK) | _Q_LOCKED_VAL;
> +
> +		old =3D atomic_cmpxchg(&lock->val, val, new);
> +		if (old =3D=3D val)
> +			break;
> +
> +		val =3D old;
> +	}
> +	return;
>=20
> Unlike the change in patch 4, clear_pending_set_locked doesn't change how
> qspinlock moves from a state to the next.

True, but its where we start to break up into smaller functions. And the
only reason we break them out is because we'll get different
implementations depending on NR_CPUS.

So we can view the breakout of xchg_tail and clear_and_set_pending as
preparatory work for introducing the NR_CPUS thing.

--FWV58dOTQOM6W93I
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTur5YAAoJEHZH4aRLwOS6g3kQAKXtlRCvCSg2g2sPmw3PnenM
KOImaErwG99JHISCd2HIb2apdNU0AoZ+PYUF1TtHfIK0K3ISP05z81srYDLJ8xGS
A5ajSkLMF6H+cAqQdXa2H8BnuOUSJtdg5D+0hPRugjtuzOrHrow0otYIKlFJOPZ0
0Nlvr3zGg9bUTLKLBJzEN2rLAmrVTooo/07TbDf2JGpf3c95i3Z13xebLDGIoru6
HtD1yl24i6K/I8ZK6oDiiKv7JJf/QH+Zwmb1rATjITy5D4koHleWLm7k1E7Tjl3t
zqSU+NU+68i18cFlZ5IRfL3W3D4lB/Hjtpeb0mZSbMN5MJKxZdmpKPz03kHEI+j5
8t2CE8cEMISyuGLSl1Q44hUrchKcdRcga52E/0VbRmL838T3j+bOzdmjPwZ8doL8
IB9yoG0+uR+TtEhgWro4f+esE6WQ6kIpAjFzBuiUVmu6gwPUsvb2XEu58bLzCsWf
RTp338Vpbtb8Rafnjbj5uJlYJgFePRlFWure7CtmNgl9rhEbkJMtqcoBlK4+BLl2
W2t5melO9VI74J20x6oS1N3ZCTZxebaC/dfCVzHl3QEi1NMX4TusHHPsSV0lu+Of
wvcfhaOeraRmPzvs3krCRIPvhjNIeAl/2A9jupThdM6FEh+/EoEQybEZq6YhpMfp
G03clWJdHdCmzBkHpZa0
=IqHF
-----END PGP SIGNATURE-----

--FWV58dOTQOM6W93I--
