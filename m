Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbaCCHNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 02:13:46 -0500
Received: from ozlabs.org ([203.10.76.45]:49552 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbaCCHNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 02:13:44 -0500
Date: Mon, 3 Mar 2014 18:13:37 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>, Rob Herring <robh@kernel.org>
Subject: linux-next: manual merge of the usb tree with the arm-soc tree
Message-Id: <20140303181337.186b799feeb9ca132a7579a1@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__3_Mar_2014_18_13_37_+1100_M+PlLfFaA3r.vuGY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__3_Mar_2014_18_13_37_+1100_M+PlLfFaA3r.vuGY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
arch/arm/mach-tegra/Kconfig between commit ddb902cc3459 ("ARM: centralize
common multi-platform kconfig options") from the arm-soc tree and commit
f6723b569a67 ("usb: host: remove selects of USB_ARCH_HAS_?HCI") from the
usb tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-tegra/Kconfig
index f61cd5b9f103,4926bd11f190..000000000000
--- a/arch/arm/mach-tegra/Kconfig
+++ b/arch/arm/mach-tegra/Kconfig
@@@ -12,9 -18,10 +12,8 @@@ config ARCH_TEGR
  	select ARCH_HAS_RESET_CONTROLLER
  	select RESET_CONTROLLER
  	select SOC_BUS
- 	select USB_ARCH_HAS_EHCI if USB_SUPPORT
 -	select SPARSE_IRQ
  	select USB_ULPI if USB_PHY
  	select USB_ULPI_VIEWPORT if USB_PHY
 -	select USE_OF
  	help
  	  This enables support for NVIDIA Tegra based systems.
 =20

--Signature=_Mon__3_Mar_2014_18_13_37_+1100_M+PlLfFaA3r.vuGY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTFCulAAoJEMDTa8Ir7ZwVnfoP/1xaFslef1q0dA+GB1Femfjm
WOOvvitg27++Qk8jRGaRFyRemsIZrdBtejK1sxA+wxY3S0MaJkEx5BBazauCnssZ
lzIbYNq6RqsIJAN6VcINiUsfJ6P3lRh3KZejwjlmgfR1EKn8RZo2qI5WxA96sTfp
WAj73q5jCAft3oTHtq6hynOouu0fjkYDbu4QOq3ym5aqeVWPEC68oaNBNdMRQGt5
RLBwfg0Jlhq63vsxWWeE/0/AKb+I7NcpnjB/4WCkdT5YhlRtK3T8vY3cB/RSmWV7
rWc0QnxV63Cdu95LiHHeFY6aWW44NXCTsJcRamldUrzK01krBExJIRVEUJ/a8Yhq
Lav2uyyZt2FGskC7Sbt2OZOn8eRFYPpMKuVbGne3XGe1rdhFwKU47ZTD3ddf7+OS
8SrwgYCvlZH3nPA3dor0kW1/IJZ8xEQP5v56ht1PFtwkD6tMzgMpFFTnSjkK9FJG
31ogUNU+VYIrR3tChOJ2DY3BgprmjKeJiNCPbyH4KaRPhHmWoQ7KmYU3mqfcDH2f
5w4OsOSHesZBO8vHaqlgfHnXe0CE7aOATu4mKu6o5c3AgquXzV2sGUoK8zdIldTP
iIgH2tRuw9xiPSh6kKMxZeziB7yPWLighxLcVQkEsftrfKoBsnwnFjATfkhbttyx
tJP23M2Nv7KBkrMP7UEv
=TC8J
-----END PGP SIGNATURE-----

--Signature=_Mon__3_Mar_2014_18_13_37_+1100_M+PlLfFaA3r.vuGY--
