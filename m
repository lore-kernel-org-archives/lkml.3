Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbaIAN7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 09:59:44 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:63775 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaIAN7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 09:59:43 -0400
Message-ID: <54047BC8.4010308@monstr.eu>
Date: Mon, 01 Sep 2014 15:59:36 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/microblaze/include/asm/entry.h: Include "linux/linkage.h"
 to avoid compiling issue
References: <53E22E85.9010205@gmail.com>
In-Reply-To: <53E22E85.9010205@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="sUQXAk79h9wv7uJbQTaABk61qctovGofV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--sUQXAk79h9wv7uJbQTaABk61qctovGofV
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/06/2014 03:32 PM, Chen Gang wrote:
> "entry.h" needs 'asmlinkage', and "asm/linkage.h" does not provide it.
> So need include "linux/linkage.h" to use generic one instead of.
>=20
> The related error (with allmodconfig under microblaze):
>=20
>     CC [M]  drivers/net/ethernet/emulex/benet/be_main.o
>   In file included from ./arch/microblaze/include/asm/processor.h:17:0,=

>                    from include/linux/prefetch.h:14,
>                    from drivers/net/ethernet/emulex/benet/be_main.c:18:=

>   ./arch/microblaze/include/asm/entry.h:33:19: error: expected '=3D', '=
,', ';', 'asm' or '__attribute__' before 'void'
>    extern asmlinkage void do_notify_resume(struct pt_regs *regs, int in=
_syscall);
>                      ^
>=20
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  arch/microblaze/include/asm/entry.h | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/arch/microblaze/include/asm/entry.h b/arch/microblaze/incl=
ude/asm/entry.h
> index b4a4cb1..596e485 100644
> --- a/arch/microblaze/include/asm/entry.h
> +++ b/arch/microblaze/include/asm/entry.h
> @@ -15,6 +15,7 @@
> =20
>  #include <asm/percpu.h>
>  #include <asm/ptrace.h>
> +#include <linux/linkage.h>
> =20
>  /*
>   * These are per-cpu variables required in entry.S, among other
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



--sUQXAk79h9wv7uJbQTaABk61qctovGofV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlQEe8gACgkQykllyylKDCHjFQCfWjWzpJG8qbufqJSQYAEc8nsn
LVUAn1O74eyTugyh5cZWNist7gMXwu8W
=6Tiw
-----END PGP SIGNATURE-----

--sUQXAk79h9wv7uJbQTaABk61qctovGofV--
