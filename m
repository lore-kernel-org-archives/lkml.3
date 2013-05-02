Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842Ab3EBFav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 01:30:51 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37614 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab3EBFas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 01:30:48 -0400
Date: Thu, 2 May 2013 15:30:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: James Hogan <james.hogan@imgtec.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] linkage.h: fix build breakage due to symbol prefix
 handling
Message-Id: <20130502153035.03afb3f75d9bfd4693319e8c@canb.auug.org.au>
In-Reply-To: <20130502133737.c2874e483bdc1380a59786f4@canb.auug.org.au>
References: <1367442257-7897-1-git-send-email-james.hogan@imgtec.com>
	<878v3yql7r.fsf@rustcorp.com.au>
	<20130502133737.c2874e483bdc1380a59786f4@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__2_May_2013_15_30_35_+1000_hps_pDA=l3uAqvUy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__2_May_2013_15_30_35_+1000_hps_pDA=l3uAqvUy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

On Thu, 2 May 2013 13:37:37 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> This is the merge fix patch I have been carrying in linux-next since
> March 14: (this probably does not quite apply any more but, hey ...)
>=20
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Thu, 14 Mar 2013 17:14:41 +1100
> Subject: [PATCH] cond_syscall and SYSCALL_ALIAS merge fixup
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  include/linux/linkage.h | 20 ++++++--------------
>  1 file changed, 6 insertions(+), 14 deletions(-)
>=20
> diff --git a/include/linux/linkage.h b/include/linux/linkage.h
> index 829d66c..bedcddf 100644
> --- a/include/linux/linkage.h
> +++ b/include/linux/linkage.h
> @@ -2,7 +2,7 @@
>  #define _LINUX_LINKAGE_H
> =20
>  #include <linux/compiler.h>
> -#include <linux/stringify.h>
> +#include <linux/export.h>
>  #include <asm/linkage.h>
> =20
>  #ifdef __cplusplus
> @@ -15,24 +15,16 @@
>  #define asmlinkage CPP_ASMLINKAGE
>  #endif
> =20
> -#ifndef SYMBOL_NAME
> -#ifdef CONFIG_SYMBOL_PREFIX
> -#define SYMBOL_NAME(x) CONFIG_SYMBOL_PREFIX ## x
> -#else
> -#define SYMBOL_NAME(x) x
> -#endif
> -#endif
> -#define __SYMBOL_NAME(x) __stringify(SYMBOL_NAME(x))
> -
>  #ifndef cond_syscall
> -#define cond_syscall(x) asm(".weak\t" __SYMBOL_NAME(x) \
> -	"\n\t.set\t" __SYMBOL_NAME(x) "," __SYMBOL_NAME(sys_ni_syscall));
> +#define cond_syscall(x) asm(".weak\t" VMLINUX_SYMBOL_STR(x) "\n\t"	\
> +			    ".set\t" VMLINUX_SYMBOL_STR(x) ","	\
> +			    VMLINUX_SYMBOL_STR(sys_ni_syscall))
>  #endif
> =20
>  #ifndef SYSCALL_ALIAS
>  #define SYSCALL_ALIAS(alias, name)				\
> -	asm ("\t.globl " __SYMBOL_NAME(alias)			\
> -	"\n\t.set\t" __SYMBOL_NAME(alias) "," __SYMBOL_NAME(name))
> +	asm ("\t.globl " VMLINUX_SYMBOL_STR(alias)			\
> +	"\n\t.set\t" VMLINUX_SYMBOL_STR(alias) "," VMLINUX_SYMBOL_STR(name))
>  #endif
> =20
>  #define __page_aligned_data	__section(.data..page_aligned) __aligned(PAG=
E_SIZE)
> --=20
> 1.8.1

Version from today's merge fix.  Rusty, you should show this to Linus
when you ask him to merge your modules tree (assuming it looks right :-)).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 14 Mar 2013 17:14:41 +1100
Subject: [PATCH] cond_syscall and SYSCALL_ALIAS merge fixup

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/linkage.h |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/include/linux/linkage.h b/include/linux/linkage.h
index de09dec..bedcddf 100644
--- a/include/linux/linkage.h
+++ b/include/linux/linkage.h
@@ -2,7 +2,7 @@
 #define _LINUX_LINKAGE_H
=20
 #include <linux/compiler.h>
-#include <linux/stringify.h>
+#include <linux/export.h>
 #include <asm/linkage.h>
=20
 #ifdef __cplusplus
@@ -15,21 +15,16 @@
 #define asmlinkage CPP_ASMLINKAGE
 #endif
=20
-#ifdef CONFIG_SYMBOL_PREFIX
-#define __SYMBOL_NAME(x) CONFIG_SYMBOL_PREFIX __stringify(x)
-#else
-#define __SYMBOL_NAME(x) __stringify(x)
-#endif
-
 #ifndef cond_syscall
-#define cond_syscall(x) asm(".weak\t" __SYMBOL_NAME(x) \
-	"\n\t.set\t" __SYMBOL_NAME(x) "," __SYMBOL_NAME(sys_ni_syscall));
+#define cond_syscall(x) asm(".weak\t" VMLINUX_SYMBOL_STR(x) "\n\t"	\
+			    ".set\t" VMLINUX_SYMBOL_STR(x) ","	\
+			    VMLINUX_SYMBOL_STR(sys_ni_syscall))
 #endif
=20
 #ifndef SYSCALL_ALIAS
 #define SYSCALL_ALIAS(alias, name)				\
-	asm ("\t.globl " __SYMBOL_NAME(alias)			\
-	"\n\t.set\t" __SYMBOL_NAME(alias) "," __SYMBOL_NAME(name))
+	asm ("\t.globl " VMLINUX_SYMBOL_STR(alias)			\
+	"\n\t.set\t" VMLINUX_SYMBOL_STR(alias) "," VMLINUX_SYMBOL_STR(name))
 #endif
=20
 #define __page_aligned_data	__section(.data..page_aligned) __aligned(PAGE_=
SIZE)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__2_May_2013_15_30_35_+1000_hps_pDA=l3uAqvUy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRgfn7AAoJEECxmPOUX5FEKsQP/2p07FrD79WUVX1+wtWghHOt
azB+7i2sKxYt4zquJVVQubFb5PlH1fXO6XKZ/EOSZHQlNuPMnP7aNzeJIZ1gtsK9
ejsaXgVETTSOTITG2YottmSvyx+wi+GFqNVFFSdrRQVOHx9PteMzgXwVSEC3s9IK
/d+7wXR7YDkXUzZZcURuN2y8LcmP/bm8Uy0fvOsR7yxlYtFGmDmrPEoCoUipNQQi
vClLzUr+6/LEISvCNprnxepNpdMt1fpZs7aCzcicuk0X7pKoEF9djkLC7lfGIwuZ
/bNyereB3lY64CHgCwMF/JwCFTLuMifsTJCBgr+a5JwOxcJJ3hC5ggIWZhzHRjrF
hOrBOm6gbH6bgADH7jHpaaeLUpuO1Z3DVPEhgS6N2f9NregR7PKpr3RBG0YCvpFq
rUUcVRPqYou5IvmLp1DTcCfkLMobKxcq0P/JeK0q20cu5toUvIjUbpbM4E8PU52S
PBUqjRw9LZnwFaws8TwEsvGq5CXYr0qaAEeKGHLoGKf/tV4pNk8z93Nce6UFC7UU
33NDmxzAD1ee1PpgFWjr2UrzGkOzzadSorz55qj9Nkg9EpSn2J3S/5lsz9HXJSJu
4Wfb5F+oTSXKohO8pZ7SvkVfIvOEIXhgKxch5Al7UxrPlGia1TymyIxxYQ3gIyuW
BQv+2bnQDDVNrUd5JfNx
=PHWr
-----END PGP SIGNATURE-----

--Signature=_Thu__2_May_2013_15_30_35_+1000_hps_pDA=l3uAqvUy--
