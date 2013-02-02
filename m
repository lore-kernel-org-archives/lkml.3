Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395Ab3BBM1z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 07:27:55 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:43308 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756859Ab3BBM1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 07:27:53 -0500
Date: Sat, 2 Feb 2013 23:27:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mike Turquette <mturquette@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
Subject: linux-next: manual merge of the clk tree with the arm-soc tree
Message-Id: <20130202232740.f337dc3a00741a224a4a0e4f@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__2_Feb_2013_23_27_40_+1100_sW65nj_ZkFSB1xIs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__2_Feb_2013_23_27_40_+1100_sW65nj_ZkFSB1xIs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mike,

Today's linux-next merge of the clk tree got a conflict in
include/asm-generic/vmlinux.lds.h between commit ae278a935f08
("clocksource: add common of_clksrc_init() function") from the arm-soc
tree and commit f2f6c2556dcc ("clk: add common of_clk_init() function")
from the clk tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/asm-generic/vmlinux.lds.h
index fc62ac5,c1fe60a..0000000
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@@ -149,25 -149,16 +149,34 @@@
  #define TRACE_SYSCALLS()
  #endif
 =20
 +#ifdef CONFIG_CLKSRC_OF
 +#define CLKSRC_OF_TABLES() . =3D ALIGN(8);				\
 +			   VMLINUX_SYMBOL(__clksrc_of_table) =3D .;	\
 +			   *(__clksrc_of_table)				\
 +			   *(__clksrc_of_table_end)
 +#else
 +#define CLKSRC_OF_TABLES()
 +#endif
 +
 +#ifdef CONFIG_IRQCHIP
 +#define IRQCHIP_OF_MATCH_TABLE()					\
 +	. =3D ALIGN(8);							\
 +	VMLINUX_SYMBOL(__irqchip_begin) =3D .;				\
 +	*(__irqchip_of_table)		  				\
 +	*(__irqchip_of_end)
 +#else
 +#define IRQCHIP_OF_MATCH_TABLE()
 +#endif
 =20
+ #ifdef CONFIG_COMMON_CLK
+ #define CLK_OF_TABLES() . =3D ALIGN(8);				\
+ 			VMLINUX_SYMBOL(__clk_of_table) =3D .;	\
+ 			*(__clk_of_table)			\
+ 			*(__clk_of_table_end)
+ #else
+ #define CLK_OF_TABLES()
+ #endif
+=20
  #define KERNEL_DTB()							\
  	STRUCT_ALIGN();							\
  	VMLINUX_SYMBOL(__dtb_start) =3D .;				\
@@@ -511,9 -502,8 +520,10 @@@
  	DEV_DISCARD(init.rodata)					\
  	CPU_DISCARD(init.rodata)					\
  	MEM_DISCARD(init.rodata)					\
 +	CLKSRC_OF_TABLES()						\
+ 	CLK_OF_TABLES()							\
 -	KERNEL_DTB()
 +	KERNEL_DTB()							\
 +	IRQCHIP_OF_MATCH_TABLE()
 =20
  #define INIT_TEXT							\
  	*(.init.text)							\

--Signature=_Sat__2_Feb_2013_23_27_40_+1100_sW65nj_ZkFSB1xIs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRDQY8AAoJEECxmPOUX5FEplQP+QGl2rg61nwHAhUwa8t41mjI
1EXG/T/GqNLPM8tSnChdnyjk99Hywt2MZD1tYIvFzPMd8dHi4av8tCBtpMzaPqvi
wY5by4vYK7aCb6wM2ghmO2kIPhetvD/7lOCAkSrdvE2J+6i3o2iRQ0ecKfkjJjVq
pQQaClpH8gO/OF1V0knL4RVTB3crHn+AyzhvdwTV725KkGyawf+vj+b2QPRWrPeM
TF2rb093CkYkogEBbJGPCXWwbE5M1wAVqr3o4GkUDEN2BYEZWW1gxaqs4r2LIIri
rzYe0pg6LYeePaGTuDENT8YN8zI1i8mIsELO+BfVA2wHTuaLm58d+fvOSaEXFAJC
w1yzQFy34cQcq6ReZedDrV/oP5lo4BNDo1maUBlGqQOP4tXP4pNyn/+7STY8NNwZ
zS5FEaUVswYTj4TdzNKtiV4VXczMRsm8YCwzbSKIOLxd1DMZvkTzI0YTirTWZqqM
jEEMizIfMX2/TcfV+ID6saAb7q9tztARvfnZ6VA5S5VYb9WIvMtLaR1at5yqF/Po
W9hEEOb0/+Izsjm7JKeflz/xgyb5u2lXCDmAmIMJQr5H88TsXqpQJm4b8SNN1kF1
ST5bQ9/jyNaH6oKSQxGbntLcOmnzNQPNSEA3cdipaPgSOmQiVNndDfN/0z7aEc8A
tUw/nfU4638Fa7MpNrXk
=RpfZ
-----END PGP SIGNATURE-----

--Signature=_Sat__2_Feb_2013_23_27_40_+1100_sW65nj_ZkFSB1xIs--
