Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbaFOX7n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 19:59:43 -0400
Received: from ozlabs.org ([103.22.144.67]:41875 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844AbaFOX7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 19:59:41 -0400
Date: Mon, 16 Jun 2014 09:59:28 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Shawn Guo <shawn.guo@linaro.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: linux-next: manual merge of the imx-mxs tree with the  tree
Message-ID: <20140616095928.1f21f8af@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/t4dUruJqaDWz5DhGfyPsIWp"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/t4dUruJqaDWz5DhGfyPsIWp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Shawn,

Today's linux-next merge of the imx-mxs tree got a conflict in
arch/arm/mach-imx/Kconfig between commit e49d9b375628 ("ARM: Remove
ARCH_HAS_CPUFREQ config option") from the arm-soc tree and commit
7de46855b1e7 ("ARM: imx5: move SOC_IMX5 and SOC_IMX51 into 'Device tree
only'") from the imx-mxs tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-imx/Kconfig
index 28fa2fa49e5d,3b2a5c58cf91..000000000000
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@@ -700,9 -691,15 +688,14 @@@ if ARCH_MULTI_V
 =20
  comment "Device tree only"
 =20
+ config SOC_IMX5
+ 	bool
 -	select ARCH_HAS_CPUFREQ
+ 	select ARCH_HAS_OPP
+ 	select HAVE_IMX_SRC
+ 	select MXC_TZIC
+=20
  config	SOC_IMX50
  	bool "i.MX50 support"
- 	select HAVE_IMX_SRC
  	select PINCTRL_IMX50
  	select SOC_IMX5
 =20

--Sig_/t4dUruJqaDWz5DhGfyPsIWp
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTnjNoAAoJEMDTa8Ir7ZwV15gP/2eGlu++bt+HqDVWGygYgaMz
soSL2wcQUgMi5l3HyPc6NR9++FidLh0TEPPxROaWHyouBbWngaBb2/I86kHfGsnO
qcjeqzWZnEKyIqWaamFu6tjrVSHpfmvriThPAUdNWPfx6BCvOUsLpdsqBRNUB6vt
ur6y0aXCbMwWMRPKmaLer1wYSZSC0wz6OxZTQCP4hCnuvcpi0cDUzMEB66nAyVKw
GIaS4EO9BMYSRGb410QVVhNGa4NssF/CqIC1ANfI8SZ4PnGabdBfrFc3pP8cTQVN
7oRfNoJ9kICETdUlKnD9E5Ejt1XMoSNrk2Fdx2Pq9ASp5zMuu3xoe9SJx4QECPC0
KZXhH/Iv1fAHuKAKOR11+Ot41PpggV5R5xNnVjtjVgx0rzKHRflRkMFmsUFUcil9
lVLmfmIyEXX2O1cgt4KTD703aKhgg2lBb+l9WFXPS3q+VAjD5W0EU2kaUya71YR4
cvhz+Brs+kGSWGgMGKAOjdSEpGxEG18RluDMTmV1bCzOY9xD1T+Ft0K7oW8Jxdvq
ZE3WG6oIlmHiY2dIEHIYaKZpNAH0Y3f6NjTMxex1JuQEmzmwe6tmnJ2m8oDUt+Jw
wevjNhL5DUyUDTu/bpe4QG/NK2m3tGxA1V6fsMsils0kY7DEeZ9imgMAa0vU2vzJ
wptohuiECeLfpSiteExR
=0Rp7
-----END PGP SIGNATURE-----

--Sig_/t4dUruJqaDWz5DhGfyPsIWp--
