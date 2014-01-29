Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbaA2D0F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 22:26:05 -0500
Received: from ozlabs.org ([203.10.76.45]:52852 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbaA2D0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 22:26:02 -0500
Date: Wed, 29 Jan 2014 14:25:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: linux-next: manual merge of the clk tree with Linus' tree
Message-Id: <20140129142551.6e6e27fc1a9440c762370af1@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__29_Jan_2014_14_25_51_+1100_LSzBOTd.wnvuSkK="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__29_Jan_2014_14_25_51_+1100_LSzBOTd.wnvuSkK=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mike,

Today's linux-next merge of the clk tree got a conflict in
drivers/clk/Makefile between commit 0ad6125b1579 ("clk: at91: add PMC
base support") from Linus' tree and commit fd3fdaf09f26 ("clk: sort
Makefile") from the clk tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/clk/Makefile
index a277875d64a7,51a4c0dac1af..000000000000
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@@ -9,46 -9,43 +9,44 @@@ obj-$(CONFIG_COMMON_CLK)	+=3D clk-gate.
  obj-$(CONFIG_COMMON_CLK)	+=3D clk-mux.o
  obj-$(CONFIG_COMMON_CLK)	+=3D clk-composite.o
 =20
- # SoCs specific
- obj-$(CONFIG_ARCH_BCM2835)	+=3D clk-bcm2835.o
- obj-$(CONFIG_ARCH_EFM32)	+=3D clk-efm32gg.o
- obj-$(CONFIG_ARCH_NOMADIK)	+=3D clk-nomadik.o
- obj-$(CONFIG_ARCH_HIGHBANK)	+=3D clk-highbank.o
- obj-$(CONFIG_ARCH_HI3xxx)	+=3D hisilicon/
- obj-$(CONFIG_ARCH_NSPIRE)	+=3D clk-nspire.o
- obj-$(CONFIG_ARCH_MXS)		+=3D mxs/
- obj-$(CONFIG_ARCH_SOCFPGA)	+=3D socfpga/
- obj-$(CONFIG_PLAT_SPEAR)	+=3D spear/
- obj-$(CONFIG_ARCH_U300)		+=3D clk-u300.o
- obj-$(CONFIG_COMMON_CLK_VERSATILE) +=3D versatile/
- obj-$(CONFIG_COMMON_CLK_QCOM)	+=3D qcom/
- obj-$(CONFIG_PLAT_ORION)	+=3D mvebu/
+ # hardware specific clock types
+ # please keep this section sorted lexicographically by file/directory pat=
h name
++obj-$(CONFIG_COMMON_CLK_AT91)		+=3D at91/
+ obj-$(CONFIG_COMMON_CLK_AXI_CLKGEN)	+=3D clk-axi-clkgen.o
+ obj-$(CONFIG_ARCH_BCM2835)		+=3D clk-bcm2835.o
+ obj-$(CONFIG_ARCH_EFM32)		+=3D clk-efm32gg.o
+ obj-$(CONFIG_ARCH_HIGHBANK)		+=3D clk-highbank.o
+ obj-$(CONFIG_MACH_LOONGSON1)		+=3D clk-ls1x.o
+ obj-$(CONFIG_COMMON_CLK_MAX77686)	+=3D clk-max77686.o
+ obj-$(CONFIG_ARCH_NOMADIK)		+=3D clk-nomadik.o
+ obj-$(CONFIG_ARCH_NSPIRE)		+=3D clk-nspire.o
+ obj-$(CONFIG_CLK_PPC_CORENET)		+=3D clk-ppc-corenet.o
+ obj-$(CONFIG_COMMON_CLK_S2MPS11)	+=3D clk-s2mps11.o
+ obj-$(CONFIG_COMMON_CLK_SI5351)		+=3D clk-si5351.o
+ obj-$(CONFIG_COMMON_CLK_SI570)		+=3D clk-si570.o
+ obj-$(CONFIG_CLK_TWL6040)		+=3D clk-twl6040.o
+ obj-$(CONFIG_ARCH_U300)			+=3D clk-u300.o
+ obj-$(CONFIG_ARCH_VT8500)		+=3D clk-vt8500.o
+ obj-$(CONFIG_COMMON_CLK_WM831X)		+=3D clk-wm831x.o
+ obj-$(CONFIG_COMMON_CLK_XGENE)		+=3D clk-xgene.o
+ obj-$(CONFIG_ARCH_HI3xxx)		+=3D hisilicon/
+ obj-$(CONFIG_COMMON_CLK_KEYSTONE)	+=3D keystone/
  ifeq ($(CONFIG_COMMON_CLK), y)
- obj-$(CONFIG_ARCH_MMP)		+=3D mmp/
+ obj-$(CONFIG_ARCH_MMP)			+=3D mmp/
  endif
- obj-$(CONFIG_MACH_LOONGSON1)	+=3D clk-ls1x.o
- obj-$(CONFIG_ARCH_ROCKCHIP)	+=3D rockchip/
- obj-$(CONFIG_ARCH_SUNXI)	+=3D sunxi/
- obj-$(CONFIG_ARCH_U8500)	+=3D ux500/
- obj-$(CONFIG_ARCH_VT8500)	+=3D clk-vt8500.o
- obj-$(CONFIG_ARCH_SIRF)		+=3D sirf/
- obj-$(CONFIG_ARCH_ZYNQ)		+=3D zynq/
- obj-$(CONFIG_ARCH_TEGRA)	+=3D tegra/
- obj-$(CONFIG_PLAT_SAMSUNG)	+=3D samsung/
- obj-$(CONFIG_COMMON_CLK_XGENE)  +=3D clk-xgene.o
- obj-$(CONFIG_COMMON_CLK_KEYSTONE)	+=3D keystone/
- obj-$(CONFIG_COMMON_CLK_AT91)	+=3D at91/
+ obj-$(CONFIG_PLAT_ORION)		+=3D mvebu/
+ obj-$(CONFIG_ARCH_MXS)			+=3D mxs/
+ obj-$(CONFIG_COMMON_CLK_QCOM)		+=3D qcom/
+ obj-$(CONFIG_ARCH_ROCKCHIP)		+=3D rockchip/
+ obj-$(CONFIG_PLAT_SAMSUNG)		+=3D samsung/
  obj-$(CONFIG_ARCH_SHMOBILE_MULTI)	+=3D shmobile/
-=20
- obj-$(CONFIG_X86)		+=3D x86/
- obj-$(CONFIG_ARCH_BCM)		+=3D bcm/
-=20
- # Chip specific
- obj-$(CONFIG_COMMON_CLK_AXI_CLKGEN) +=3D clk-axi-clkgen.o
- obj-$(CONFIG_COMMON_CLK_WM831X) +=3D clk-wm831x.o
- obj-$(CONFIG_COMMON_CLK_MAX77686) +=3D clk-max77686.o
- obj-$(CONFIG_COMMON_CLK_SI5351) +=3D clk-si5351.o
- obj-$(CONFIG_COMMON_CLK_SI570) +=3D clk-si570.o
- obj-$(CONFIG_COMMON_CLK_S2MPS11) +=3D clk-s2mps11.o
- obj-$(CONFIG_CLK_TWL6040)	+=3D clk-twl6040.o
- obj-$(CONFIG_CLK_PPC_CORENET)	+=3D clk-ppc-corenet.o
+ obj-$(CONFIG_ARCH_SIRF)			+=3D sirf/
+ obj-$(CONFIG_ARCH_SOCFPGA)		+=3D socfpga/
+ obj-$(CONFIG_PLAT_SPEAR)		+=3D spear/
+ obj-$(CONFIG_ARCH_SUNXI)		+=3D sunxi/
+ obj-$(CONFIG_ARCH_TEGRA)		+=3D tegra/
+ obj-$(CONFIG_ARCH_OMAP2PLUS)		+=3D ti/
+ obj-$(CONFIG_ARCH_U8500)		+=3D ux500/
+ obj-$(CONFIG_COMMON_CLK_VERSATILE)	+=3D versatile/
+ obj-$(CONFIG_X86)			+=3D x86/
+ obj-$(CONFIG_ARCH_ZYNQ)			+=3D zynq/

--Signature=_Wed__29_Jan_2014_14_25_51_+1100_LSzBOTd.wnvuSkK=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS6HTEAAoJEMDTa8Ir7ZwV7cMP/1V4XAGFCGNgOl97cauTIN5I
6hm4CTyVziQqsvfQ77O13CLKeowbfE730WrFkSe/4UOxekwOhxMLmtY5ICWqwmUP
FI8FWZZybv1+Rg3Q+5a/XwFwaN01SY3NXwTuS3aQON6cLZxT5jfJeDGr9q+KWjII
BnOyJ5i6EZi66AGnJ5QzpD0EMP5VapyoGuPsc92Q83GiKZDoh6npnHzA2/UmP5yo
WK4zlSoJvNyK8PfPiXGKFt1pXthf1SXt7WGFZx28l+SS1wNDMoidTaUF93mxuhNk
7evbK5gkqIS9ZO9bS111GLOIlKjR6hA3E1Gq6kF/KB/v53VLx1Vu05mDlLlXoOG8
ULj8fzbg65mqUsnE6BWdkp45iurSZmaklzYg6VW1xVMXXeR1hUFmgBhjb/7cVtgX
lnV4QJgWd+BX9YISdRMxhRhjv38EPFk3Z2CzVFDMQO5Y2DW0AvBdQxTxz01jU/b8
SnzvLguiKKGLIX6NO9K7cFCn+qYsrKcjENCB2L5xA5nv1GPR4Ln8zsSWCcPheJRP
g8MoF4LY5hTXjNlDhzCH4HygcQF15Q57LHH9LEgJtw60BvjYX9paI32/TnlaQ53Z
gb0D5T5A0O/0cFYuAh/WY7bVerZLz4ucMYjm1IvTZk2BZT1Lwz0c00fVqbxcj7Dh
KA53A8p1Z9jPXV80D1xu
=MG+s
-----END PGP SIGNATURE-----

--Signature=_Wed__29_Jan_2014_14_25_51_+1100_LSzBOTd.wnvuSkK=--
