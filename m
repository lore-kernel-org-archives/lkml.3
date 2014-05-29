Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbaE2BiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 21:38:15 -0400
Received: from ozlabs.org ([103.22.144.67]:43833 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696AbaE2BiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 21:38:13 -0400
Date: Thu, 29 May 2014 11:38:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <linux@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the tip tree
Message-ID: <20140529113805.514217ee@canb.auug.org.au>
In-Reply-To: <20140523171412.125adaa6@canb.auug.org.au>
References: <20140523171412.125adaa6@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/L8.UJEfVKW4W/XOOeDY9JIy"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/L8.UJEfVKW4W/XOOeDY9JIy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Russell,

On Fri, 23 May 2014 17:14:12 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the tip tree, today's linux-next build (arm
> multi_v7_defconfig) failed like this:
>=20
> In file included from arch/arm/include/asm/outercache.h:24:0,
>                  from arch/arm/include/asm/barrier.h:5,
>                  from arch/arm/include/asm/bitops.h:28,
>                  from include/linux/bitops.h:33,
>                  from include/linux/kernel.h:10,
>                  from include/asm-generic/bug.h:13,
>                  from arch/arm/include/asm/bug.h:61,
>                  from arch/arm/include/asm/div64.h:63,
>                  from include/linux/math64.h:5,
>                  from include/linux/jiffies.h:4,
>                  from init/calibrate.c:7:
> include/linux/bug.h:91:47: warning: 'struct bug_entry' declared inside pa=
rameter list [enabled by default]
> include/linux/bug.h:91:47: warning: its scope is only this definition or =
declaration, which is probably not what you want [enabled by default]
> include/linux/bug.h: In function 'is_warning_bug':
> include/linux/bug.h:93:12: error: dereferencing pointer to incomplete type
>=20
>  ... and many, many more ...
>=20
> Probably caused by commit 030d0178bdbd ("arch,arm: Convert
> smp_mb__*()") which added an include of asm/barrier.h to
> arch/arm/include/asm/bitops.h.  This has interacted with commit
> 59a3bc6d3343 ("ARM: outer cache: add WARN_ON() to outer_disable()")
> from the arm tree, which adds an include of linux/bug.h to
> arch/arm/include/asm/outercache.h.
>=20
> I added the below merge fix patch.  Russell, this should be applied to
> your tree directly.

Ping?  I am still carrying this patch ...

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 23 May 2014 17:10:12 +1000
> Subject: [PATCH] ARM: outer cache: no need for bug.h in outercache.h
>=20
> This fixes a cricular include dependency when combined with commits from
> the tip tree.
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  arch/arm/include/asm/outercache.h | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/arch/arm/include/asm/outercache.h b/arch/arm/include/asm/out=
ercache.h
> index eaa8a28c6871..891a56b35bcf 100644
> --- a/arch/arm/include/asm/outercache.h
> +++ b/arch/arm/include/asm/outercache.h
> @@ -21,7 +21,6 @@
>  #ifndef __ASM_OUTERCACHE_H
>  #define __ASM_OUTERCACHE_H
> =20
> -#include <linux/bug.h>
>  #include <linux/types.h>
> =20
>  struct outer_cache_fns {
> --=20
> 2.0.0.rc4

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/L8.UJEfVKW4W/XOOeDY9JIy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTho+DAAoJEMDTa8Ir7ZwVDaUP/jv3GLngRsazN4LSvIwcFSf+
/xb1JZ/60txVLjzs3uTmMtsDPKhBO13kIayoSL5KZGIJyHEzInSTw3szxAN3a/kv
xQVlx5iCwnshEfldjouajDB1/X206Uaz7VHaFM3mcyhAmINtCO/H/ZRkyCdsHp/v
kRO67b18FNfMcImrDioQc+RW64M7jR9Wkx4oS3vulkEeRWxlN+CZ0egJOfe9BhAR
+s6ckZwd7Fu21NMYORTwnOUaW7lj8ajclRn8ET2/b9mLmubUhFzApgBqqF+0O74a
juRNBfiXAsSsoUxu3cfTiPc3GBdSlnmqwbst+iHSe3rv9pFmTOejJprr8tlyMj8Y
TbBNNOdeiua/0EeljnmzL2NcVgJPC+59Zo7BHUsKez8U5rTuHyy2HDxbYtjPUxMj
37XxQlJwQRKPkSp02s/5/2jdMJJM3fbs17B4FITwD3OLrN4ds797DcRXfyekkU7e
osnLSSFbkbXu1VcqYb2iKF6AraAgM8Mau3EM6mVO4b++K7p64WNGVXVQleNm0nCL
F1Vtc5LFQnDX8qNLzm/0BI9d4xenWPFF16i2arq6hxCNFulAlb//oEskt0UueKqZ
5HOK0cqSl6AKDFMJKwNtyXonr3zrt4GTSDczi9w9tsOSlutXAo5Ttc+5Spf1+u1M
spTQ7g8pDUzo48OfTdnv
=nU9H
-----END PGP SIGNATURE-----

--Sig_/L8.UJEfVKW4W/XOOeDY9JIy--
