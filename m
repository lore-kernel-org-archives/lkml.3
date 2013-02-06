Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab3BFHnD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 02:43:03 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:42378 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab3BFHnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 02:43:00 -0500
Date: Wed, 6 Feb 2013 18:42:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: linux-next: build failure after merge of the final tree
Message-Id: <20130206184243.c858634f5d8c3ce4ffac71f3@canb.auug.org.au>
In-Reply-To: <20130206183040.ea07a2cd64200b6d37868036@canb.auug.org.au>
References: <20130206183040.ea07a2cd64200b6d37868036@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__6_Feb_2013_18_42_43_+1100_D2kj3Ix/+EaXPRFe"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__6_Feb_2013_18_42_43_+1100_D2kj3Ix/+EaXPRFe
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 6 Feb 2013 18:30:40 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> After merging the final tree, today's linux-next build (sparc defconfig)
> failed like this:
>=20
> arch/sparc/kernel/kgdb_32.c: In function 'sleeping_thread_to_gdb_regs':
> arch/sparc/kernel/kgdb_32.c:46:9: error: implicit declaration of function=
 'task_thread_info' [-Werror=3Dimplicit-function-declaration]
> arch/sparc/kernel/kgdb_32.c:46:26: error: initialization makes pointer fr=
om integer without a cast [-Werror]
>=20
> I can only imagine that the implicit include of linux/sched.h got removed
> in one of our include file changes. :-(
>=20
> I have added this patch for today:
>=20
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 6 Feb 2013 18:26:51 +1100
> Subject: [PATCH] sparc: explicitly include sched.h to get task_thread_inf=
o declaration
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  arch/sparc/kernel/kgdb_32.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/arch/sparc/kernel/kgdb_32.c b/arch/sparc/kernel/kgdb_32.c
> index 2e424a5..dcf2108 100644
> --- a/arch/sparc/kernel/kgdb_32.c
> +++ b/arch/sparc/kernel/kgdb_32.c
> @@ -5,6 +5,7 @@
> =20
>  #include <linux/kgdb.h>
>  #include <linux/kdebug.h>
> +#include <linux/sched.h>
> =20
>  #include <asm/kdebug.h>
>  #include <asm/ptrace.h>

This was probably caused by commit 16559ae48c76 ("kgdb: remove #include
<linux/serial_8250.h> from kgdb.h") from the tty tree.

Removing includes from include files is always fraught with this sort of
danger :-(
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__6_Feb_2013_18_42_43_+1100_D2kj3Ix/+EaXPRFe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJREglzAAoJEECxmPOUX5FEbHQP/i8f2WsuOODrguwEdsTNlmQP
Anq64KYL2tBE7NLUWa/36rqET79NyU3Dwz1h1J+0t7ROjvjoSlxM5HLvFu5/sFbg
CW6sSOiGMhYS2KSA7lUPmoJD0r5b40NuiaDFP1p6rdNuUsY1kKY07riACegfo7/q
SWD3KdBytprDWpDjqICwMvDOX5qqiOToveATo3WmrfOmfJ5h3WxEBdY8x4iZnsk6
cpfF3OhVDG69uqRHGdXbcze1qahYOQKHeB/mS5LzVCSsC5Z/mgW1f2h+roIp0kXv
GGiRbKVOeFgZ/Uz7rYxe0pVHFVRPoXZ+iQnQmb/K3S2lmOZvSOjmW+IxtM313uWw
9K5WrbyeFvKpt/g2HnMuidumo26K/xYQOdnxBII/zhKs47IuEa9dGESGbMcxfpIA
9eN9ZxUZo3N6LbFJvYEZZHjfOFvPh6oQW9jwFHwHDRJt3MNcxsFgGYEkPV5IOSL+
mHBSQkmVKHqJfz16BoifZRScnVzys/DHZngxewDlmjPApCF0n/25OSrecJSV+/eu
KEc2RUYTdiCaU3w9erLsTmyjEZ97TK7pv//4saRcnD6TzpN29e+66mXHxe37IbpI
5ICs9nxxhl9byywm1Ok+BfYLzPfAs8QUMz1eazkJ4oRzCUsTQXFrPmJdRXWJ1bBz
HabuLosHV4kQUnCUCzuo
=V6Af
-----END PGP SIGNATURE-----

--Signature=_Wed__6_Feb_2013_18_42_43_+1100_D2kj3Ix/+EaXPRFe--
