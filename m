Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459AbaFDHKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 03:10:37 -0400
Received: from ozlabs.org ([103.22.144.67]:34694 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755226AbaFDHKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 03:10:36 -0400
Date: Wed, 4 Jun 2014 17:10:28 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mike Turquette <mturquette@linaro.org>, Chris Ball <chris@printf.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roger Tseng <rogerable@realtek.com>,
        David =?UTF-8?B?TGFuemVuZMO2cmZlcg==?= 
	<david.lanzendoerfer@o2s.ch>
Subject: linux-next: manual merge of the clk tree with the mmc tree
Message-ID: <20140604171028.4ea86dc4@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/5/VjmG9F+0bUCcdZ.cAmunR"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/5/VjmG9F+0bUCcdZ.cAmunR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Mike,

Today's linux-next merge of the clk tree got a conflict in
drivers/mmc/host/Kconfig between commit c7f6558d84af ("mmc: Add realtek
USB sdmmc host driver") from the mmc tree and commit 3cbcb16095f9
("mmc: sunxi: Add driver for SD/MMC hosts found on Allwinner sunxi
SoCs") from the clk tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mmc/host/Kconfig
index fd4aab9b79e2,d50ac1ca11ea..000000000000
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@@ -704,9 -695,9 +704,16 @@@ config MMC_REALTEK_PC
  	  Say Y here to include driver code to support SD/MMC card interface
  	  of Realtek PCI-E card reader
 =20
 +config MMC_REALTEK_USB
 +	tristate "Realtek USB SD/MMC Card Interface Driver"
 +	depends on MFD_RTSX_USB
 +	help
 +	  Say Y here to include driver code to support SD/MMC card interface
 +	  of Realtek RTS5129/39 series card reader
++
+ config MMC_SUNXI
+ 	tristate "Allwinner sunxi SD/MMC Host Controller support"
+ 	depends on ARCH_SUNXI
+ 	help
+ 	  This selects support for the SD/MMC Host Controller on
+ 	  Allwinner sunxi SoCs.

--Sig_/5/VjmG9F+0bUCcdZ.cAmunR
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTjsZpAAoJEMDTa8Ir7ZwVLV8QAJI2lmPaE4y9c7wtZMG1NGMx
ZCj8v3tJAUA7w0aU2eDJ2RsJFUFZmTBRsVz1/xd35IoMCeY3c0IRu8YTJVuDZcq3
YaQFFQ2mHKo+PiwjSatN8Xkt+4rkgSvlgMhAWpUW2f0b+j3k82UqdvbLhod/VeOa
CytwTTkJb0NH/0jMJ7uJthdDSpv6+283R7G+aXNyPR/PhIZ9E5QbAL8HrP/Wyc4l
KXlnYL0eBIiqiYGVHFDYFlir/9GHitLJme4awjwbvMOUpNYIza9r0Zgtu3Apq89e
JG3V5CVa2VLo83Xhx4pwVcdAfj2esWjE7uEAYYovggKmENexsO+Q9nhZ1PoJj9BT
LBgy5CxEL86PYTyMIBYTIGADUthUHVpdO89JCby/a46+FySf/LNLaMRl7xETynbm
w8IUP26sZt8nfTmbY+qgmFVJH+WvT5PygO+mlu8MHlI7d6fOz5+lYmvrV5lZR1W7
89ArB1mWxM+7nCDKovdxL/49kdwxHR9N+bATKbLjsHRZkdy6FnCvFNNMxd3zDCYK
+Oi2ae2iFIZfFf4PkjrPowGtHkWNRGteBicDwb3hMgk8QpEPec9mlhA8/TRPRcGs
nDjOmIQNcPIs8qI52061y18ar2kOs6ygUHIeC5xd0it4qKZpKucBapLMo5FwbRAf
FWrGBYjcQK+EGcVYtQzV
=cyQ3
-----END PGP SIGNATURE-----

--Sig_/5/VjmG9F+0bUCcdZ.cAmunR--
