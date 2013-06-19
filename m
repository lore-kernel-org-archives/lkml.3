Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab3FSGY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 02:24:56 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34923 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab3FSGYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 02:24:55 -0400
Date: Wed, 19 Jun 2013 16:24:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: linux-next: manual merge of the imx-mxs tree with the arm-soc tree
Message-Id: <20130619162449.5b0a64cc42e7cb9a744624e9@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__19_Jun_2013_16_24_49_+1000_XryU=g+4VCHqAjtt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__19_Jun_2013_16_24_49_+1000_XryU=g+4VCHqAjtt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Shawn,

Today's linux-next merge of the imx-mxs tree got a conflict in
arch/arm/Kconfig.debug between commit 828989ad87af ("ARM: keystone: Add
minimal TI Keystone platform support") from the arm-soc tree and commit
34e8a16b944e ("ARM: imx: enable low-level debug support for imx6sl") from
the imx-mxs tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/Kconfig.debug
index 4649bf5,29f7623..0000000
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@@ -251,20 -251,13 +251,27 @@@ choic
  		  Say Y here if you want kernel low-level debugging support
  		  on i.MX6Q/DL.
 =20
+ 	config DEBUG_IMX6SL_UART
+ 		bool "i.MX6SL Debug UART"
+ 		depends on SOC_IMX6SL
+ 		help
+ 		  Say Y here if you want kernel low-level debugging support
+ 		  on i.MX6SL.
+=20
 +	config DEBUG_KEYSTONE_UART0
 +		bool "Kernel low-level debugging on KEYSTONE2 using UART0"
 +		depends on ARCH_KEYSTONE
 +		help
 +		  Say Y here if you want the debug print routines to direct
 +		  their output to UART0 serial port on KEYSTONE2 devices.
 +
 +	config DEBUG_KEYSTONE_UART1
 +		bool "Kernel low-level debugging on KEYSTONE2 using UART1"
 +		depends on ARCH_KEYSTONE
 +		help
 +		  Say Y here if you want the debug print routines to direct
 +		  their output to UART1 serial port on KEYSTONE2 devices.
 +
  	config DEBUG_MMP_UART2
  		bool "Kernel low-level debugging message via MMP UART2"
  		depends on ARCH_MMP
@@@ -677,11 -639,9 +685,12 @@@ config DEBUG_LL_INCLUD
  				 DEBUG_IMX35_UART || \
  				 DEBUG_IMX51_UART || \
  				 DEBUG_IMX53_UART ||\
- 				 DEBUG_IMX6Q_UART
+ 				 DEBUG_IMX6Q_UART || \
+ 				 DEBUG_IMX6SL_UART
 -	default "debug/mvebu.S" if DEBUG_MVEBU_UART
 +	default "debug/keystone.S" if DEBUG_KEYSTONE_UART0 || \
 +				      DEBUG_KEYSTONE_UART1
 +	default "debug/mvebu.S" if DEBUG_MVEBU_UART || \
 +				   DEBUG_MVEBU_UART_ALTERNATE
  	default "debug/mxs.S" if DEBUG_IMX23_UART || DEBUG_IMX28_UART
  	default "debug/nomadik.S" if DEBUG_NOMADIK_UART
  	default "debug/omap2plus.S" if DEBUG_OMAP2PLUS_UART

--Signature=_Wed__19_Jun_2013_16_24_49_+1000_XryU=g+4VCHqAjtt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRwU6xAAoJEECxmPOUX5FEY78QAJP5/3/3v1RfDGtZyeJR1HO1
ThFbju+NnwbFYvXWWkX/Gne0EJ8OqTw0njwSBQ92UFdnXuuoiG+3bgUadjznuIv6
PJlOBq50WjzRrsvZ4Ry5FPZKfrp9h1uP/+o1uhjNWKXTu70CH0DCwTvNC54/RRde
o41a7uMKFdUI3egod6D4TU8mcWqticf0CkY2gotAaXzAGooPUoYWRRs2/bsppNn9
a9O2yoxxJx6GljsxXQl753kOsE0xyF1LQfr/x2O9GPwiNi87AC2blybXZh8Uwi5R
AlJp7Ryr40uihFBEKR2yjaMT8xd/ITwxvy9zH9MxGZVH0b2y5tnkiSOwvmDfJMxq
ZcdRVE/MGmM2K801Jj3qxHo2lUCDKtVZdq3EZIbNLulKlCs/unX7N26NgizOv5C9
83CHj1IdO3uULmuZA2DBGatwMcLrxg+cF3lgM+12P7RfL6t0JMk5m4MBHx3iwqwk
aUJysQvexZI/11Xkog8p13S0Mvcgi8eKlJEHVtxhf7h2OOqTrIO/GPPm0o7/6tVC
FPrh4incRNKgOmA63ggrN+j+84Rov68QndEL5wPHqk00AzvbiE8G0BqAYpPqsGQc
BhG19I6GwWEwDAMMzdyjAaHxNkuKreg+9AJ1O85GzNZKzzugwu1ZqEXN/RJL+iSn
Bzs7mwT26hXgVsT4G9KJ
=KMt0
-----END PGP SIGNATURE-----

--Signature=_Wed__19_Jun_2013_16_24_49_+1000_XryU=g+4VCHqAjtt--
