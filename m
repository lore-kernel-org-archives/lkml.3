Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627Ab3BBNhn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 08:37:43 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:35116 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756860Ab3BBNhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 08:37:42 -0500
Date: Sun, 3 Feb 2013 00:37:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk@arm.linux.org.uk>
Cc: =?UTF-8?B?IlV3ZSBLbGVpbmUtS8O2bmlnIg==?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoffer Dall <c.dall@virtualopensystems.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: linux-next: manual merge of the cortex tree with the arm tree
Message-Id: <20130203003721.cae68c412d7307127758431c@canb.auug.org.au>
In-Reply-To: <20130202122122.GA26330@flint.arm.linux.org.uk>
References: <20130202222036.0db6c1d208843975be1f8dba@canb.auug.org.au>
	<20130202122122.GA26330@flint.arm.linux.org.uk>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sun__3_Feb_2013_00_37_21_+1100_/Q1F6rMO/V9DFfqq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__3_Feb_2013_00_37_21_+1100_/Q1F6rMO/V9DFfqq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Russell,

On Sat, 2 Feb 2013 12:21:22 +0000 Russell King <rmk@arm.linux.org.uk> wrote:
>
> > diff --cc arch/arm/include/asm/cputype.h
> > index ad41ec2,574269e..0000000
> > --- a/arch/arm/include/asm/cputype.h
> > +++ b/arch/arm/include/asm/cputype.h
> > @@@ -59,30 -60,25 +60,43 @@@ extern unsigned int processor_id
> >   		    : "cc");						\
> >   		__val;							\
> >   	})
> > - #else
> > - #define read_cpuid(reg) (processor_id)
> > - #define read_cpuid_ext(reg) 0
> > - #endif
> > +=20
> > + #else /* ifdef CONFIG_CPU_CP15 */
> >  =20
> >  +#define ARM_CPU_IMP_ARM			0x41
> >  +#define ARM_CPU_IMP_INTEL		0x69
> >  +
> >  +#define ARM_CPU_PART_ARM1136		0xB360
> >  +#define ARM_CPU_PART_ARM1156		0xB560
> >  +#define ARM_CPU_PART_ARM1176		0xB760
> >  +#define ARM_CPU_PART_ARM11MPCORE	0xB020
> >  +#define ARM_CPU_PART_CORTEX_A8		0xC080
> >  +#define ARM_CPU_PART_CORTEX_A9		0xC090
> >  +#define ARM_CPU_PART_CORTEX_A5		0xC050
> >  +#define ARM_CPU_PART_CORTEX_A15		0xC0F0
> >  +#define ARM_CPU_PART_CORTEX_A7		0xC070
> >  +
> >  +#define ARM_CPU_XSCALE_ARCH_MASK	0xe000
> >  +#define ARM_CPU_XSCALE_ARCH_V1		0x2000
> >  +#define ARM_CPU_XSCALE_ARCH_V2		0x4000
> >  +#define ARM_CPU_XSCALE_ARCH_V3		0x6000
> >  +
>=20
> This stuff shouldn't be in the #else section - it's needed when
> CONFIG_CPU_CP15 is enabled and this resolution hides it in that case.

Rats!  This was the automatically resolved part of the merge resolution.
I will fix it up (it caused a build failure in my arm defconfig build)
and will carry that fix as well from now on.

Thanks for letting me know.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sun__3_Feb_2013_00_37_21_+1100_/Q1F6rMO/V9DFfqq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRDRaRAAoJEECxmPOUX5FEVkEP/2ixJhRZU2x1tu751yX12fOc
VzVxXunWgj/aqLJNI64tFuryl/qULbHGYk4HBqeExLgURCrrP16O5J69Amr6tjKf
AQb8IC5JtRx2d5m7gyPd11PUm8gfPP6Exgx5Ao3X4WRBVmTfJyUySlP4KBYH1Z3Z
jmQIPKVA0573BuppCgnbqzzXQVWFqfNrHUaYd0bXMUApMmnNkN5vI9G6N1GGGxTU
VGCM2nDSZuDOljNTvlB+okxzFNT8FGoTDIlk60s9Ga0ccS3tEfCUvYNv138MLm1A
OXttAxNwy7AkEPN4hWht1SQbbtgBlkXLOz9gbjkakjTTu2AKV/iwmNtP7xGlaRSr
LpPf22WyyssLWKaWkkGdkqd+oLwdu45piQYa++rHDC8yGkgEWDuFC8pO6bEb7pX+
eJ269YNUYDG5wcvPqGsaJEZ3TznN6vyNc1GYYYMLZl16IZ8CeZuG7waWOHYRaugK
c4fTgv24MH7wwWGfGk5rEJucsvKYdAZJLI0gLHEapBeYgVl96p0QHYnG+NN/It8E
uEWcgJQ15Dnmk7UPtRFbFQg6lgJi2KwH8UTNSQmmm9g2deLVgIl9tK6Cf79Hslgh
G7eaYZ7VLg1ReA9LhiqId4Wk0u6LNyTjggvRD6G4eeDvfeIKE7Za5Yxe2mD/go+J
KHukcT+w2zWpJGhfDYhP
=MXq/
-----END PGP SIGNATURE-----

--Signature=_Sun__3_Feb_2013_00_37_21_+1100_/Q1F6rMO/V9DFfqq--
