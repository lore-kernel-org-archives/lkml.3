Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab3INJhT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 05:37:19 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:50327 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614Ab3INJhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 05:37:16 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v4 1/2] ARM: OMAP: Add secure function omap_smc3() which calling instruction smc #1
Date: Sat, 14 Sep 2013 11:37:12 +0200
User-Agent: KMail/1.13.7 (Linux/3.11.0-1+synaptics-generic; KDE/4.11.0; x86_64; ; )
Cc: tony@atomide.com,
        =?utf-8?q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE?=
	 =?utf-8?q?_=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2?= 
	<freemangordon@abv.bg>,
        nm@ti.com, linux@arm.linux.org.uk, aaro.koskinen@iki.fi,
        pdeschrijver@nvidia.com, linux-kernel@vger.kernel.org,
        santosh.shilimkar@ti.com, pavel@ucw.cz, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <20130904124303.GA2369@localhost.localdomain> <201309080943.30542@pali>
In-Reply-To: <201309080943.30542@pali>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart459732251.YYTfsG4Ysz";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201309141137.13232@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart459732251.YYTfsG4Ysz
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 08 September 2013 09:43:29 Pali Roh=C3=A1r wrote:
> Here is new version (v4) of omap secure part patch:
>=20
> Other secure functions omap_smc1() and omap_smc2() calling
> instruction smc #0 but Nokia RX-51 board needs to call smc #1
> for PPA access.
>=20
> Signed-off-by: Ivaylo Dimitrov <freemangordon@abv.bg>
> Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> ---
> diff --git a/arch/arm/mach-omap2/omap-secure.h
> b/arch/arm/mach-omap2/omap-secure.h index 0e72917..c4586f4
> 100644
> --- a/arch/arm/mach-omap2/omap-secure.h
> +++ b/arch/arm/mach-omap2/omap-secure.h
> @@ -51,6 +51,7 @@
>  extern u32 omap_secure_dispatcher(u32 idx, u32 flag, u32
> nargs, u32 arg1, u32 arg2, u32 arg3, u32 arg4);
>  extern u32 omap_smc2(u32 id, u32 falg, u32 pargs);
> +extern u32 omap_smc3(u32 id, u32 process, u32 flag, u32
> pargs); extern phys_addr_t
> omap_secure_ram_mempool_base(void); extern int
> omap_secure_ram_reserve_memblock(void);
>=20
> diff --git a/arch/arm/mach-omap2/omap-smc.S
> b/arch/arm/mach-omap2/omap-smc.S index f6441c1..fd90125
> 100644
> --- a/arch/arm/mach-omap2/omap-smc.S
> +++ b/arch/arm/mach-omap2/omap-smc.S
> @@ -1,9 +1,11 @@
>  /*
> - * OMAP44xx secure APIs file.
> + * OMAP34xx and OMAP44xx secure APIs file.
>   *
>   * Copyright (C) 2010 Texas Instruments, Inc.
>   * Written by Santosh Shilimkar <santosh.shilimkar@ti.com>
>   *
> + * Copyright (C) 2012 Ivaylo Dimitrov <freemangordon@abv.bg>
> + * Copyright (C) 2013 Pali Roh=C3=A1r <pali.rohar@gmail.com>
>   *
>   * This program is free software,you can redistribute it
> and/or modify * it under the terms of the GNU General Public
> License version 2 as @@ -54,6 +56,23 @@ ENTRY(omap_smc2)
>  	ldmfd   sp!, {r4-r12, pc}
>  ENDPROC(omap_smc2)
>=20
> +/**
> + * u32 omap_smc3(u32 service_id, u32 process_id, u32 flag,
> u32 pargs) + * Low level common routine for secure HAL and
> PPA APIs via smc #1 + * r0 - @service_id: Secure Service ID
> + * r1 - @process_id: Process ID
> + * r2 - @flag: Flag to indicate the criticality of operation
> + * r3 - @pargs: Physical address of parameter list
> + */
> +ENTRY(omap_smc3)
> +	stmfd	sp!, {r4-r11, lr}
> +	mov	r12, r0		@ Copy the secure service ID
> +	mov	r6, #0xff	@ Indicate new Task call
> +	dsb			@ Memory Barrier (not sure if needed, copied from
> omap_smc2) +	smc	#1		@ Call PPA service
> +	ldmfd	sp!, {r4-r11, pc}
> +ENDPROC(omap_smc3)
> +
>  ENTRY(omap_modify_auxcoreboot0)
>  	stmfd   sp!, {r1-r12, lr}
>  	ldr	r12, =3D0x104

Dave, it is ok now?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart459732251.YYTfsG4Ysz
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlI0LkkACgkQi/DJPQPkQ1I7bgCglrNzeN0Ar3jLVb1NBjrFXSrI
L+sAnAuBVu9H/vu8a6BgNGGcsq+R1ofD
=5KqC
-----END PGP SIGNATURE-----

--nextPart459732251.YYTfsG4Ysz--
