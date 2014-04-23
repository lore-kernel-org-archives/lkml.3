Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511AbaDWNsx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:48:53 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:40934 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731AbaDWNsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:48:50 -0400
Message-ID: <5357C4BE.3050606@monstr.eu>
Date: Wed, 23 Apr 2014 15:48:46 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH v2 18/21] powerpc: use libfdt accessors for header data
References: <1398215901-25609-1-git-send-email-robherring2@gmail.com> <1398215901-25609-19-git-send-email-robherring2@gmail.com>
In-Reply-To: <1398215901-25609-19-git-send-email-robherring2@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="8Q6hPNWGwIApntq6tsRaOJr1ErCv3bv24"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8Q6hPNWGwIApntq6tsRaOJr1ErCv3bv24
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/23/2014 03:18 AM, Rob Herring wrote:
> From: Rob Herring <robh@kernel.org>
>=20
> With libfdt support, we can take advantage of helper accessors in libfd=
t
> for accessing the FDT header data. This makes the code more readable an=
d
> makes the FDT blob structure more opaque to the kernel. This also
> prepares for removing struct boot_param_header completely.
>=20
> Signed-off-by: Rob Herring <robh@kernel.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> ---
> v2: As powerpc is the only platform needing FDT header access, make
>  prom.c include libfdt directly.
> =20
>  arch/powerpc/kernel/Makefile |  1 +
>  arch/powerpc/kernel/prom.c   | 11 ++++++-----
>  2 files changed, 7 insertions(+), 5 deletions(-)
>=20
> diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefil=
e
> index fcc9a89..fab19ec 100644
> --- a/arch/powerpc/kernel/Makefile
> +++ b/arch/powerpc/kernel/Makefile
> @@ -2,6 +2,7 @@
>  # Makefile for the linux kernel.
>  #
> =20
> +CFLAGS_prom.o		=3D -I$(src)/../../../scripts/dtc/libfdt
>  CFLAGS_ptrace.o		+=3D -DUTS_MACHINE=3D'"$(UTS_MACHINE)"'
> =20
>  subdir-ccflags-$(CONFIG_PPC_WERROR) :=3D -Werror
> diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
> index b1de8e3..0239f0b 100644
> --- a/arch/powerpc/kernel/prom.c
> +++ b/arch/powerpc/kernel/prom.c
> @@ -33,6 +33,7 @@
>  #include <linux/memblock.h>
>  #include <linux/of.h>
>  #include <linux/of_fdt.h>
> +#include <linux/libfdt.h>
> =20
>  #include <asm/prom.h>
>  #include <asm/rtas.h>
> @@ -117,14 +118,14 @@ static void __init move_device_tree(void)
>  	DBG("-> move_device_tree\n");
> =20
>  	start =3D __pa(initial_boot_params);
> -	size =3D be32_to_cpu(initial_boot_params->totalsize);
> +	size =3D fdt_totalsize(initial_boot_params);

In 19/21 you use your newly introduced of_get_flat_dt_size()
that's why I expect you will use it here too.
size =3D of_get_flat_dt_size();

The same is for 14/21 where you can use this new function too.
It means moving 14/21 to the end and using this new function
makes more sense.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--8Q6hPNWGwIApntq6tsRaOJr1ErCv3bv24
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlNXxL4ACgkQykllyylKDCGoiACcCxoJABNUJC0gMecLM6TbeBBz
GugAn0Y7mzNOab8bl7CBQ1Jkttj6JsOL
=KB8/
-----END PGP SIGNATURE-----

--8Q6hPNWGwIApntq6tsRaOJr1ErCv3bv24--
