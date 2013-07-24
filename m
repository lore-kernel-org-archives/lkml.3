Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab3GXHSZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 03:18:25 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:57489 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab3GXHSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 03:18:24 -0400
Message-ID: <51EF7FBD.8070103@monstr.eu>
Date: Wed, 24 Jul 2013 09:18:21 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Michal Simek'" <michal.simek@xilinx.com>,
        "'Jean-Christophe Plagniol-Villard'" <plagnioj@jcrosoft.com>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Stepan Moskovchenko'" <stepanm@codeaurora.org>
Subject: Re: [PATCH] video: xilinxfb: Fix compilation warning
References: <ed64cda456be840147ae1f04bec6a99733f41c24.1374643896.git.michal.simek@xilinx.com> <007401ce8833$22ce0600$686a1200$@samsung.com>
In-Reply-To: <007401ce8833$22ce0600$686a1200$@samsung.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2TTNSLCOGTBHOSPNSWMEQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2TTNSLCOGTBHOSPNSWMEQ
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 07/24/2013 08:00 AM, Jingoo Han wrote:
> On Wednesday, July 24, 2013 2:32 PM, Michal Simek wrote:
>>
>> regs_phys is phys_addr_t (u32 or u64).
>> Lets retype it to u64.
>>
>> Fixes compilation warning introduced by:
>> video: xilinxfb: Use drvdata->regs_phys instead of physaddr
>> (sha1: c88fafef0135e1e1c3e23c3e32ccbeeabc587f81)
>=20
> CC'ed Stepan Moskovchenko
>=20
>=20
> phys_addr_t is defined as below:
>=20
> #ifdef CONFIG_PHYS_ADDR_T_64BIT
> typedef u64 phys_addr_t;
> #else
> typedef u32 phys_addr_t;
> #endif
>=20
> According to 'Documentation/printk-formats.txt',
> Physical addresses:
>        %pa     0x01234567 or 0x0123456789abcdef
>        For printing a phys_addr_t type (and its derivatives, such as
>        resource_size_t) which can vary based on build options, regardle=
ss of
>        the width of the CPU data path. Passed by reference.
>=20
> Thus, '%pa' option looks proper, instead of casting (unsigned long long=
).
>=20
> 		dev_dbg(dev, "regs: phys=3D%pa, virt=3D%p\n", drvdata->regs_phys,
> 					drvdata->regs);
>=20

Ah. Wasn't aware about that.
Will retest.

Thanks,
Michal



--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2TTNSLCOGTBHOSPNSWMEQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlHvf70ACgkQykllyylKDCGj2ACfYt5Oa5HzlUdQs0/pneQyeXGw
MqMAn2E+741ugPaBvMFsp+Cbhy1Orv57
=Shcl
-----END PGP SIGNATURE-----

------enig2TTNSLCOGTBHOSPNSWMEQ--
