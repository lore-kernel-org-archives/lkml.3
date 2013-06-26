Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458Ab3FZHMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 03:12:53 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46964 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab3FZHMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 03:12:52 -0400
Date: Wed, 26 Jun 2013 17:12:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: linux-next: manual merge of the cpuinit tree with the arm-current
 tree
Message-Id: <20130626171241.4629f4072fbd36f12d5fe3be@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__26_Jun_2013_17_12_41_+1000_lArE76q/rGmJNDa2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__26_Jun_2013_17_12_41_+1000_lArE76q/rGmJNDa2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the cpuinit tree got a conflict in
arch/arm/mm/proc-v7.S between commit 3e0a07f8c401 ("ARM: 7773/1: PJ4B:
Add support for errata 4742") from the arm-current tree and commit "arm:
delete __cpuinit/__CPUINIT usage from all ARM users" from the cpuinit
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mm/proc-v7.S
index 7ef3ad0,64b3acb..0000000
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@@ -144,31 -144,6 +144,29 @@@ ENTRY(cpu_v7_do_resume
  ENDPROC(cpu_v7_do_resume)
  #endif
 =20
 +#ifdef CONFIG_CPU_PJ4B
 +	globl_equ	cpu_pj4b_switch_mm,     cpu_v7_switch_mm
 +	globl_equ	cpu_pj4b_set_pte_ext,	cpu_v7_set_pte_ext
 +	globl_equ	cpu_pj4b_proc_init,	cpu_v7_proc_init
 +	globl_equ	cpu_pj4b_proc_fin, 	cpu_v7_proc_fin
 +	globl_equ	cpu_pj4b_reset,	   	cpu_v7_reset
 +#ifdef CONFIG_PJ4B_ERRATA_4742
 +ENTRY(cpu_pj4b_do_idle)
 +	dsb					@ WFI may enter a low-power mode
 +	wfi
 +	dsb					@barrier
 +	mov	pc, lr
 +ENDPROC(cpu_pj4b_do_idle)
 +#else
 +	globl_equ	cpu_pj4b_do_idle,  	cpu_v7_do_idle
 +#endif
 +	globl_equ	cpu_pj4b_dcache_clean_area,	cpu_v7_dcache_clean_area
 +	globl_equ	cpu_pj4b_do_suspend,	cpu_v7_do_suspend
 +	globl_equ	cpu_pj4b_do_resume,	cpu_v7_do_resume
 +	globl_equ	cpu_pj4b_suspend_size,	cpu_v7_suspend_size
 +
 +#endif
 +
- 	__CPUINIT
-=20
  /*
   *	__v7_setup
   *

--Signature=_Wed__26_Jun_2013_17_12_41_+1000_lArE76q/rGmJNDa2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRypRuAAoJEECxmPOUX5FE9JUP/A6AX6ORS2U03luPC6iuyaN7
V9m9IMYXcPJ6YM2dkBq5wSHtXaOmed6kOhW8NNS7E1r4lFoaOb938ZKyori3ZyOw
8SG7xamWLFFF+2MFk95BHYnizaDmgTMY48zzEQ2H+ejq3UdFYCGGn9VLlcMAbRLK
SSUJO2+TM9Sdq3gjWXogcPZOzNwFvCv44s+SGGKDHNxpFjVsvoMDn9U6dgs3lMsZ
7n/Go6jFYe1U9903QlDk7HJY9hmKgJaeBaRl9PhV8auNCLp2FXnuSSdduwaszRxG
WlF3nMMbTxi/JFSBUW/aD/OfgQR5aVUOMypMizPC2CR9pW8zqzZtUuDMl1ZxOVX7
rDbse23W/g0FDljmrCPiMhiLMmXzs6f7gsoW8K3fkOgm4HjhJG0apX24snKkJQtY
fzMTy1n8cWiDHLGQL84NKTwZ605rzaiX0nxhonWrGPqYwBh7pRnjg850qYTlP6dP
6vqbSxL+M8DMud6RG4e2DmjaZnVlnJD63Ph8xqkf/92sDhSlM2ITrcKfH4NazbeC
ud6F1ScUw1565ap4GMh5db+fg0jRWw4n6Um71XSn4pfISg49x1x5Ftw/rfEPPZa6
FUK9dO1pFNc6fv6DQV71DqODZW9fe2uqQ0QDdRfP9sWz5gqso5eukTqcboehw9MP
5u4GSxhS/Q2/OVOVC938
=vz/H
-----END PGP SIGNATURE-----

--Signature=_Wed__26_Jun_2013_17_12_41_+1000_lArE76q/rGmJNDa2--
