Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238AbaCQFfT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 01:35:19 -0400
Received: from ozlabs.org ([203.10.76.45]:45012 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbaCQFfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 01:35:18 -0400
Date: Mon, 17 Mar 2014 16:35:06 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh@kernel.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: linux-next: manual merge of the tip tree with the arm-soc tree
Message-Id: <20140317163506.5770f06a77ba011e682f47ff@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Mar_2014_16_35_06_+1100_ZgO=MpxIl+oEqYDa"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Mar_2014_16_35_06_+1100_ZgO=MpxIl+oEqYDa
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/arm/mach-zynq/Kconfig between commit ddb902cc3459 ("ARM: centralize
common multi-platform kconfig options") from the arm-soc tree and commit
cd325295871f ("arm: zynq: Add support for cpufreq") from the tip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-zynq/Kconfig
index 105d39b72a25,f03e75bd0b2b..000000000000
--- a/arch/arm/mach-zynq/Kconfig
+++ b/arch/arm/mach-zynq/Kconfig
@@@ -2,10 -2,19 +2,12 @@@ config ARCH_ZYN
  	bool "Xilinx Zynq ARM Cortex A9 Platform" if ARCH_MULTI_V7
  	select ARM_AMBA
  	select ARM_GIC
+ 	select ARCH_HAS_CPUFREQ
+ 	select ARCH_HAS_OPP
 -	select COMMON_CLK
 -	select CPU_V7
 -	select GENERIC_CLOCKEVENTS
  	select HAVE_ARM_SCU if SMP
  	select HAVE_ARM_TWD if SMP
  	select ICST
 -	select MIGHT_HAVE_CACHE_L2X0
 -	select USE_OF
 -	select HAVE_SMP
 -	select SPARSE_IRQ
  	select CADENCE_TTC_TIMER
- 	select ARM_GLOBAL_TIMER
+ 	select ARM_GLOBAL_TIMER if !CPU_FREQ
  	help
  	  Support for Xilinx Zynq ARM Cortex A9 Platform

--Signature=_Mon__17_Mar_2014_16_35_06_+1100_ZgO=MpxIl+oEqYDa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTJomOAAoJEMDTa8Ir7ZwV/TIP/0g/4oUhwSIJE3MmEsbgZNud
PWBa5n6NaTo27vILHhbcurzBmUqXvpNCOMe3KaU3fQvPAm08vSyqZ+QfZnw0OmFC
lK+PaeXvmfsQoS2jJgiAEdaWuyHUP5Y4V1Z2J/i0789Fc4Ad2sZL9ZmEKh0Mlbpd
gUyLDYHARGxXWTq5P8n1315NBXDj+F/WGdnkwvxkodFRD3s/UOpQtC26fdC5+YrS
iW0nXUx9zMsQudGKa3K+0VUGrhTHTpcIXuBN2i4AA7QPs9LN0a9ZKpHkpF62kRE3
gSOQtIP3JrabSjjum/1hz/P4ElcPphM+ETn/KFbcQmY//Rb2zN82GBYFRVCfYP3s
xhtAICdLHwGde8y7Rb5jkyNZdDLSZYLfV3SuP/w1UgV6vV0dhSE1V4ZiPEA9UBPZ
uv+RiK3MhsOuyTm33hvG9VKFAqwouDTCtoh129WjXDHXnpnR1ybDXV9kCxpVpthn
/pU/fSzeN8q9qankOj+CiHnBIfChHNLEFiicJI95xiuC4aArqkT5VZYoJ67v0R7X
vHgdZib0k0XR73FTIuOzaVa/qRV/MyMTJcoATK0IHqxfaQeomvfGbd7RMOaMkqwE
xARFoFwdHlb+Vx4QKMNidzXWtOiqqFY6DlV/BqPGgn66SNDzmn4j3got272QKQTf
uZz7b5mtP6Cx7Dl+/OgF
=wcjY
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Mar_2014_16_35_06_+1100_ZgO=MpxIl+oEqYDa--
