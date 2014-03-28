Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528AbaC1DrZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 23:47:25 -0400
Received: from ozlabs.org ([203.10.76.45]:45678 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757242AbaC1DrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 23:47:24 -0400
Date: Fri, 28 Mar 2014 14:47:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Rob Herring <robh@kernel.org>, Michal Simek <michal.simek@xilinx.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: linux-next: manual merge of the tip tree with the arm-soc tree
Message-Id: <20140328144715.3798b9a7ee033de0ee40f359@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__28_Mar_2014_14_47_15_+1100_ZLRNTrWxFy2x78Vd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__28_Mar_2014_14_47_15_+1100_ZLRNTrWxFy2x78Vd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/arm/mach-zynq/Kconfig between commits ddb902cc3459 ("ARM: centralize
common multi-platform kconfig options") and 016f4dcae81e ("ARM: zynq:
Split slcr in two parts") from the arm-soc tree and commits 61f1fc7e9258
("arm: zynq: Don't use arm_global_timer with cpufreq") and cd325295871f
("arm: zynq: Add support for cpufreq") from the tip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-zynq/Kconfig
index cd2d55ab834a,f03e75bd0b2b..000000000000
--- a/arch/arm/mach-zynq/Kconfig
+++ b/arch/arm/mach-zynq/Kconfig
@@@ -2,11 -2,19 +2,13 @@@ config ARCH_ZYN
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
 +	select MFD_SYSCON
  	help
  	  Support for Xilinx Zynq ARM Cortex A9 Platform

--Signature=_Fri__28_Mar_2014_14_47_15_+1100_ZLRNTrWxFy2x78Vd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTNPDKAAoJEMDTa8Ir7ZwVQnQQAIFejjfzypqCLus/Js51hWiw
NUI1WziHs9vssPLTVJcFlWFrp8TVkrAubha5Dll8g3mkgPIvq9mNEqqKZQKCq6WT
3LHxnyoC1THIgkJhzmjOxMREb/HIC0Gke0h7aUKnnDNfjxXqCErLPeOhS84FOIni
e071IU3SEJiq/UqOOaaTusc8j+h1R4MEfBZAQ9ibqYlYNUr8hcUdEHMQ6OZTPxt6
QRCAcUCkyU4JTihE3UoyHER8FxocwQUXkx8SPMFHLMWKmI2MUXG4q7t5ssiMvXs2
QudEqPnCkTtoOO4bkQGEO9ohSOxBy5q+Y8eIqgICoTzdDgmnwpoia2wSPfQcyyw4
ZE4uyUcOfXyPpoXWpZNaYyLFLtJ3YwxWdNPDnQrfwQmHcEWK9Ni2qTRhIEN6eVnD
b4oALbPZR/n5zoihaU0n5INaVdE+3tkPEAPs0voeAShGANuOTLxfpmLAhEu3Su4p
8/hDwMU5ss3G7JiuTaNzutH1IW8Q/TawkNSMGYFXGbbZ3ZU1PT40HR1s029buYxO
ewu0OTT97drx0HkMF5W8+ujd3mFQNdglpLu4tjWHR0TRiYDvXMv7c1yKI6TCeM2f
403NaNWWWgLCHAEW/J5A/ZAGMMnl9vWmWzXxn2Nz4of3QSfp0MLyOzLLaGKGzv1O
c2FL67AyBRSl7hnnTIyF
=wMw3
-----END PGP SIGNATURE-----

--Signature=_Fri__28_Mar_2014_14_47_15_+1100_ZLRNTrWxFy2x78Vd--
