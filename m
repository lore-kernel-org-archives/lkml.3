Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758971Ab3KMKI0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 05:08:26 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:58374 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758537Ab3KMKIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 05:08:21 -0500
Message-ID: <52834F92.6060808@monstr.eu>
Date: Wed, 13 Nov 2013 11:08:18 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au
Subject: Re: [PATCH 08/17] microblaze: Remove _fdt_start casts
References: <1384285347-13506-1-git-send-email-geert@linux-m68k.org> <1384285347-13506-9-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1384285347-13506-9-git-send-email-geert@linux-m68k.org>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="x9avJT8dTmKOo2Isd6C8q4M0o5P4jw4vM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--x9avJT8dTmKOo2Isd6C8q4M0o5P4jw4vM
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/12/2013 08:42 PM, Geert Uytterhoeven wrote:
> _fdt_start is an array, i.e. a pointer.
>=20
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Michal Simek <monstr@monstr.eu>
> Cc: microblaze-uclinux@itee.uq.edu.au
> ---
>  arch/microblaze/kernel/setup.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/microblaze/kernel/setup.c b/arch/microblaze/kernel/se=
tup.c
> index 8de8ebc309f1..603e22fec6d5 100644
> --- a/arch/microblaze/kernel/setup.c
> +++ b/arch/microblaze/kernel/setup.c
> @@ -136,7 +136,7 @@ void __init machine_early_init(const char *cmdline,=
 unsigned int ram,
>  	lockdep_init();
> =20
>  /* initialize device tree for usage in early_printk */
> -	early_init_devtree((void *)_fdt_start);
> +	early_init_devtree(_fdt_start);
> =20
>  #ifdef CONFIG_EARLY_PRINTK
>  	setup_early_printk(NULL);
> @@ -152,8 +152,7 @@ void __init machine_early_init(const char *cmdline,=
 unsigned int ram,
>  	if (fdt)
>  		pr_info("FDT at 0x%08x\n", fdt);
>  	else
> -		pr_info("Compiled-in FDT at 0x%08x\n",
> -					(unsigned int)_fdt_start);
> +		pr_info("Compiled-in FDT at %p\n", _fdt_start);
> =20
>  #ifdef CONFIG_MTD_UCLINUX
>  	pr_info("Found romfs @ 0x%08x (0x%08x)\n",
>=20

Applied.

Thanks,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--x9avJT8dTmKOo2Isd6C8q4M0o5P4jw4vM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlKDT5IACgkQykllyylKDCFy/QCeImOWIjZnkeI4a7qvJdOJ0w7Y
xjsAnRivGqHsSUPCxZODmrh+zkls150E
=1z4G
-----END PGP SIGNATURE-----

--x9avJT8dTmKOo2Isd6C8q4M0o5P4jw4vM--
