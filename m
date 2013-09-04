Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934316Ab3IDIKl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 04:10:41 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:63157 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756610Ab3IDIKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 04:10:34 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: =?utf-8?q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE?=
	 =?utf-8?q?_=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2?= 
	<freemangordon@abv.bg>,
        Dave Martin <Dave.Martin@arm.com>, tony@atomide.com, nm@ti.com
Subject: Re: [PATCH v3 1/2] ARM: OMAP: Add secure function omap_smc3() which calling instruction smc #1
Date: Wed, 4 Sep 2013 10:10:29 +0200
User-Agent: KMail/1.13.7 (Linux/3.11.0-rc5+synaptics-generic; KDE/4.11.0; x86_64; ; )
Cc: linux@arm.linux.org.uk, aaro.koskinen@iki.fi, pdeschrijver@nvidia.com,
        linux-kernel@vger.kernel.org, santosh.shilimkar@ti.com, pavel@ucw.cz,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <2121638991.49538.1376246200421.JavaMail.apache@mail81.abv.bg>
In-Reply-To: <2121638991.49538.1376246200421.JavaMail.apache@mail81.abv.bg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1548234.HS0QES2WzH";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201309041010.30090@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1548234.HS0QES2WzH
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 11 August 2013 20:36:40 =D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE =D0=
=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2 wrote:
>   >-------- =D0=9E=D1=80=D0=B8=D0=B3=D0=B8=D0=BD=D0=B0=D0=BB=D0=BD=D0=BE =
=D0=BF=D0=B8=D1=81=D0=BC=D0=BE --------
>  >
>  >=D0=9E=D1=82:  Dave Martin
>  >=D0=9E=D1=82=D0=BD=D0=BE=D1=81=D0=BD=D0=BE: Re: [PATCH v3 1/2] ARM: OMA=
P: Add secure function
>  >omap_smc3() which
>=20
>  calling instruction smc #1
>=20
>  >=D0=94=D0=BE: Pali Roh=C3=A1r
>  >=D0=98=D0=B7=D0=BF=D1=80=D0=B0=D1=82=D0=B5=D0=BD=D0=BE =D0=BD=D0=B0: =
=D0=9F=D0=BE=D0=BD=D0=B5=D0=B4=D0=B5=D0=BB=D0=BD=D0=B8=D0=BA, 2013, =D0=90=
=D0=B2=D0=B3=D1=83=D1=81=D1=82 5 16:29:44 EEST
>  >
>  >On Sun, Aug 04, 2013 at 10:45:00AM +0200, Pali Roh=C3=A1r wrote:
>  >> Here is new version (v3) of omap secure part patch:
>  >>=20
>  >> Other secure functions omap_smc1() and omap_smc2() calling
>  >> instruction smc #0 but Nokia RX-51 board needs to call
>  >> smc #1 for PPA access.
>  >>=20
>  >> Signed-off-by: Ivaylo Dimitrov
>  >> Signed-off-by: Pali Roh=C3=A1r
>  >> ---
>  >> diff --git a/arch/arm/mach-omap2/omap-secure.h
>  >> b/arch/arm/mach-omap2/omap-secure.h index
>  >> 0e72917..c4586f4 100644
>  >> --- a/arch/arm/mach-omap2/omap-secure.h
>  >> +++ b/arch/arm/mach-omap2/omap-secure.h
>  >> @@ -51,6 +51,7 @@
>  >>=20
>  >>  extern u32 omap_secure_dispatcher(u32 idx, u32 flag, u32
>  >>  nargs,
>  >> =20
>  >>  				u32 arg1, u32 arg2, u32 arg3, u32 arg4);
>  >> =20
>  >>  extern u32 omap_smc2(u32 id, u32 falg, u32 pargs);
>  >>=20
>  >> +extern u32 omap_smc3(u32 id, u32 process, u32 flag, u32
>  >> pargs);
>  >>=20
>  >>  extern phys_addr_t omap_secure_ram_mempool_base(void);
>  >>  extern int omap_secure_ram_reserve_memblock(void);
>  >>=20
>  >> diff --git a/arch/arm/mach-omap2/omap-smc.S
>  >> b/arch/arm/mach-omap2/omap-smc.S index f6441c1..7bbc043
>  >> 100644
>  >> --- a/arch/arm/mach-omap2/omap-smc.S
>  >> +++ b/arch/arm/mach-omap2/omap-smc.S
>  >> @@ -1,9 +1,11 @@
>  >>=20
>  >>  /*
>  >>=20
>  >> - * OMAP44xx secure APIs file.
>  >> + * OMAP34xx and OMAP44xx secure APIs file.
>  >>=20
>  >>   *
>  >>   * Copyright (C) 2010 Texas Instruments, Inc.
>  >>   * Written by Santosh Shilimkar
>  >>   *
>  >>=20
>  >> + * Copyright (C) 2012 Ivaylo Dimitrov
>  >> + * Copyright (C) 2013 Pali Roh=C3=A1r
>  >>=20
>  >>   *
>  >>   * This program is free software,you can redistribute it
>  >>   and/or modify * it under the terms of the GNU General
>  >>   Public License version 2 as
>  >>=20
>  >> @@ -54,6 +56,23 @@ ENTRY(omap_smc2)
>  >>=20
>  >>  	ldmfd   sp!, {r4-r12, pc}
>  >> =20
>  >>  ENDPROC(omap_smc2)
>  >>=20
>  >> +/**
>  >> + * u32 omap_smc3(u32 service_id, u32 process_id, u32
>  >> flag, u32 pargs) + * Low level common routine for secure
>  >> HAL and PPA APIs via smc #1 + * r0 - @service_id: Secure
>  >> Service ID
>  >> + * r1 - @process_id: Process ID
>  >> + * r2 - @flag: Flag to indicate the criticality of
>  >> operation + * r3 - @pargs: Physical address of parameter
>  >> list + */
>  >> +ENTRY(omap_smc3)
>  >> +	stmfd	sp!, {r4-r11, lr}
>  >> +	mov	r12, r0		@ Copy the secure service ID
>  >> +	mov	r6, #0xff	@ Indicate new Task call
>  >> +	dsb			@ Memory Barrier
>  >
>  >Can you explain _why_ the barrier is there?  The reader
>  >doesn't need to be told that a barrier instruction is a
>  >barrier instruction.
>  >
>  >Cheers
>  >---Dave
>=20
> Hi Dave,
>=20
> Would quoting Santosh's explanation "DSBs were needed on OMAP
> for power sequencing." do the job? Something like "@ Needed
> on OMAP for power sequencing" instead of "@ Memory Barrier".
>=20
> I want to be sure I correctly understand your requirement.
>=20
> Regards,
> Ivo

Hello,

I'd like to know what happened with this patch? What is needed=20
for including it into mainline? Note that without with this patch=20
series Thumb-2 user space binaries crashing.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1548234.HS0QES2WzH
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlIm6vUACgkQi/DJPQPkQ1KRNQCfXL53Q3355pWmt5yqQPO7binz
pPoAn3emV/FtL5Tr0N6o0uy11WEUKWJM
=yILN
-----END PGP SIGNATURE-----

--nextPart1548234.HS0QES2WzH--
