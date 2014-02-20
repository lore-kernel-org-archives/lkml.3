Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189AbaBTAmx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 19:42:53 -0500
Received: from ozlabs.org ([203.10.76.45]:48024 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbaBTAmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 19:42:51 -0500
Date: Thu, 20 Feb 2014 11:42:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Shawn Guo <shawn.guo@linaro.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anson Huang <b20788@freescale.com>
Subject: linux-next: manual merge of the imx-mxs tree with the arm-soc tree
Message-Id: <20140220114242.b3ce4d77b677544d2feebd3e@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__20_Feb_2014_11_42_42_+1100_bK+0maUKHdFP2HKR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__20_Feb_2014_11_42_42_+1100_bK+0maUKHdFP2HKR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Shawn,

Today's linux-next merge of the imx-mxs tree got conflicts in
arch/arm/mach-imx/Makefile and arch/arm/mach-imx/common.h between commit
28a9f3b078c5 ("ARM: imx6: build pm-imx6q.c independently of CONFIG_PM")
from the arm-soc tree and commits 8dd751932545 ("ARM: imx: add suspend in
ocram support for i.mx6q") and 79a8eef47d12 ("RM: imx: add suspend in
ocram support for i.mx6sl") from the imx-mxs tree.

I fixed it up (I think, see below) and can carry the fix as necessary (no
action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-imx/Makefile
index ec419649320f,02cbb48c1d0a..000000000000
--- a/arch/arm/mach-imx/Makefile
+++ b/arch/arm/mach-imx/Makefile
@@@ -101,10 -102,13 +102,17 @@@ obj-$(CONFIG_HOTPLUG_CPU) +=3D hotplug.
  obj-$(CONFIG_SOC_IMX6Q) +=3D clk-imx6q.o mach-imx6q.o
  obj-$(CONFIG_SOC_IMX6SL) +=3D clk-imx6sl.o mach-imx6sl.o
 =20
 +obj-$(CONFIG_SOC_IMX6Q) +=3D pm-imx6q.o headsmp.o
 +# i.MX6SL reuses i.MX6Q code
 +obj-$(CONFIG_SOC_IMX6SL) +=3D pm-imx6q.o headsmp.o
 +
+ ifeq ($(CONFIG_PM),y)
+ AFLAGS_suspend-imx6.o :=3D-Wa,-march=3Darmv7-a
 -obj-$(CONFIG_SOC_IMX6Q) +=3D pm-imx6q.o headsmp.o suspend-imx6.o
++obj-$(CONFIG_SOC_IMX6Q) +=3D suspend-imx6.o
+ # i.MX6SL reuses i.MX6Q code
 -obj-$(CONFIG_SOC_IMX6SL) +=3D pm-imx6q.o headsmp.o suspend-imx6.o
++obj-$(CONFIG_SOC_IMX6SL) +=3D suspend-imx6.o
+ endif
+=20
  # i.MX5 based machines
  obj-$(CONFIG_MACH_MX51_BABBAGE) +=3D mach-mx51_babbage.o
  obj-$(CONFIG_MACH_EUKREA_CPUIMX51SD) +=3D mach-cpuimx51sd.o
diff --cc arch/arm/mach-imx/common.h
index baf439dc22d8,4dd932af708c..000000000000
--- a/arch/arm/mach-imx/common.h
+++ b/arch/arm/mach-imx/common.h
@@@ -144,11 -145,19 +145,17 @@@ void imx6sl_set_wait_clk(bool enter)
  void imx_cpu_die(unsigned int cpu);
  int imx_cpu_kill(unsigned int cpu);
 =20
 +void imx6q_pm_init(void);
 +void imx6q_pm_set_ccm_base(void __iomem *base);
  #ifdef CONFIG_PM
+ void imx6_suspend(void __iomem *ocram_vbase);
 -void imx6q_pm_init(void);
+ void imx6dl_pm_init(void);
+ void imx6sl_pm_init(void);
 -void imx6q_pm_set_ccm_base(void __iomem *base);
  void imx5_pm_init(void);
  #else
+ static inline void imx6_suspend(void __iomem *ocram_vbase) {}
 -static inline void imx6q_pm_init(void) {}
+ static inline void imx6dl_pm_init(void) {}
+ static inline void imx6sl_pm_init(void) {}
 -static inline void imx6q_pm_set_ccm_base(void __iomem *base) {}
  static inline void imx5_pm_init(void) {}
  #endif
 =20

--Signature=_Thu__20_Feb_2014_11_42_42_+1100_bK+0maUKHdFP2HKR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTBU+GAAoJEMDTa8Ir7ZwV2voP+wbLcUkUxOgRt5k/6UamuF+9
efwZgmK9TebxNsAWtzUmSaEPoNElnAyYs3zn7phBLBHYAc62HwvByLW0i4KDObzF
oL8JRw5g+HbPVDarnJiMKoe5pOmrKd5Mzaaie6RX1EBwNfhrv4yQVJsQOkgMxoH8
InBXdFlDY+Nu/bR2CcpO96tksDGaBSG7+NKzVmuenySa3x0+0HEDnNOS7lUaIj/5
CuELptVaIzF2pIT3Pjm8KVVe5AQlGhU7mn/mnFFOS5nhB+WQ3guExybMblo3fz9M
sT10kPIXB1CVwpG4y9XGQ1siU2xEYFFqHvSu6J0O6FGvJrWrS4UEiiJGrt10UQqo
QwH2vxMPbajJQsLsJdxMOJ0+6HYsA+2KHGWDo6gSjoMY4PdpeSNIFLmXibYGicde
tN6nTFBTcKFbQwrvjk+ExXDw6fzn+0bz/YCkOBa2VlcXj9GAMSjIhZdYNf8xZfVm
m0zwtpv1CW+sQ7kelmvQhrqP9e/omddl79dxYttrEujDrPr7PQmKiBb4qHfihC71
dD9sFZJT53h2Ww74Q0aLDX6wSz3bFws3oLU3mYLB2iYwCQ1ca9cDN0NE5kkA8tMQ
PtbCX6yh1JesEuEgLMDxadlTwyPJu81NJkCPTm95c1qgubAOrSG7E9jmz+Yylf4V
KbZodnzIW3qXCFDiGfhd
=pnt+
-----END PGP SIGNATURE-----

--Signature=_Thu__20_Feb_2014_11_42_42_+1100_bK+0maUKHdFP2HKR--
