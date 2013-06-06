Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab3FFFgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 01:36:15 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38485 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab3FFFgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 01:36:13 -0400
Date: Thu, 6 Jun 2013 15:36:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Cooper <jason@lakedaemon.net>, <andrew@lunn.ch>,
        <gregory.clement@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: linux-next: manual merge of the mvebu tree with the imx-mxs tree
Message-Id: <20130606153600.a23c3489dc8b30d0836cb8ea@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__6_Jun_2013_15_36_00_+1000_cipSAVLwCWoA0gEm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Jun_2013_15_36_00_+1000_cipSAVLwCWoA0gEm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the mvebu tree got a conflict in
arch/arm/Kconfig.debug between commit 284166ffebc3 ("ARM: imx: enable
low-level debug support for imx6sl") from the imx-mxs tree and commit
5be22d8c29fd ("arm: mvebu: add another earlyprintk Kconfig option") from
the mvebu tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/Kconfig.debug
index 29f7623,e6a6ab1..0000000
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@@ -639,9 -656,9 +664,10 @@@ config DEBUG_LL_INCLUD
  				 DEBUG_IMX35_UART || \
  				 DEBUG_IMX51_UART || \
  				 DEBUG_IMX53_UART ||\
 -				 DEBUG_IMX6Q_UART
 +				 DEBUG_IMX6Q_UART || \
 +				 DEBUG_IMX6SL_UART
- 	default "debug/mvebu.S" if DEBUG_MVEBU_UART
+ 	default "debug/mvebu.S" if DEBUG_MVEBU_UART || \
+ 				   DEBUG_MVEBU_UART_ALTERNATE
  	default "debug/mxs.S" if DEBUG_IMX23_UART || DEBUG_IMX28_UART
  	default "debug/nomadik.S" if DEBUG_NOMADIK_UART
  	default "debug/omap2plus.S" if DEBUG_OMAP2PLUS_UART

--Signature=_Thu__6_Jun_2013_15_36_00_+1000_cipSAVLwCWoA0gEm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRsB/FAAoJEECxmPOUX5FEb/cP+wS0e+YvHo2BFiI4G5cExyKb
Nbs+/1E9jwlHNsflLgD4ZkSzlHrmTA9PZLZ97b9rIqUqmBxo4lafQnaV18uHqQi1
YHskEzJixNaIYkCJCJ4gLdgQgBvthz6UeHJtxMYAM1jw1NnZ4Nox5b4Iq8Cg7vrw
GeDfw5TAW+Xr3pC5zt4P6R8ELVZuHKnD74HGJqQONlEc7joNrLkPCI+udGI6Ww48
RU7lQqprSHXm6GNORK1yEliX0/TMBNXNaz28xKSiWZ2roHstH/Q+nrhp5kk0TSsa
lvdDE+t97mtOIMYp5/WVlL4qwMhkuGJVPHU8wUAH1CPAcMGNAjj+twmhtEzugfqF
0J6JH00rVPyo0yQ+e4bplBNM3oUvbGQuVpt55pkhZDWXAShbUDKXCIybe/O69Up3
7DQ3FNIVnVtbAchR/H2AfYX9TIMOydjq3o1fkUBh1WlO5W5IZ+Po7WnCJ5mB66ie
jmAd6TVGnZPC3xZpjVcJXzvGb7Me8v65zS+7OQ1S8hkSk4ubnZQa0IR1wJk9jX3i
Vayz7np4aK3j9fe0QdSq3m11/44ERxFfEaKbssli6GmGWGadmemK70VqszicduWB
b2VYZbEu6hwqe028I7YJ8BtYONT+AGHlxM5LMp3rT0LgPS4p+OPUwYa+1WtK1gi9
DGv2OkctjPJ7eSM8xxlj
=hdSn
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Jun_2013_15_36_00_+1000_cipSAVLwCWoA0gEm--
