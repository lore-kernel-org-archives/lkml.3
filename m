Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbbAHHDV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 02:03:21 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:59502 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbbAHHDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 02:03:20 -0500
Message-ID: <54AE2A13.9020401@monstr.eu>
Date: Thu, 08 Jan 2015 07:56:19 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: linux-next: Tree for Jan 7 (microblaze qemu problems)
References: <20150107151618.7cb9d574@canb.auug.org.au> <20150107214530.GA27620@roeck-us.net> <20150108055836.GA6084@roeck-us.net>
In-Reply-To: <20150108055836.GA6084@roeck-us.net>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="S1xp5mpr7GOp3PTvrpPsIBlrD7CwcgpQ1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--S1xp5mpr7GOp3PTvrpPsIBlrD7CwcgpQ1
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 01/08/2015 06:58 AM, Guenter Roeck wrote:
> On Wed, Jan 07, 2015 at 01:45:30PM -0800, Guenter Roeck wrote:
>> On Wed, Jan 07, 2015 at 03:16:18PM +1100, Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> Changes since 20150106:
>>>
>>> *crickets*
>>>
>>> Non-merge commits (relative to Linus' tree): 1350
>>>  1543 files changed, 41856 insertions(+), 24250 deletions(-)
>>>
>>
>> With this kernel I get the following WARNINGs (lots of htem) when runn=
ing
>> microblaze images (both big and little endian) with qemu.
>>
>> WARNING: CPU: 0 PID: 1 at arch/microblaze/kernel/cpu/cache.c:432
>> __invalidate_dcache_range_msr_irq_wt+0xcc/0xd8()
>> Modules linked in:
>> CPU: 0 PID: 1 Comm: swapper Not tainted 3.19.0-rc3-next-20150107 #1
>> ...
>> (sample) Call Trace:
>> [<c0004080>] microblaze_unwind+0x5c/0x78
>> [<c0003d64>] show_stack+0xe0/0x164
>> [<c02e2224>] dump_stack+0x20/0x38
>> [<c000adbc>] warn_slowpath_common+0x90/0xec
>> [<c000aea0>] warn_slowpath_null+0xc/0x24
>> [<c000493c>] __invalidate_dcache_range_msr_irq_wt+0xc0/0xd8
>> [<c00c59c4>] simple_write_begin+0xf8/0x170
>> [<c005d18c>] generic_perform_write+0xa8/0x2ac
>> [<c005f1f8>] __generic_file_write_iter+0x1a8/0x478
>> [<c005f504>] generic_file_write_iter+0x3c/0x128
>> [<c009b0c4>] new_sync_write+0x84/0xcc
>> [<c009ba88>] vfs_write+0xe8/0x224
>> [<c009c314>] SyS_write+0x4c/0xf4
>> [<c03d5200>] xwrite+0x48/0xb8
>> [<c03d52a0>] do_copy+0x30/0x1ac
>> [<c03d47b4>] write_buffer+0x34/0x60
>> [<c03d4810>] flush_buffer+0x30/0xd0
>> [<c03e4c70>] gunzip+0x2c0/0x3ac
>> [<c03d4c20>] unpack_to_rootfs+0x1b8/0x368
>> [<c03d56e8>] populate_rootfs+0x28/0x2d8
>> [<c000044c>] do_one_initcall+0xa0/0x24c
>> [<c03d2d9c>] kernel_init_freeable+0x150/0x238
>> [<c02dedf0>] kernel_init+0x8/0x14c
>> [<c0005d78>] ret_from_kernel_thread+0x8/0x20
>>
>> Detailed logs are available at http://server.roeck-us.net:8010/builder=
s.
>>
>> bisect results:
>>
>> # bad: [7e3619a6de57f0257a2f6480182d2287ee05e314] Add linux-next speci=
fic files for 20150107
>> # good: [b1940cd21c0f4abdce101253e860feff547291b0] Linux 3.19-rc3
>> git bisect start 'HEAD' 'v3.19-rc3'
>> # bad: [c48667c5659248ff2b2fbff5cd23c43b5768e81b] Merge remote-trackin=
g branch 'net-next/master'
>> git bisect bad c48667c5659248ff2b2fbff5cd23c43b5768e81b
>> # bad: [5aa2843082a0ce9b710549bdc7ae8d54140edc70] Merge remote-trackin=
g branch 'pci/next'
>> git bisect bad 5aa2843082a0ce9b710549bdc7ae8d54140edc70
>> # good: [11339e9e3d575c1486ff57dc49c83b6154918305] Merge remote-tracki=
ng branch 'samsung/for-next'
>> git bisect good 11339e9e3d575c1486ff57dc49c83b6154918305
>> # bad: [50d16e144b253542d89830c0ace8573a67ce4b16] Merge remote-trackin=
g branch 'powerpc-mpe/next'
>> git bisect bad 50d16e144b253542d89830c0ace8573a67ce4b16
>> # good: [3fda5c0dda2eafe244898809a74831209cdb69b7] Merge remote-tracki=
ng branch 'cris/for-next'
>> git bisect good 3fda5c0dda2eafe244898809a74831209cdb69b7
>> # bad: [8b772494fda25dd998ade5621cc0684a5c897179] Merge remote-trackin=
g branch 'microblaze/next'
>> git bisect bad 8b772494fda25dd998ade5621cc0684a5c897179
>> # bad: [cd2b00db005541d15ea9fbb474b5e5e98b993d8e] microblaze: Fix vari=
able types to remove W=3D1 warning
>> git bisect bad cd2b00db005541d15ea9fbb474b5e5e98b993d8e
>> # good: [8543e6c96762fcc930af5725088c2b9e4865c3aa] microblaze: Use uns=
igned return type in do_syscall_trace_enter
>> git bisect good 8543e6c96762fcc930af5725088c2b9e4865c3aa
>> # good: [e76fdb324844cc0367f8c6ea5d13278a81568ccb] microblaze: Use uns=
igned type for "for" loop because of comparison-kgdb.c
>> git bisect good e76fdb324844cc0367f8c6ea5d13278a81568ccb
>> # bad: [b343c7d621bf801b502cba812c3dcb4320942b93] microblaze: Use unsi=
gned type for limit comparison in cache.c
>> git bisect bad b343c7d621bf801b502cba812c3dcb4320942b93
>> # good: [bdb96e3cad21f5973c95f0e6687db4a57eff7c53] microblaze: Use uns=
igned type for proper comparison in cpuinfo*.c
>> git bisect good bdb96e3cad21f5973c95f0e6687db4a57eff7c53
>> # first bad commit: [b343c7d621bf801b502cba812c3dcb4320942b93] microbl=
aze: Use unsigned type for limit comparison in cache.c
>>
>> Reverting the offending commit fixes the problem.
>>
> Followup: I think the following should fix the problem.
> My qemu tests pass with this change.
>=20
> Original patch:
>=20
> -	WARN_ON(end - start < 0);                                       \
> +	WARN_ON(end > start);                                   \
>=20
> This looks wrong, since 'end - start < 0' is equivalent to 'end < start=
',
> not 'end > start'.
>=20
> Guenter
>=20
> ---
> diff --git a/arch/microblaze/kernel/cpu/cache.c b/arch/microblaze/kerne=
l/cpu/cache.c
> index 84c9558..0bde47e 100644
> --- a/arch/microblaze/kernel/cpu/cache.c
> +++ b/arch/microblaze/kernel/cpu/cache.c
> @@ -143,7 +143,7 @@ do {									\
>  	unsigned int volatile temp =3D 0;						\
>  	unsigned int align =3D ~(line_length - 1);					\
>  	end =3D ((end & align) =3D=3D end) ? end - line_length : end & align;=
	\
> -	WARN_ON(end > start);					\
> +	WARN_ON(end < start);					\
>  									\
>  	__asm__ __volatile__ (" 1:	" #op "	%1, r0;"		\
>  					"cmpu	%0, %1, %2;"		\

yes - you are right.

Thanks for reporting this. Will fix it.

Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--S1xp5mpr7GOp3PTvrpPsIBlrD7CwcgpQ1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlSuKhgACgkQykllyylKDCGGXgCgm39GN/18Qj4vt6mXmqn4h23Z
6ucAn2zQcQg2dgjpQKH5TNcNMSiA8on6
=3Mgf
-----END PGP SIGNATURE-----

--S1xp5mpr7GOp3PTvrpPsIBlrD7CwcgpQ1--
