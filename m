Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367AbaISUx4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 16:53:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:58229 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932297AbaISUxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 16:53:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,557,1406617200"; 
   d="asc'?scan'208";a="575903129"
Message-ID: <1411160033.2513.28.camel@jtkirshe-mobl>
Subject: Re: [PATCH 3/7] atomic: Silence nested-externs warnings
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: sparse@chrisli.org, Mark Rustad <mark.d.rustad@intel.com>,
        linux-sparse@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Brian Norris <computersforpeace@gmail.com>
Date: Fri, 19 Sep 2014 13:53:53 -0700
In-Reply-To: <20140919204303.GF2832@worktop.localdomain>
References: <1411140580-20909-1-git-send-email-jeffrey.t.kirsher@intel.com>
	 <1411140580-20909-4-git-send-email-jeffrey.t.kirsher@intel.com>
	 <20140919204303.GF2832@worktop.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-zb3dReDmJd9HCh0K3LLP"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-zb3dReDmJd9HCh0K3LLP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2014-09-19 at 22:43 +0200, Peter Zijlstra wrote:
> On Fri, Sep 19, 2014 at 08:29:36AM -0700, Jeff Kirsher wrote:
> > From: Mark Rustad <mark.d.rustad@intel.com>
> >=20
> > Silence the nested-externs warnings for these, as they are
> > truly wanted.
> >=20
>=20
> You're patching an old tree.

Sorry, I used Linus's latest tree (as of last night) because of number
of the patches in the series went to various trees, so I used Linus's
tree.

>=20
> ---
> commit 2e39465abc4b7856a0ea6fcf4f6b4668bb5db877
> Author: Peter Zijlstra <peterz@infradead.org>
> Date:   Mon Aug 4 12:07:15 2014 +0200
>=20
>     locking: Remove deprecated smp_mb__() barriers
>    =20
>     Its been a while and there are no in-tree users left, so remove the
>     deprecated barriers.
>    =20
>     Signed-off-by: Peter Zijlstra <peterz@infradead.org>
>     Cc: Chen, Gong <gong.chen@linux.intel.com>
>     Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
>     Cc: Joe Perches <joe@perches.com>
>     Cc: John Sullivan <jsrhbz@kanargh.force9.co.uk>
>     Cc: Linus Torvalds <torvalds@linux-foundation.org>
>     Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>     Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
>     Cc: Theodore Ts'o <tytso@mit.edu>
>     Signed-off-by: Ingo Molnar <mingo@kernel.org>
>=20
> diff --git a/include/linux/atomic.h b/include/linux/atomic.h
> index fef3a80..5b08a85 100644
> --- a/include/linux/atomic.h
> +++ b/include/linux/atomic.h
> @@ -3,42 +3,6 @@
>  #define _LINUX_ATOMIC_H
>  #include <asm/atomic.h>
> =20
> -/*
> - * Provide __deprecated wrappers for the new interface, avoid flag day c=
hanges.
> - * We need the ugly external functions to break header recursion hell.
> - */
> -#ifndef smp_mb__before_atomic_inc
> -static inline void __deprecated smp_mb__before_atomic_inc(void)
> -{
> -	extern void __smp_mb__before_atomic(void);
> -	__smp_mb__before_atomic();
> -}
> -#endif
> -
> -#ifndef smp_mb__after_atomic_inc
> -static inline void __deprecated smp_mb__after_atomic_inc(void)
> -{
> -	extern void __smp_mb__after_atomic(void);
> -	__smp_mb__after_atomic();
> -}
> -#endif
> -
> -#ifndef smp_mb__before_atomic_dec
> -static inline void __deprecated smp_mb__before_atomic_dec(void)
> -{
> -	extern void __smp_mb__before_atomic(void);
> -	__smp_mb__before_atomic();
> -}
> -#endif
> -
> -#ifndef smp_mb__after_atomic_dec
> -static inline void __deprecated smp_mb__after_atomic_dec(void)
> -{
> -	extern void __smp_mb__after_atomic(void);
> -	__smp_mb__after_atomic();
> -}
> -#endif
> -
>  /**
>   * atomic_add_unless - add unless the number is already a given value
>   * @v: pointer of type atomic_t
> diff --git a/include/linux/bitops.h b/include/linux/bitops.h
> index cbc5833..be5fd38 100644
> --- a/include/linux/bitops.h
> +++ b/include/linux/bitops.h
> @@ -32,26 +32,6 @@ extern unsigned long __sw_hweight64(__u64 w);
>   */
>  #include <asm/bitops.h>
> =20
> -/*
> - * Provide __deprecated wrappers for the new interface, avoid flag day c=
hanges.
> - * We need the ugly external functions to break header recursion hell.
> - */
> -#ifndef smp_mb__before_clear_bit
> -static inline void __deprecated smp_mb__before_clear_bit(void)
> -{
> -	extern void __smp_mb__before_atomic(void);
> -	__smp_mb__before_atomic();
> -}
> -#endif
> -
> -#ifndef smp_mb__after_clear_bit
> -static inline void __deprecated smp_mb__after_clear_bit(void)
> -{
> -	extern void __smp_mb__after_atomic(void);
> -	__smp_mb__after_atomic();
> -}
> -#endif
> -
>  #define for_each_set_bit(bit, addr, size) \
>  	for ((bit) =3D find_first_bit((addr), (size));		\
>  	     (bit) < (size);					\
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 1211575..76c518c 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -90,22 +90,6 @@
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/sched.h>
> =20
> -#ifdef smp_mb__before_atomic
> -void __smp_mb__before_atomic(void)
> -{
> -	smp_mb__before_atomic();
> -}
> -EXPORT_SYMBOL(__smp_mb__before_atomic);
> -#endif
> -
> -#ifdef smp_mb__after_atomic
> -void __smp_mb__after_atomic(void)
> -{
> -	smp_mb__after_atomic();
> -}
> -EXPORT_SYMBOL(__smp_mb__after_atomic);
> -#endif
> -
>  void start_bandwidth_timer(struct hrtimer *period_timer, ktime_t period)
>  {
>  	unsigned long delta;



--=-zb3dReDmJd9HCh0K3LLP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJUHJfhAAoJEOVv75VaS+3OeKEP/2yP2pTsozxo4bzqf+EAEoOT
E8FE7UJwr0CU3G02DhR5+Kii1P10/VHXpl3uZAj3TE5TT1kqKvVsKzu0ca+awIzs
nfSh9BWlYb2Loqv+/AC1lbEzQkjwcS+fgixK09vhgosQcn/UBNTKEn/fSjtzbF2v
82VX2hSCQGhWHXLOrHgQfeWc9NT86us4MXbSUm6HWH7x0+RrdO4eVL+5+O+1Rzow
LDCY8VR8DDgcmYpRHCeBQLed2QuvFEPfY7z6x6iyxJd908iEwsJNUIQ61aC4RsHD
xBVy9Cp0y8edsK/MO5lW03dMBAuFW6h4hTxIyQzT42UX1s/nplrI+2a/QZIUS1AF
qk2oR/tBe44z9JkOPJeCtfewccY2FU6p2P0aqJGuG3tV169XsZb1VS7UyFXuZ25r
fiC24/3j9HtlHUjfilZaaij/9ug1ghV/7F+e/GrnM1bHXyJUTSQ3Ez2HWByxyboV
nVCS9uh+fxadfknKlTXDdMIoC/4vmaNeMbpgfWB3uEGgawU0+Q5/WEFxQX7yYS/y
bZtUDv3mhBE3A2lGdoK7F/9mf0l+5r5v4X5W2fQn1pbD8BeXh7AeCypB4099/Kon
WqKe41qAhZRFOhkODIMxUdzJ8MFR0yaOdYgSa7vJOH0Y/LBA7v0PDvrU1WJRtLTM
C+UIW/mf0OIZHXFTmnIj
=I0eW
-----END PGP SIGNATURE-----

--=-zb3dReDmJd9HCh0K3LLP--

