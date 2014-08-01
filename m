Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbaHAIFx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 04:05:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:51168 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaHAIFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 04:05:49 -0400
Date: Fri, 1 Aug 2014 10:05:36 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: kan.liang@intel.com, andi@firstfloor.org,
        alexander.shishkin@linux.intel.com, linux-kernel@vger.kernel.org,
        jakub@redhat.com
Subject: Re: [PATCH 1/3] x86 msr: msr goto extension support
Message-ID: <20140801080536.GH19379@twins.programming.kicks-ass.net>
References: <1406799663-18192-1-git-send-email-kan.liang@intel.com>
 <53DAAFAC.9000502@amacapital.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UT6dh/PAtY8YefgB"
Content-Disposition: inline
In-Reply-To: <53DAAFAC.9000502@amacapital.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UT6dh/PAtY8YefgB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 31, 2014 at 02:05:48PM -0700, Andy Lutomirski wrote:
> On 07/31/2014 02:41 AM, kan.liang@intel.com wrote:
> > +/*
> > + * The _goto version is rdmsrl/wrmsrl with exception handling
> > + * The advantage (than _safe) is that it can directly jump in the
> > + * exception handling code, and never test in the "fast" path.
> > + *
> > + * Since _goto doesn't support output, try to protect the output
> > + * registers by clobbers, and process the registers immediately.
> > + */
> > +#define rdmsrl_goto(msr, result, fail_label)			\
> > +do {								\
> > +	DECLARE_ARGS(val, low, high);				\
> > +	asm_volatile_goto("2: rdmsr\n"				\
> > +			"1:\n\t"				\
> > +			_ASM_EXTABLE(2b, %l[fail_label])	\
> > +			: /* No outputs. */			\
> > +			: "c" (msr)				\
> > +			: "%rax", "%rdx"			\
> > +			: fail_label);				\
> > +	asm volatile (""					\
> > +			: EAX_EDX_RET(val, low, high)		\
> > +			: );					\
>=20
> This is scary -- the compiler is free to optimize this incorrectly, and
> it doesn't even seem very farfetched to me.

Quite so, lets add Jakub.

--UT6dh/PAtY8YefgB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT20pQAAoJEHZH4aRLwOS6EHgP/jfHdJeqQ0fF7Jzw3NxcNHX8
vrh/7NK/fVTp3JJ+p7GQ70HGq3pA0c8vuBHcSRuHTPgHTq5XNfque9B7DAQcNhBg
FMmNMf5bXYKbMw09kQlB0vS/0D+EmEqA/0gktYoPu1Knh7YhZqN/OZXb8u9by3UN
5dFC/1bKlXd1g17yctPBFObPnVu6WS7bAy6epywZVteVrjVRaljbnEvmIn03FAX7
a2KdvRMjq0QmHg4GIDbKzbqV8+nbHzVVVvLObzi/XDAvahu/YgjdchjI1zAx/OYK
/6w50SlF3zWvKwpR3zzIMuAhAPjPj3ANm+ctuDZB4UI1tyFT8NeXrMZNUUwoGNEI
YDQq5gfqp5qnpaC/lNKqtZt+Oef8uQJsPBdspWJWODcr4K7FOkJiMsxHrMmGMvvL
x2q/OExYSjl6RaKLtt7DoyKyub51HhJmoKclaUbhDYyQJ7JzK1reMjnSf2z4viv1
x3eqWq505qTyUeQUoZGnSooJJyVxvtzcWnp7+vwelAOsbK/VxcMssF244ONwT1Xk
FcN5EuO0/iVU7BFots8VWQpZoUiPF2vVpNa3/nEZi9TTNnbXHOWouXFXevhYSLXV
nvwWGcEiwR8XSzOpuX2SLpinEiHlnmaEXCIIhcGLlOzLk/HWcYMdekSVPidbRCr6
4f298pMW5jesUQEr1B/j
=io09
-----END PGP SIGNATURE-----

--UT6dh/PAtY8YefgB--
