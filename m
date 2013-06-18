Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab3FRGr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 02:47:59 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51522 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab3FRGr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 02:47:57 -0400
Date: Tue, 18 Jun 2013 16:47:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: akpm@linux-foundation.org
Cc: ralf@linux-mips.org, geert@linux-m68k.org, david.daney@cavium.com,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: + include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
 added to -mm tree
Message-Id: <20130618164746.2e8cf1a78aa8991b3920eb3b@canb.auug.org.au>
In-Reply-To: <51bf7215.kCUvfXDQNVATYYGk%akpm@linux-foundation.org>
References: <51bf7215.kCUvfXDQNVATYYGk%akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__18_Jun_2013_16_47_46_+1000_1FnpDZcpJCYZ4Epb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__18_Jun_2013_16_47_46_+1000_1FnpDZcpJCYZ4Epb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Mon, 17 Jun 2013 13:31:17 -0700 akpm@linux-foundation.org wrote:
>
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: include/linux/smp.h:on_each_cpu(): switch back to a macro
>=20
> f21afc25f9ed4 ("smp.h: Use local_irq_{save,restore}() in !SMP version of
> on_each_cpu()") converted on_each_cpu() to a C function.  This required
> inclusion of irqflags.h, which broke ia64 and mn10300 (at least) due to
> header ordering hell.
>=20
> Switch on_each_cpu() back to a macro to fix this.
>=20
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: David Daney <david.daney@cavium.com>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>=20
>  include/linux/smp.h |   20 ++++++++------------
>  1 file changed, 8 insertions(+), 12 deletions(-)
>=20
> diff -puN include/linux/smp.h~include-linux-smph-on_each_cpu-switch-back-=
to-a-macro include/linux/smp.h
> --- a/include/linux/smp.h~include-linux-smph-on_each_cpu-switch-back-to-a=
-macro
> +++ a/include/linux/smp.h
> @@ -11,7 +11,6 @@
>  #include <linux/list.h>
>  #include <linux/cpumask.h>
>  #include <linux/init.h>
> -#include <linux/irqflags.h>
> =20
>  extern void cpu_idle(void);
> =20
> @@ -140,17 +139,14 @@ static inline int up_smp_call_function(s
>  }
>  #define smp_call_function(func, info, wait) \
>  			(up_smp_call_function(func, info))
> -
> -static inline int on_each_cpu(smp_call_func_t func, void *info, int wait)
> -{
> -	unsigned long flags;
> -
> -	local_irq_save(flags);
> -	func(info);
> -	local_irq_restore(flags);
> -	return 0;
> -}
> -
> +#define on_each_cpu(func,info,wait)		\
> +	({					\
> +		unsigned long flags;		\
> +		local_irq_save(flags);		\
> +		func(info);			\
> +		local_irq_restore(flags);	\
> +		0;				\
> +	})
>  /*
>   * Note we still need to test the mask even for UP
>   * because we actually can get an empty mask from

I added this to the akpm tree in linux-next today - but with
s/flags/__flags/ in appropriate places.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__18_Jun_2013_16_47_46_+1000_1FnpDZcpJCYZ4Epb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRwAKWAAoJEECxmPOUX5FEMowP/iztRNSAJ6tHXez+QwZeLoY8
7ETb7aFP1CArUl53Y9sk6Myp+b5CoqHjSYwJvIq4a8cM9uJznBkjEl6iY8plnoCP
9r9McvSe3yzCgcPUbR1N2epFs/TxkjqnGXP+YT+NbehP44obd7Ih9dDjDyWZAPf+
Kf7x4qz9hCzGnkex0QJHiEXVeEmiZC57eHDm2SLlnxvV+6zbG577ew4ZewjqHgbO
b7D9z/qopczX4LUmN8Sic5RmwT42uPTcEWpPh0jzbdIsKPdElQHSjCEMsPNbxEMi
T56WDahnw6TO1jfCH8Op5wxsevp2wH2sQ46AJt3BSu0qIF2dn+ZBDouKaiwwjf1a
F7LxUY5y31YTtSNjyBHouomUF3KxKbwTcl5eroNrF6CrZngPDfwWmuNETJwFpdsb
5Q5DdYdT8w74pGJ+yp693S1K/E+P9vhWCqTyX1sNFfF529E7iF0gs+Bar/8L37OH
SQivIuFOfzqblmQJvTJwffrVcXRAYyTjMLGoBubbfAC4eC8T6x5vdYhaeUgt6P5d
OAVibZFkCfD5dzhEPP4Ftp8aY9GvGoCmzSstyQiEyxfFVrrvzfJ7WCIq8iohkXj3
GAQAsG9UvfSMAbg6upO6x/JPYVOqNgKTMpt95VtuUFjiLtSWTSMh5ZkNCdl7IXbr
sTI/0H5u4mjcoHP2F4qL
=zLvT
-----END PGP SIGNATURE-----

--Signature=_Tue__18_Jun_2013_16_47_46_+1000_1FnpDZcpJCYZ4Epb--
