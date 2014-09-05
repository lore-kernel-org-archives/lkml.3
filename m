Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbaIELiv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 07:38:51 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:56457 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756478AbaIELiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 07:38:50 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] ARM: /proc/cpuinfo: Use DT machine name when possible
Date: Fri, 5 Sep 2014 13:38:40 +0200
User-Agent: KMail/1.13.7 (Linux/3.13.0-32-generic; KDE/4.13.2; x86_64; ; )
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Will Deacon <will.deacon@arm.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@debian.org>, Pavel Machek <pavel@ucw.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robherring2@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com>
In-Reply-To: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1588397.GkDCuovTq7";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201409051338.40988@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1588397.GkDCuovTq7
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 18 June 2014 18:54:24 Pali Roh=C3=A1r wrote:
> Machine name from board description is some generic name on DT
> kernel. DT provides machine name property which is specific
> for board, so use it instead generic one when possible.
>=20
> Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> ---
>  arch/arm/kernel/setup.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> index 8a16ee5..fbc7b4f 100644
> --- a/arch/arm/kernel/setup.c
> +++ b/arch/arm/kernel/setup.c
> @@ -875,10 +875,13 @@ void __init setup_arch(char **cmdline_p)
>=20
>  	setup_processor();
>  	mdesc =3D setup_machine_fdt(__atags_pointer);
> -	if (!mdesc)
> +	if (mdesc)
> +		machine_name =3D of_flat_dt_get_machine_name();
> +	else
>  		mdesc =3D setup_machine_tags(__atags_pointer,
> __machine_arch_type); machine_desc =3D mdesc;
> -	machine_name =3D mdesc->name;
> +	if (!machine_name)
> +		machine_name =3D mdesc->name;
>=20
>  	if (mdesc->reboot_mode !=3D REBOOT_HARD)
>  		reboot_mode =3D mdesc->reboot_mode;

So, do you really want to break userspace which reading file=20
/proc/cpuinfo (after migration from boardcode --> DT)?

I still do not see reason for that. And only this one file is=20
problematic...

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1588397.GkDCuovTq7
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlQJoMAACgkQi/DJPQPkQ1JvwwCgx+z5Yw3uVrNGSUzxUuIZtL4v
vmwAoLzE+eMIm8VfF1DrL+46K05kxHdE
=Ejwz
-----END PGP SIGNATURE-----

--nextPart1588397.GkDCuovTq7--
