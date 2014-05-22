Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985AbaEVHrq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 03:47:46 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:42695 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbaEVHrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 03:47:45 -0400
Message-ID: <537DAB95.8060500@monstr.eu>
Date: Thu, 22 May 2014 09:47:33 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] microblaze: remove check for CONFIG_XILINX_CONSOLE
References: <1400579750.4912.24.camel@x220>
In-Reply-To: <1400579750.4912.24.camel@x220>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="7NNDkXcWmoBQjWhpRS7TEsXqlpVx8K9Tn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7NNDkXcWmoBQjWhpRS7TEsXqlpVx8K9Tn
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 05/20/2014 11:55 AM, Paul Bolle wrote:
> There's been a check for CONFIG_XILINX_CONSOLE since v2.6.30. But the
> Kconfig symbol XILINX_CONSOLE was never added. Remove this check.
>=20
> And, since DUMMY_CONSOLE depends on VT, we can now drop the check for
> CONFIG_VT.
>=20
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested.
>=20
> Note that xil_con doesn't exit either.
>=20
>  arch/microblaze/kernel/setup.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
>=20
> diff --git a/arch/microblaze/kernel/setup.c b/arch/microblaze/kernel/se=
tup.c
> index bd422794a651..3a93843d346c 100644
> --- a/arch/microblaze/kernel/setup.c
> +++ b/arch/microblaze/kernel/setup.c
> @@ -71,13 +71,9 @@ void __init setup_arch(char **cmdline_p)
> =20
>  	xilinx_pci_init();
> =20
> -#ifdef CONFIG_VT
> -#if defined(CONFIG_XILINX_CONSOLE)
> -	conswitchp =3D &xil_con;
> -#elif defined(CONFIG_DUMMY_CONSOLE)
> +#if defined(CONFIG_DUMMY_CONSOLE)
>  	conswitchp =3D &dummy_con;
>  #endif
> -#endif
>  }
> =20
>  #ifdef CONFIG_MTD_UCLINUX

Looks reasonable.
Applied.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--7NNDkXcWmoBQjWhpRS7TEsXqlpVx8K9Tn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlN9q5YACgkQykllyylKDCGh3ACfa5n0wKKsOn86/pme0dx87bhh
gewAn09VLtrh9SP30aoyHJrKxbgFp3db
=ypKO
-----END PGP SIGNATURE-----

--7NNDkXcWmoBQjWhpRS7TEsXqlpVx8K9Tn--
