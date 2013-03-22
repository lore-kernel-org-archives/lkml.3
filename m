Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114Ab3CVEJy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 00:09:54 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:50087 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab3CVEJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 00:09:53 -0400
Date: Fri, 22 Mar 2013 15:09:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>,
        Anson Huang <b20788@freescale.com>
Subject: linux-next: manual merge of the imx-mxs tree with the arm-soc tree
Message-Id: <20130322150941.dd103b83bc0da8a4bcb1647f@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__22_Mar_2013_15_09_41_+1100_L6vLV3z+j=a2lcvQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__22_Mar_2013_15_09_41_+1100_L6vLV3z+j=a2lcvQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Shawn,

Today's linux-next merge of the imx-mxs tree got a conflict in
arch/arm/mach-imx/mach-imx6q.c between commit da4a686a2cfb ("ARM:
smp_twd: convert to use CLKSRC_OF init") from the arm-soc tree and commit
371287432334 ("ARM: imx: enable anatop suspend/resume") from the imx-mxs
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-imx/mach-imx6q.c
index b59ddcb,31aee4d..0000000
--- a/arch/arm/mach-imx/mach-imx6q.c
+++ b/arch/arm/mach-imx/mach-imx6q.c
@@@ -291,8 -257,7 +256,7 @@@ static void __init imx6q_init_irq(void
  static void __init imx6q_timer_init(void)
  {
  	mx6q_clocks_init();
 -	twd_local_timer_of_register();
 +	clocksource_of_init();
- 	imx_print_silicon_rev("i.MX6Q", imx6q_revision());
  }
 =20
  static const char *imx6q_dt_compat[] __initdata =3D {

--Signature=_Fri__22_Mar_2013_15_09_41_+1100_L6vLV3z+j=a2lcvQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRS9mFAAoJEECxmPOUX5FExLoP/15P6KPjEIkPVN0EBrrPCebR
XcnoZRT/SKIfigMC0pj/QYdaSi7CZvK32MJfWXqVFEKMF8JIIcKVhVHSZ813ZAFb
TrTof+D1AvK7McfL/sO2Qs9ifmPgKyoJ+uNlMivukmmABjvNxtcoyne8bnu3Ekxr
JoL1CoN/xCmOFmizKFMlQpjiNKK/tBexj7RAt1/THADFaXcJGTV3mAZMF+WxPZXF
OZfIVE8tP+sZmpxcu9E/bDdamyxIzKliyLHHp+48cVg+vHNOTwvUbV0hiKq6DQ1F
81gCQuMU1aW2em+VekBFUDDAaXD9HaGtpRsjF68cDQBUBBzwqPOJBfmtZUxs+yRl
mpi1Z7Gzui8lxLmIq+Ec32qw4lpQ8RcQLHFqlt46B/Gs3aLKk6dXUBdD9Omv7hIl
Xh9pimVEPpHpUwpDPhfqlkRaf6B8igIelQ6DC1/bUag43n2BmHytejiLfMuOeW5y
P/4z10nDnpEDeoMxe22jMEOuRmlUpPI9f1Gwjr/zhobL923NPKPS0OGVQfpcN7SK
ibmY1rQk5aIcr3045VhdpgGSyL1noDgKjS41k0RXwcbJiEt9YRQKULRfYxwlbE+K
9h7mDCs7aWHoV3V3Nj4EiRZ87JKk99sQHOU1kK7SXU1Z5x17048igt3s5mQSM/+6
95q4gxboKgh0X39Tr0FY
=tBDq
-----END PGP SIGNATURE-----

--Signature=_Fri__22_Mar_2013_15_09_41_+1100_L6vLV3z+j=a2lcvQ--
