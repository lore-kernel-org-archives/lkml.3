Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbaIAPr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 11:47:26 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:63812 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019AbaIAPrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 11:47:25 -0400
Message-ID: <54049504.70900@monstr.eu>
Date: Mon, 01 Sep 2014 17:47:16 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/microblaze/include/asm/uaccess.h: Use pr_devel()
 instead of pr_debug()
References: <53E10590.3070703@gmail.com>
In-Reply-To: <53E10590.3070703@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="9ALCOSstV7SQ0S255v2PitGbHKgWwHRqG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9ALCOSstV7SQ0S255v2PitGbHKgWwHRqG
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/05/2014 06:25 PM, Chen Gang wrote:
> When DYNAMIC_DEBUG enabled, pr_debug() depends on KBUILD_MODNAME which
> also depends on the modules number in Makefile. The related information=

> in "scripts/Makefile.lib" line 94:
>=20
>   # $(modname_flags) #defines KBUILD_MODNAME as the name of the module =
it will
>   # end up in (or would, if it gets compiled in)
>   # Note: Files that end up in two or more modules are compiled without=
 the
>   #       KBUILD_MODNAME definition. The reason is that any made-up nam=
e would
>   #       differ in different configs.
>=20
> For this case, 'radio-si470x-i2c.o' and 'radio-si470x-common.o' are in
> one line, so cause compiling issue. And 'uaccess.h' is a common shared
> header (not specially for drivers), so use pr_devel() instead of is OK.=

>=20
> The related error with allmodconfig:
>=20
>     CC [M]  drivers/media/radio/si470x/radio-si470x-i2c.o
>     CC [M]  drivers/media/radio/si470x/radio-si470x-common.o
>   In file included from include/linux/printk.h:257:0,
>                    from include/linux/kernel.h:13,
>                    from drivers/media/radio/si470x/radio-si470x.h:29,
>                    from drivers/media/radio/si470x/radio-si470x-common.=
c:115:
>   ./arch/microblaze/include/asm/uaccess.h: In function 'access_ok':
>   include/linux/dynamic_debug.h:66:14: error: 'KBUILD_MODNAME' undeclar=
ed (first use in this function)
>      .modname =3D KBUILD_MODNAME,   \
>                 ^
>   include/linux/dynamic_debug.h:76:2: note: in expansion of macro 'DEFI=
NE_DYNAMIC_DEBUG_METADATA'
>     DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);  \
>     ^
>   include/linux/printk.h:263:2: note: in expansion of macro 'dynamic_pr=
_debug'
>     dynamic_pr_debug(fmt, ##__VA_ARGS__)
>     ^
>   ./arch/microblaze/include/asm/uaccess.h:101:3: note: in expansion of =
macro 'pr_debug'
>      pr_debug("ACCESS fail: %s at 0x%08x (size 0x%x), seg 0x%08x\n",
>      ^
>=20
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  arch/microblaze/include/asm/uaccess.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/microblaze/include/asm/uaccess.h b/arch/microblaze/in=
clude/asm/uaccess.h
> index 0aa0057..59a89a6 100644
> --- a/arch/microblaze/include/asm/uaccess.h
> +++ b/arch/microblaze/include/asm/uaccess.h
> @@ -98,13 +98,13 @@ static inline int access_ok(int type, const void __=
user *addr,=09
> =20
>  	if ((get_fs().seg < ((unsigned long)addr)) ||
>  			(get_fs().seg < ((unsigned long)addr + size - 1))) {
> -		pr_debug("ACCESS fail: %s at 0x%08x (size 0x%x), seg 0x%08x\n",
> +		pr_devel("ACCESS fail: %s at 0x%08x (size 0x%x), seg 0x%08x\n",
>  			type ? "WRITE" : "READ ", (__force u32)addr, (u32)size,
>  			(u32)get_fs().seg);
>  		return 0;
>  	}
>  ok:
> -	pr_debug("ACCESS OK: %s at 0x%08x (size 0x%x), seg 0x%08x\n",
> +	pr_devel("ACCESS OK: %s at 0x%08x (size 0x%x), seg 0x%08x\n",
>  			type ? "WRITE" : "READ ", (__force u32)addr, (u32)size,
>  			(u32)get_fs().seg);
>  	return 1;
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



--9ALCOSstV7SQ0S255v2PitGbHKgWwHRqG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlQElQQACgkQykllyylKDCFHSwCdHG1Ggk7BESWm0HFoMjC8+odA
rOMAniPwDXyLB+/k3I7AQ4N2zXrWczLA
=oZRm
-----END PGP SIGNATURE-----

--9ALCOSstV7SQ0S255v2PitGbHKgWwHRqG--
