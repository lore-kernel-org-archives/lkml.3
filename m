Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263AbaCQHbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 03:31:33 -0400
Received: from ozlabs.org ([203.10.76.45]:41175 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756205AbaCQHbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 03:31:32 -0400
Date: Mon, 17 Mar 2014 18:31:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>, Magnus Damm <damm@opensource.se>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Wolfram Sang <wsa@sang-engineering.com>
Subject: linux-next: manual merge of the usb tree with the tip tree
Message-Id: <20140317183126.7c8ba1901c81fbb9ace00f20@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Mar_2014_18_31_26_+1100_0/WqZK3sjMBNdq99"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Mar_2014_18_31_26_+1100_0/WqZK3sjMBNdq99
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
arch/arm/mach-shmobile/Kconfig between commit aeb8fb7910fc ("ARM:
shmobile: Remove CMT, TMU and STI Kconfig entries") from the tip tree and
commit f6723b569a67 ("usb: host: remove selects of USB_ARCH_HAS_?HCI")
from the usb tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-shmobile/Kconfig
index 9f68d2aa2a12,a06590237209..000000000000
--- a/arch/arm/mach-shmobile/Kconfig
+++ b/arch/arm/mach-shmobile/Kconfig
@@@ -107,9 -102,6 +107,7 @@@ config ARCH_R8A777
  	select CPU_V7
  	select SH_CLK_CPG
  	select ARM_GIC
- 	select USB_ARCH_HAS_EHCI
- 	select USB_ARCH_HAS_OHCI
 +	select SYS_SUPPORTS_SH_TMU
 =20
  config ARCH_R8A7779
  	bool "R-Car H1 (R8A77790)"
@@@ -117,10 -109,7 +115,8 @@@
  	select ARM_GIC
  	select CPU_V7
  	select SH_CLK_CPG
- 	select USB_ARCH_HAS_EHCI
- 	select USB_ARCH_HAS_OHCI
  	select RENESAS_INTC_IRQPIN
 +	select SYS_SUPPORTS_SH_TMU
 =20
  config ARCH_R8A7790
  	bool "R-Car H2 (R8A77900)"

--Signature=_Mon__17_Mar_2014_18_31_26_+1100_0/WqZK3sjMBNdq99
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTJqTSAAoJEMDTa8Ir7ZwVQlkP/0UoxZgj2pCUv3XCUwfBQ3Hw
gtIWxr/X8wTKjXrc3/UdaAQSWitkFNGVE4ChDZ+0kizQRyx5k8vRJzar6IU5+JNE
iV4SAfy6BjiWTqjBnwPOE/88c/WfICBgmUjo0/lcU5Xl9xQefwLD3HHUjkqD4Wz8
CaBN3+qmJh0d1wLuYvLyuAbz2CRLnmUv7O4nwsnJz1iYt6iYsi+XtAD6mLogN2S+
Nhgvr7sRGI+zBFWAsERX/ZW4d2cC7iNqewdlUY/wbbznPy9yqAErINRuQUEyZB5O
VKnq0eHEnXmTMZbwtO2vDI5yL1eMRF9ZhM8Y4M8FvZkR2BSC07yqlUKiRVY8fIoN
YNqKixAlXDjNI+oBDiQNNu0VezEUGMs/HytS6pdShNsfdCfrFhETbADr0Nea7/3U
5towk2ZSv4Sp1him0Wk7gEsGosGgkLZqkgEpagJ0Jdy8DPkE+irvcCqrJw88XXsW
EvlzovJDKlLOJMAjpK694bKO2k7wwNhv6GH75NHlY4Hdh1o3db1/7gxtFsV4SF89
/YV7tzuxUqZFQLd07lHjWL7U1lpBxlCN3oO82S/WPV21BWKE+YbH56ZLAMXCRXLZ
HoGxWoE2kXTvjC/ykMjYrBF15zKnhsbsh4HrNTdQE0yOmL7kGko6UhiApn3HgIUM
Cyvfl2d6N+BkwecTrl/y
=ri7L
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Mar_2014_18_31_26_+1100_0/WqZK3sjMBNdq99--
