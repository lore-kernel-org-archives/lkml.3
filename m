Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbaCQFb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 01:31:26 -0400
Received: from ozlabs.org ([203.10.76.45]:44804 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbaCQFbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 01:31:24 -0400
Date: Mon, 17 Mar 2014 16:31:06 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Simon Horman <horms@verge.net.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Magnus Damm <damm@opensource.se>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Wolfram Sang <wsa@sang-engineering.com>
Subject: linux-next: manual merge of the tip tree with the renesas tree
Message-Id: <20140317163106.7d1188b5a3ac41a75a060bee@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Mar_2014_16_31_06_+1100_OPQzid08TD/UW.1i"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Mar_2014_16_31_06_+1100_OPQzid08TD/UW.1i
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/arm/mach-shmobile/Kconfig between commit 4a51856b4267 ("ARM:
shmobile: Use 64-bit dma_addr_t on r8a7790/r8a7791") from the renesas
tree and commit aeb8fb7910fc ("ARM: shmobile: Remove CMT, TMU and STI
Kconfig entries") from the tip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-shmobile/Kconfig
index 5249ff0511a8,f6db7dcae3f4..000000000000
--- a/arch/arm/mach-shmobile/Kconfig
+++ b/arch/arm/mach-shmobile/Kconfig
@@@ -116,7 -137,7 +130,8 @@@ config ARCH_R8A779
  	select MIGHT_HAVE_PCI
  	select SH_CLK_CPG
  	select RENESAS_IRQC
 +	select ARCH_DMA_ADDR_T_64BIT if ARM_LPAE
+ 	select SYS_SUPPORTS_SH_CMT
 =20
  config ARCH_R8A7791
  	bool "R-Car M2 (R8A77910)"
@@@ -126,7 -147,7 +141,8 @@@
  	select MIGHT_HAVE_PCI
  	select SH_CLK_CPG
  	select RENESAS_IRQC
 +	select ARCH_DMA_ADDR_T_64BIT if ARM_LPAE
+ 	select SYS_SUPPORTS_SH_CMT
 =20
  config ARCH_EMEV2
  	bool "Emma Mobile EV2"

--Signature=_Mon__17_Mar_2014_16_31_06_+1100_OPQzid08TD/UW.1i
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTJoieAAoJEMDTa8Ir7ZwVqT8QAIC0REcN1h/GvNP/eXo1Cl9m
/LGJWHhr/YUJbCgoi77q+BlenqkwMVoYoJA6KZj+Yf8PsvmzNMz0sM++px0uuXya
dHH+uWFcR/1IHqevOoSO54gjfiP4/qSyPzzB0b89VrSzAmZwPakX7wzlSmHwzVUU
VIHGQhNzXjv4ZA3f2YRPIJVPMeTf2lbEBy9Q9ihzylSkF307o2D4/3J2XRSLSc0j
c/qIBBoENayNHaXG1y4jyIdDvtkBdeianZGpSQwNmP1ZssHbh6OW7UT5pcgtw02K
8DkuafzrzX6HwCrZdrhGhG9F5/Eg2+ZMegE3rD2k8YWRJsOOfqw3GSjHkBrSeTmC
7PBVK9DJZ1aAWIAhQvcF0wsOC8n00S/2BTHV8il34n2TYDV78+phSmg1Y1My3ilD
L5En9etXVMFBE+cBYteliGUvyZAl+U3Pdtbo+Xl/ODTuf1K42E1zWAM5vBRhOrMQ
JNgDIKfCT+LlvyEH+2sH1nqwcOvJFNtJ0GLAoYdCp72cO43H7R8fsAKu4ZgkrfJf
rm5KIpacxnJfdLSZa/FZIymQkua952od8TMEjYYJ+2Tte2VSIqom0GE31nrGaHSX
Ndkq4TrwjFyDP9276OnHYxqBO5Geeaa4BJCd+ySdlE1CvuJ+YiZckxzPHq4Mzjsi
GXgfC61uEU/5TXhpZgTb
=hpW4
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Mar_2014_16_31_06_+1100_OPQzid08TD/UW.1i--
