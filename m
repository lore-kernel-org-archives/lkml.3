Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636AbaA3ATc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 19:19:32 -0500
Received: from ozlabs.org ([203.10.76.45]:44908 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212AbaA3AT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 19:19:28 -0500
Date: Thu, 30 Jan 2014 11:19:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>, Alex Elder <elder@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>
Subject: linux-next: manual merge of the arm-soc tree with Linus' tree
Message-Id: <20140130111919.afc7f4e5b58e409aaabf7550@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__30_Jan_2014_11_19_19_+1100_Z01f.ssaHwONWiC0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__30_Jan_2014_11_19_19_+1100_Z01f.ssaHwONWiC0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/clk/Makefile between commit fd3fdaf09f26 ("clk: sort Makefile")
from Linus' tree and commit 7ee2c5117483 ("clk: bcm281xx: add initial
clock framework support") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/clk/Makefile
index a367a9831717,7c7f40e9ba05..000000000000
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@@ -9,44 -9,44 +9,45 @@@ obj-$(CONFIG_COMMON_CLK)	+=3D clk-gate.
  obj-$(CONFIG_COMMON_CLK)	+=3D clk-mux.o
  obj-$(CONFIG_COMMON_CLK)	+=3D clk-composite.o
 =20
 -# SoCs specific
 -obj-$(CONFIG_ARCH_BCM2835)	+=3D clk-bcm2835.o
 -obj-$(CONFIG_ARCH_EFM32)	+=3D clk-efm32gg.o
 -obj-$(CONFIG_ARCH_NOMADIK)	+=3D clk-nomadik.o
 -obj-$(CONFIG_ARCH_HIGHBANK)	+=3D clk-highbank.o
 -obj-$(CONFIG_ARCH_HI3xxx)	+=3D hisilicon/
 -obj-$(CONFIG_ARCH_NSPIRE)	+=3D clk-nspire.o
 -obj-$(CONFIG_ARCH_MXS)		+=3D mxs/
 -obj-$(CONFIG_ARCH_SOCFPGA)	+=3D socfpga/
 -obj-$(CONFIG_PLAT_SPEAR)	+=3D spear/
 -obj-$(CONFIG_ARCH_U300)		+=3D clk-u300.o
 -obj-$(CONFIG_COMMON_CLK_VERSATILE) +=3D versatile/
 -obj-$(CONFIG_ARCH_SIRF)		+=3D clk-prima2.o
 -obj-$(CONFIG_PLAT_ORION)	+=3D mvebu/
 +# hardware specific clock types
 +# please keep this section sorted lexicographically by file/directory pat=
h name
++obj-$(CONFIG_ARCH_BCM)			+=3D bcm/
 +obj-$(CONFIG_COMMON_CLK_AXI_CLKGEN)	+=3D clk-axi-clkgen.o
 +obj-$(CONFIG_ARCH_BCM2835)		+=3D clk-bcm2835.o
 +obj-$(CONFIG_ARCH_EFM32)		+=3D clk-efm32gg.o
 +obj-$(CONFIG_ARCH_HIGHBANK)		+=3D clk-highbank.o
 +obj-$(CONFIG_MACH_LOONGSON1)		+=3D clk-ls1x.o
 +obj-$(CONFIG_COMMON_CLK_MAX77686)	+=3D clk-max77686.o
 +obj-$(CONFIG_ARCH_NOMADIK)		+=3D clk-nomadik.o
 +obj-$(CONFIG_ARCH_NSPIRE)		+=3D clk-nspire.o
 +obj-$(CONFIG_CLK_PPC_CORENET)		+=3D clk-ppc-corenet.o
 +obj-$(CONFIG_COMMON_CLK_S2MPS11)	+=3D clk-s2mps11.o
 +obj-$(CONFIG_COMMON_CLK_SI5351)		+=3D clk-si5351.o
 +obj-$(CONFIG_COMMON_CLK_SI570)		+=3D clk-si570.o
 +obj-$(CONFIG_CLK_TWL6040)		+=3D clk-twl6040.o
 +obj-$(CONFIG_ARCH_U300)			+=3D clk-u300.o
 +obj-$(CONFIG_ARCH_VT8500)		+=3D clk-vt8500.o
 +obj-$(CONFIG_COMMON_CLK_WM831X)		+=3D clk-wm831x.o
 +obj-$(CONFIG_COMMON_CLK_XGENE)		+=3D clk-xgene.o
 +obj-$(CONFIG_COMMON_CLK_AT91)		+=3D at91/
 +obj-$(CONFIG_ARCH_HI3xxx)		+=3D hisilicon/
 +obj-$(CONFIG_COMMON_CLK_KEYSTONE)	+=3D keystone/
  ifeq ($(CONFIG_COMMON_CLK), y)
 -obj-$(CONFIG_ARCH_MMP)		+=3D mmp/
 +obj-$(CONFIG_ARCH_MMP)			+=3D mmp/
  endif
 -obj-$(CONFIG_MACH_LOONGSON1)	+=3D clk-ls1x.o
 -obj-$(CONFIG_ARCH_ROCKCHIP)	+=3D rockchip/
 -obj-$(CONFIG_ARCH_SUNXI)	+=3D sunxi/
 -obj-$(CONFIG_ARCH_U8500)	+=3D ux500/
 -obj-$(CONFIG_ARCH_VT8500)	+=3D clk-vt8500.o
 -obj-$(CONFIG_ARCH_ZYNQ)		+=3D zynq/
 -obj-$(CONFIG_ARCH_TEGRA)	+=3D tegra/
 -obj-$(CONFIG_PLAT_SAMSUNG)	+=3D samsung/
 -obj-$(CONFIG_COMMON_CLK_XGENE)  +=3D clk-xgene.o
 -obj-$(CONFIG_COMMON_CLK_KEYSTONE)	+=3D keystone/
 -obj-$(CONFIG_COMMON_CLK_AT91)	+=3D at91/
 +obj-$(CONFIG_PLAT_ORION)		+=3D mvebu/
 +obj-$(CONFIG_ARCH_MXS)			+=3D mxs/
 +obj-$(CONFIG_COMMON_CLK_QCOM)		+=3D qcom/
 +obj-$(CONFIG_ARCH_ROCKCHIP)		+=3D rockchip/
 +obj-$(CONFIG_PLAT_SAMSUNG)		+=3D samsung/
  obj-$(CONFIG_ARCH_SHMOBILE_MULTI)	+=3D shmobile/
 -
 -obj-$(CONFIG_X86)		+=3D x86/
 -obj-$(CONFIG_ARCH_BCM)		+=3D bcm/
 -
 -# Chip specific
 -obj-$(CONFIG_COMMON_CLK_AXI_CLKGEN) +=3D clk-axi-clkgen.o
 -obj-$(CONFIG_COMMON_CLK_WM831X) +=3D clk-wm831x.o
 -obj-$(CONFIG_COMMON_CLK_MAX77686) +=3D clk-max77686.o
 -obj-$(CONFIG_COMMON_CLK_SI5351) +=3D clk-si5351.o
 -obj-$(CONFIG_COMMON_CLK_S2MPS11) +=3D clk-s2mps11.o
 -obj-$(CONFIG_CLK_TWL6040)	+=3D clk-twl6040.o
 -obj-$(CONFIG_CLK_PPC_CORENET)	+=3D clk-ppc-corenet.o
 +obj-$(CONFIG_ARCH_SIRF)			+=3D sirf/
 +obj-$(CONFIG_ARCH_SOCFPGA)		+=3D socfpga/
 +obj-$(CONFIG_PLAT_SPEAR)		+=3D spear/
 +obj-$(CONFIG_ARCH_SUNXI)		+=3D sunxi/
 +obj-$(CONFIG_ARCH_TEGRA)		+=3D tegra/
 +obj-$(CONFIG_ARCH_OMAP2PLUS)		+=3D ti/
 +obj-$(CONFIG_ARCH_U8500)		+=3D ux500/
 +obj-$(CONFIG_COMMON_CLK_VERSATILE)	+=3D versatile/
 +obj-$(CONFIG_X86)			+=3D x86/
 +obj-$(CONFIG_ARCH_ZYNQ)			+=3D zynq/

--Signature=_Thu__30_Jan_2014_11_19_19_+1100_Z01f.ssaHwONWiC0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS6ZqLAAoJEMDTa8Ir7ZwVYhsP/3DXJIaiAIiMmOAsKIjZWmBa
vhYnncNobHYkrYAe/aYGV8Gj5TLfZlIaJbFwotF+p1k5my6gM6Y33t6hP/h9BmTo
jdQ50PoLOf0uR6EoTY0fyMz8U2imwDUSshaFP2IDRgF8orep4BTi2n8n2drje010
crPns9t5n5S3ELzWBiPapt7GxnnWIsMA/5H+m5buKFtEKOVxtEaOeW2zsraJof6e
PIHzI5caztjkclF9H/MXrzuVGuXOAztdB4J42gg8gmJrFFUm04v6J2CBXo3SA9+q
IdRLdqLkEtR4stT4F1OkfZKvhoUBwJESiTGJwoccMpHklhMl3o1vzgJEZyXT14oP
/MurwM2YWzxid9XGadYpOacLjdmmM/BxgtpMnFgj8C3xKi9x+VDUf+LuRD318N2h
BEiLnu95KSe0+b3rf5zzLTz4TuFEn5A0KdksOhkENJKXnsOhuPni8zCYKkHxmNwi
Zn8Zf8roSRMtWv7DKA5Ef0Pihnl9+er/Vd9dxMDu1dUyWHtf4bD1dp+AXP7/d0pY
gG+kXvRRj4VYngt4LctKcMjKKnfhnt422IkpmRGA6de/T8R+f00xW3d/o9ptmU/F
HJaHcM+0TsZVTjsgbC939xITGLR8RKx3PjJ2kt65xjlOZIJf0LCCxy6VL/h4jV7S
meLkWe5i7OHOwwuR+hRL
=KX/8
-----END PGP SIGNATURE-----

--Signature=_Thu__30_Jan_2014_11_19_19_+1100_Z01f.ssaHwONWiC0--
